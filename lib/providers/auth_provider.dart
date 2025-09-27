
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

      // Step 1: Find user email from mobile number
      QuerySnapshot userQuery = await FirebaseFirestore.instance
          .collection(AppConstants.usersCollection)
          .where('mobile', isEqualTo: mobile)
          .where('isActive', isEqualTo: true)
          .limit(1)
          .get();

      if (userQuery.docs.isEmpty) {
        setError('User not found or inactive. Please check your mobile number.');
        setLoading(false);
        return false;
      }

      DocumentSnapshot userDoc = userQuery.docs.first;
      String? email = userDoc.get('email');

      if (email == null) {
        setError('User does not have an email address. Please contact support.');
        setLoading(false);
        return false;
      }

      // Step 2: Sign in with email and password using Firebase Auth
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Step 3: Get user data from Firestore
      _currentUser = UserModel.fromFirestore(userDoc);
      
      // Save to SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_id', _currentUser!.id);
      await prefs.setString('user_role', _currentUser!.role);

      setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password' || e.code == 'invalid-credential') {
        setError('Invalid credentials. Please check your mobile or password.');
      } else if (e.code == 'network-request-failed') {
        setError('No internet connection. Please try again.');
      } else {
        setError('An unknown error occurred. Please try again later.');
      }
      setLoading(false);
      return false;
    } catch (e) {
        setError('An unknown error occurred: Please try again later.');
        setLoading(false);
        return false;
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    _currentUser = null;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    notifyListeners();
  }

  Future<bool> checkAuthStatus() async {
    try {
      User? firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser == null) return false;

      // In my previous change, I was checking the stored user ID against the firebaseUser.uid.
      // However, the user ID in firestore is the document ID, not the auth UID.
      // So, I will fetch user from shared preferences and check if it exists.
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('user_id');

      if (userId == null) return false;
      
      UserModel? user = await getUserById(userId);
      if (user != null) {
        _currentUser = user;
        notifyListeners();
        return true;
      }
      
      return false;
    } catch (e) {
      return false;
    }
  }
  
  Future<bool> createUser(UserModel user, String password) async {
    try {
      setLoading(true);
      setError(null);

      // Step 1: Create user in Firebase Auth
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: user.email!,
        password: password,
      );

      // Step 2: Save user data to Firestore with the UID from Auth as the document ID
      await FirebaseFirestore.instance
          .collection(AppConstants.usersCollection)
          .doc(userCredential.user!.uid)
          .set(user.copyWith(id: userCredential.user!.uid).toFirestore());

      setLoading(false);
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        setError('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        setError('An account already exists for that email.');
      } else {
        setError('User creation failed: ${e.message}');
      }
      setLoading(false);
      return false;
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
      notifyListeners();
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
}
