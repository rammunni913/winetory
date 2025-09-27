import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/stock_model.dart';
import '../utils/constants.dart';

class StockProvider with ChangeNotifier {
  List<StockModel> _stock = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<StockModel> get stock => _stock;
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

  Future<void> fetchStock({String? shopId, String? category, DateTime? date}) async {
    try {
      setLoading(true);
      setError(null);

      Query query = FirebaseFirestore.instance
          .collection(AppConstants.stockCollection)
          .orderBy('date', descending: true);

      if (shopId != null) {
        query = query.where('shopId', isEqualTo: shopId);
      }

      if (category != null) {
        query = query.where('category', isEqualTo: category);
      }

      if (date != null) {
        DateTime startOfDay = DateTime(date.year, date.month, date.day);
        DateTime endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);
        query = query
            .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
            .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay));
      }

      QuerySnapshot querySnapshot = await query.get();

      _stock = querySnapshot.docs
          .map((doc) => StockModel.fromFirestore(doc))
          .toList();

      setLoading(false);
    } catch (e) {
      setError('Failed to fetch stock: ${e.toString()}');
      setLoading(false);
    }
  }

  Future<bool> updateStock(StockModel stock) async {
    try {
      setLoading(true);
      setError(null);

      await FirebaseFirestore.instance
          .collection(AppConstants.stockCollection)
          .doc(stock.id)
          .set(stock.toFirestore(), SetOptions(merge: true));

      int index = _stock.indexWhere((s) => s.id == stock.id);
      if (index != -1) {
        _stock[index] = stock;
      } else {
        _stock.insert(0, stock);
      }

      setLoading(false);
      return true;
    } catch (e) {
      setError('Failed to update stock: ${e.toString()}');
      setLoading(false);
      return false;
    }
  }

  Future<bool> addPurchase(String productId, String productName, String shopId, 
      String category, int quantity, double unitPrice) async {
    try {
      setLoading(true);
      setError(null);

      // Get current stock
      StockModel? currentStock = getStockByProductAndShop(productId, shopId);
      
      int newPurchase = (currentStock?.purchase ?? 0) + quantity;
      int newClosingStock = (currentStock?.closingStock ?? 0) + quantity;

      StockModel updatedStock = StockModel(
        id: currentStock?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        productId: productId,
        productName: productName,
        shopId: shopId,
        category: category,
        openingStock: currentStock?.openingStock ?? 0,
        purchase: newPurchase,
        sent: currentStock?.sent ?? 0,
        sale: currentStock?.sale ?? 0,
        closingStock: newClosingStock,
        unitPrice: unitPrice,
        totalValue: newClosingStock * unitPrice,
        date: DateTime.now(),
        createdAt: currentStock?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await updateStock(updatedStock);
      setLoading(false);
      return true;
    } catch (e) {
      setError('Failed to add purchase: ${e.toString()}');
      setLoading(false);
      return false;
    }
  }

  Future<bool> addSale(String productId, String productName, String shopId, 
      String category, int quantity, double unitPrice) async {
    try {
      setLoading(true);
      setError(null);

      // Get current stock
      StockModel? currentStock = getStockByProductAndShop(productId, shopId);
      
      if (currentStock == null || currentStock.closingStock < quantity) {
        setError('Insufficient stock');
        setLoading(false);
        return false;
      }

      int newSale = (currentStock.sale) + quantity;
      int newClosingStock = currentStock.closingStock - quantity;

      StockModel updatedStock = currentStock.copyWith(
        sale: newSale,
        closingStock: newClosingStock,
        totalValue: newClosingStock * unitPrice,
        updatedAt: DateTime.now(),
      );

      await updateStock(updatedStock);
      setLoading(false);
      return true;
    } catch (e) {
      setError('Failed to add sale: ${e.toString()}');
      setLoading(false);
      return false;
    }
  }

  Future<bool> addTransfer(String productId, String productName, String fromShopId, 
      String toShopId, String category, int quantity, double unitPrice) async {
    try {
      setLoading(true);
      setError(null);

      // Reduce from source shop
      StockModel? fromStock = getStockByProductAndShop(productId, fromShopId);
      if (fromStock == null || fromStock.closingStock < quantity) {
        setError('Insufficient stock for transfer');
        setLoading(false);
        return false;
      }

      int newSent = (fromStock.sent) + quantity;
      int newClosingStock = fromStock.closingStock - quantity;

      StockModel updatedFromStock = fromStock.copyWith(
        sent: newSent,
        closingStock: newClosingStock,
        totalValue: newClosingStock * unitPrice,
        updatedAt: DateTime.now(),
      );

      await updateStock(updatedFromStock);

      // Add to destination shop
      await addPurchase(productId, productName, toShopId, category, quantity, unitPrice);

      setLoading(false);
      return true;
    } catch (e) {
      setError('Failed to add transfer: ${e.toString()}');
      setLoading(false);
      return false;
    }
  }

  StockModel? getStockByProductAndShop(String productId, String shopId) {
    try {
      return _stock.firstWhere((s) => s.productId == productId && s.shopId == shopId);
    } catch (e) {
      return null;
    }
  }

  List<StockModel> getStockByCategory(String category) {
    return _stock.where((s) => s.category == category).toList();
  }

  List<StockModel> getStockByShop(String shopId) {
    return _stock.where((s) => s.shopId == shopId).toList();
  }

  Map<String, dynamic> getStockSummary(String shopId) {
    List<StockModel> shopStock = getStockByShop(shopId);
    
    double totalValue = 0;
    int totalItems = 0;
    
    for (StockModel stock in shopStock) {
      totalValue += stock.totalValue;
      totalItems += stock.closingStock;
    }

    return {
      'totalValue': totalValue,
      'totalItems': totalItems,
      'categories': shopStock.map((s) => s.category).toSet().toList(),
    };
  }
}
