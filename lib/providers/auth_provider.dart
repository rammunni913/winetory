import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';
import '../utils/constants.dart';

class AuthProvider with ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  Future<bool> login(String mobile, String password) async {
    try {
      setLoading(true);
      setError(null);

      // Check in Firestore for users (including super admin)
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(AppConstants.usersCollection)
          .where('mobile', isEqualTo: mobile)
          .where('isActive', isEqualTo: true)
          .get();

      if (querySnapshot.docs.isEmpty) {
        setError('User not found or inactive. Please check your mobile number.');
        setLoading(false);
        return false;
      }

      DocumentSnapshot doc = querySnapshot.docs.first;
      UserModel user = UserModel.fromFirestore(doc);

      if (user.password != password) {
        setError('Invalid password. Please try again.');
        setLoading(false);
        return false;
      }

      _currentUser = user;
      
      // Save to SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_id', user.id);
      await prefs.setString('user_role', user.role);

      setLoading(false);
      return true;
    } catch (e) {
      if (e.toString().contains('offline')) {
        setError('No internet connection. Please check your network and try again.');
      } else if (e.toString().contains('unavailable')) {
        setError('Firebase service is currently unavailable. Please try again later.');
      } else {
        setError('Login failed: ${e.toString()}');
      }
      setLoading(false);
      return false;
    }
  }

  Future<void> _createInitialSuperAdmin() async {
    await FirebaseFirestore.instance
        .collection(AppConstants.usersCollection)
        .doc('super_admin')
        .set({
      'mobile': AppConstants.defaultSuperAdminMobile,
      'password': AppConstants.defaultSuperAdminPassword,
      'role': AppConstants.superAdminRole,
      'name': 'Super Admin',
      'isActive': true,
      'email': 'superadmin@winetory.com',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'permissions': {
        'manage_users': true,
        'manage_shops': true,
        'manage_products': true,
        'manage_stock': true,
        'manage_sales': true,
        'manage_expenses': true,
        'view_reports': true,
        'send_notifications': true,
      },
    });
  }

  Future<bool> updateSuperAdminCredentials(String newMobile, String newPassword) async {
    try {
      setLoading(true);
      setError(null);

      // Update in Firestore
      await FirebaseFirestore.instance
          .collection(AppConstants.usersCollection)
          .doc('super_admin')
          .set({
        'mobile': newMobile,
        'password': newPassword,
        'role': AppConstants.superAdminRole,
        'name': 'Super Admin',
        'isActive': true,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      _currentUser = _currentUser?.copyWith(
        mobile: newMobile,
        password: newPassword,
        updatedAt: DateTime.now(),
      );

      setLoading(false);
      return true;
    } catch (e) {
      setError('Update failed: ${e.toString()}');
      setLoading(false);
      return false;
    }
  }

  Future<bool> createUser(UserModel user) async {
    try {
      setLoading(true);
      setError(null);

      await FirebaseFirestore.instance
          .collection(AppConstants.usersCollection)
          .doc(user.id)
          .set(user.toFirestore());

      setLoading(false);
      return true;
    } catch (e) {
      setError('User creation failed: ${e.toString()}');
      setLoading(false);
      return false;
    }
  }

  Future<bool> updateUser(UserModel user) async {
    try {
      setLoading(true);
      setError(null);

      await FirebaseFirestore.instance
          .collection(AppConstants.usersCollection)
          .doc(user.id)
          .update(user.toFirestore());

      if (_currentUser?.id == user.id) {
        _currentUser = user;
      }

      setLoading(false);
      return true;
    } catch (e) {
      setError('User update failed: ${e.toString()}');
      setLoading(false);
      return false;
    }
  }

  Future<List<UserModel>> getUsersByRole(String role) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(AppConstants.usersCollection)
          .where('role', isEqualTo: role)
          .where('isActive', isEqualTo: true)
          .get();

      return querySnapshot.docs
          .map((doc) => UserModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      setError('Failed to fetch users: ${e.toString()}');
      return [];
    }
  }

  Future<UserModel?> getUserById(String userId) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .get();

      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      setError('Failed to fetch user: ${e.toString()}');
      return null;
    }
  }

  Future<void> logout() async {
    _currentUser = null;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');
    await prefs.remove('user_role');
    notifyListeners();
  }

  Future<bool> checkAuthStatus() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('user_id');
      
      if (userId != null) {
        UserModel? user = await getUserById(userId);
        if (user != null) {
          _currentUser = user;
          return true;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
