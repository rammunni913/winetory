import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/sales_model.dart';
import '../utils/constants.dart';

class SalesProvider with ChangeNotifier {
  List<SalesModel> _sales = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<SalesModel> get sales => _sales;
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

  Future<void> fetchSales({String? shopId, String? salesmanId, DateTime? startDate, DateTime? endDate}) async {
    try {
      setLoading(true);
      setError(null);

      Query query = FirebaseFirestore.instance
          .collection(AppConstants.salesCollection)
          .orderBy('saleDate', descending: true);

      if (shopId != null) {
        query = query.where('shopId', isEqualTo: shopId);
      }

      if (salesmanId != null) {
        query = query.where('salesmanId', isEqualTo: salesmanId);
      }

      if (startDate != null && endDate != null) {
        query = query
            .where('saleDate', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
            .where('saleDate', isLessThanOrEqualTo: Timestamp.fromDate(endDate));
      }

      QuerySnapshot querySnapshot = await query.get();

      _sales = querySnapshot.docs
          .map((doc) => SalesModel.fromFirestore(doc))
          .toList();

      setLoading(false);
    } catch (e) {
      setError('Failed to fetch sales: ${e.toString()}');
      setLoading(false);
    }
  }

  Future<bool> createSale(SalesModel sale) async {
    try {
      setLoading(true);
      setError(null);

      await FirebaseFirestore.instance
          .collection(AppConstants.salesCollection)
          .doc(sale.id)
          .set(sale.toFirestore());

      _sales.insert(0, sale);
      setLoading(false);
      return true;
    } catch (e) {
      setError('Failed to create sale: ${e.toString()}');
      setLoading(false);
      return false;
    }
  }

  Future<bool> updateSale(SalesModel sale) async {
    try {
      setLoading(true);
      setError(null);

      await FirebaseFirestore.instance
          .collection(AppConstants.salesCollection)
          .doc(sale.id)
          .update(sale.toFirestore());

      int index = _sales.indexWhere((s) => s.id == sale.id);
      if (index != -1) {
        _sales[index] = sale;
      }

      setLoading(false);
      return true;
    } catch (e) {
      setError('Failed to update sale: ${e.toString()}');
      setLoading(false);
      return false;
    }
  }

  Future<String> generateInvoiceNumber(String shopId) async {
    try {
      String dateStr = DateTime.now().toString().substring(0, 10).replaceAll('-', '');
      String shopCode = shopId.substring(0, 6); // Assuming shopId format
      
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(AppConstants.salesCollection)
          .where('shopId', isEqualTo: shopId)
          .where('saleDate', isGreaterThanOrEqualTo: Timestamp.fromDate(DateTime.now().subtract(const Duration(days: 1))))
          .get();

      int count = querySnapshot.docs.length + 1;
      return '${AppConstants.invoicePrefix}-$shopCode-$dateStr-${count.toString().padLeft(4, '0')}';
    } catch (e) {
      return '${AppConstants.invoicePrefix}-${DateTime.now().millisecondsSinceEpoch}';
    }
  }

  SalesModel? getSaleById(String saleId) {
    try {
      return _sales.firstWhere((s) => s.id == saleId);
    } catch (e) {
      return null;
    }
  }

  List<SalesModel> getSalesByShop(String shopId) {
    return _sales.where((s) => s.shopId == shopId).toList();
  }

  List<SalesModel> getSalesBySalesman(String salesmanId) {
    return _sales.where((s) => s.salesmanId == salesmanId).toList();
  }

  List<SalesModel> getSalesByDateRange(DateTime startDate, DateTime endDate) {
    return _sales.where((s) => 
      s.saleDate.isAfter(startDate.subtract(const Duration(days: 1))) &&
      s.saleDate.isBefore(endDate.add(const Duration(days: 1)))
    ).toList();
  }

  Map<String, dynamic> getSalesSummary({String? shopId, String? salesmanId, DateTime? startDate, DateTime? endDate}) {
    List<SalesModel> filteredSales = _sales;

    if (shopId != null) {
      filteredSales = filteredSales.where((s) => s.shopId == shopId).toList();
    }

    if (salesmanId != null) {
      filteredSales = filteredSales.where((s) => s.salesmanId == salesmanId).toList();
    }

    if (startDate != null && endDate != null) {
      filteredSales = filteredSales.where((s) => 
        s.saleDate.isAfter(startDate.subtract(const Duration(days: 1))) &&
        s.saleDate.isBefore(endDate.add(const Duration(days: 1)))
      ).toList();
    }

    double totalSales = 0;
    double totalCommission = 0;
    int totalQuantity = 0;

    for (SalesModel sale in filteredSales) {
      totalSales += sale.totalAmount;
      totalCommission += sale.commission;
      totalQuantity += sale.quantity;
    }

    return {
      'totalSales': totalSales,
      'totalCommission': totalCommission,
      'totalQuantity': totalQuantity,
      'averageSale': filteredSales.isNotEmpty ? totalSales / filteredSales.length : 0,
      'salesCount': filteredSales.length,
    };
  }

  List<Map<String, dynamic>> getTopProducts({int limit = 10}) {
    Map<String, Map<String, dynamic>> productStats = {};

    for (SalesModel sale in _sales) {
      if (productStats.containsKey(sale.productId)) {
        productStats[sale.productId]!['quantity'] += sale.quantity;
        productStats[sale.productId]!['totalAmount'] += sale.totalAmount;
        productStats[sale.productId]!['salesCount'] += 1;
      } else {
        productStats[sale.productId] = {
          'productId': sale.productId,
          'productName': sale.productName,
          'quantity': sale.quantity,
          'totalAmount': sale.totalAmount,
          'salesCount': 1,
        };
      }
    }

    List<Map<String, dynamic>> sortedProducts = productStats.values.toList()
      ..sort((a, b) => b['totalAmount'].compareTo(a['totalAmount']));

    return sortedProducts.take(limit).toList();
  }
}
