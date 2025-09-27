import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/shop_model.dart';
import '../utils/constants.dart';

class ShopProvider with ChangeNotifier {
  List<ShopModel> _shops = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<ShopModel> get shops => _shops;
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

  Future<void> fetchShops() async {
    try {
      setLoading(true);
      setError(null);

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(AppConstants.shopsCollection)
          .orderBy('createdAt', descending: true)
          .get();

      _shops = querySnapshot.docs
          .map((doc) => ShopModel.fromFirestore(doc))
          .toList();

      setLoading(false);
    } catch (e) {
      setError('Failed to fetch shops: ${e.toString()}');
      setLoading(false);
    }
  }

  Future<bool> createShop(ShopModel shop) async {
    try {
      setLoading(true);
      setError(null);

      await FirebaseFirestore.instance
          .collection(AppConstants.shopsCollection)
          .doc(shop.id)
          .set(shop.toFirestore());

      _shops.insert(0, shop);
      setLoading(false);
      return true;
    } catch (e) {
      setError('Failed to create shop: ${e.toString()}');
      setLoading(false);
      return false;
    }
  }

  Future<bool> updateShop(ShopModel shop) async {
    try {
      setLoading(true);
      setError(null);

      await FirebaseFirestore.instance
          .collection(AppConstants.shopsCollection)
          .doc(shop.id)
          .update(shop.toFirestore());

      int index = _shops.indexWhere((s) => s.id == shop.id);
      if (index != -1) {
        _shops[index] = shop;
      }

      setLoading(false);
      return true;
    } catch (e) {
      setError('Failed to update shop: ${e.toString()}');
      setLoading(false);
      return false;
    }
  }

  Future<bool> deactivateShop(String shopId) async {
    try {
      setLoading(true);
      setError(null);

      await FirebaseFirestore.instance
          .collection(AppConstants.shopsCollection)
          .doc(shopId)
          .update({'isActive': false, 'updatedAt': FieldValue.serverTimestamp()});

      int index = _shops.indexWhere((s) => s.id == shopId);
      if (index != -1) {
        _shops[index] = _shops[index].copyWith(isActive: false);
      }

      setLoading(false);
      return true;
    } catch (e) {
      setError('Failed to deactivate shop: ${e.toString()}');
      setLoading(false);
      return false;
    }
  }

  Future<String> generateShopCode() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(AppConstants.shopsCollection)
          .get();

      int count = querySnapshot.docs.length;
      String shopCode = '${AppConstants.shopCodePrefix}-${String.fromCharCode(65 + (count % 26))}${(count + 1).toString().padLeft(3, '0')}';
      
      return shopCode;
    } catch (e) {
      return '${AppConstants.shopCodePrefix}-A001';
    }
  }

  ShopModel? getShopById(String shopId) {
    try {
      return _shops.firstWhere((shop) => shop.id == shopId);
    } catch (e) {
      return null;
    }
  }

  List<ShopModel> getActiveShops() {
    return _shops.where((shop) => shop.isActive).toList();
  }

  Future<void> assignSalesmanToShop(String shopId, String salesmanId, String salesmanName) async {
    try {
      setLoading(true);
      setError(null);

      ShopModel? shop = getShopById(shopId);
      if (shop != null) {
        List<String> assignedSalesmen = List.from(shop.assignedSalesmen ?? []);
        if (!assignedSalesmen.contains(salesmanId)) {
          assignedSalesmen.add(salesmanId);
        }

        await FirebaseFirestore.instance
            .collection(AppConstants.shopsCollection)
            .doc(shopId)
            .update({
          'assignedSalesmen': assignedSalesmen,
          'updatedAt': FieldValue.serverTimestamp(),
        });

        int index = _shops.indexWhere((s) => s.id == shopId);
        if (index != -1) {
          _shops[index] = _shops[index].copyWith(assignedSalesmen: assignedSalesmen);
        }
      }

      setLoading(false);
    } catch (e) {
      setError('Failed to assign salesman: ${e.toString()}');
      setLoading(false);
    }
  }
}
