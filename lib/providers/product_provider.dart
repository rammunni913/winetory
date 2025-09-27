import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/product_model.dart';
import '../utils/constants.dart';

class ProductProvider with ChangeNotifier {
  List<ProductModel> _products = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<ProductModel> get products => _products;
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

  Future<void> fetchProducts({String? shopId}) async {
    try {
      setLoading(true);
      setError(null);

      Query query = FirebaseFirestore.instance
          .collection(AppConstants.productsCollection)
          .orderBy('createdAt', descending: true);

      if (shopId != null) {
        query = query.where('shopId', isEqualTo: shopId);
      }

      QuerySnapshot querySnapshot = await query.get();

      _products = querySnapshot.docs
          .map((doc) => ProductModel.fromFirestore(doc))
          .toList();

      setLoading(false);
    } catch (e) {
      setError('Failed to fetch products: ${e.toString()}');
      setLoading(false);
    }
  }

  Future<bool> createProduct(ProductModel product) async {
    try {
      setLoading(true);
      setError(null);

      await FirebaseFirestore.instance
          .collection(AppConstants.productsCollection)
          .doc(product.id)
          .set(product.toFirestore());

      _products.insert(0, product);
      setLoading(false);
      return true;
    } catch (e) {
      setError('Failed to create product: ${e.toString()}');
      setLoading(false);
      return false;
    }
  }

  Future<bool> updateProduct(ProductModel product) async {
    try {
      setLoading(true);
      setError(null);

      await FirebaseFirestore.instance
          .collection(AppConstants.productsCollection)
          .doc(product.id)
          .update(product.toFirestore());

      int index = _products.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        _products[index] = product;
      }

      setLoading(false);
      return true;
    } catch (e) {
      setError('Failed to update product: ${e.toString()}');
      setLoading(false);
      return false;
    }
  }

  Future<bool> deleteProduct(String productId) async {
    try {
      setLoading(true);
      setError(null);

      await FirebaseFirestore.instance
          .collection(AppConstants.productsCollection)
          .doc(productId)
          .update({'isActive': false, 'updatedAt': FieldValue.serverTimestamp()});

      int index = _products.indexWhere((p) => p.id == productId);
      if (index != -1) {
        _products[index] = _products[index].copyWith(isActive: false);
      }

      setLoading(false);
      return true;
    } catch (e) {
      setError('Failed to delete product: ${e.toString()}');
      setLoading(false);
      return false;
    }
  }

  ProductModel? getProductById(String productId) {
    try {
      return _products.firstWhere((product) => product.id == productId);
    } catch (e) {
      return null;
    }
  }

  List<ProductModel> getProductsByCategory(String category) {
    return _products.where((product) => product.category == category && product.isActive).toList();
  }

  List<ProductModel> getProductsByShop(String shopId) {
    return _products.where((product) => product.shopId == shopId && product.isActive).toList();
  }

  List<ProductModel> searchProducts(String query) {
    if (query.isEmpty) return _products.where((p) => p.isActive).toList();
    
    return _products.where((product) => 
      product.isActive && (
        product.name.toLowerCase().contains(query.toLowerCase()) ||
        product.brand.toLowerCase().contains(query.toLowerCase()) ||
        product.category.toLowerCase().contains(query.toLowerCase())
      )
    ).toList();
  }

  List<String> getBrands() {
    Set<String> brands = _products
        .where((p) => p.isActive)
        .map((p) => p.brand)
        .toSet();
    return brands.toList()..sort();
  }

  List<String> getProductNames() {
    Set<String> names = _products
        .where((p) => p.isActive)
        .map((p) => p.name)
        .toSet();
    return names.toList()..sort();
  }
}
