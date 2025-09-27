import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/expense_model.dart';
import '../utils/constants.dart';

class ExpenseProvider with ChangeNotifier {
  List<ExpenseModel> _expenses = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<ExpenseModel> get expenses => _expenses;
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

  Future<void> fetchExpenses({String? shopId, String? salesmanId, String? type, DateTime? startDate, DateTime? endDate}) async {
    try {
      setLoading(true);
      setError(null);

      Query query = FirebaseFirestore.instance
          .collection(AppConstants.expensesCollection)
          .orderBy('expenseDate', descending: true);

      if (shopId != null) {
        query = query.where('shopId', isEqualTo: shopId);
      }

      if (salesmanId != null) {
        query = query.where('salesmanId', isEqualTo: salesmanId);
      }

      if (type != null) {
        query = query.where('type', isEqualTo: type);
      }

      if (startDate != null && endDate != null) {
        query = query
            .where('expenseDate', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
            .where('expenseDate', isLessThanOrEqualTo: Timestamp.fromDate(endDate));
      }

      QuerySnapshot querySnapshot = await query.get();

      _expenses = querySnapshot.docs
          .map((doc) => ExpenseModel.fromFirestore(doc))
          .toList();

      setLoading(false);
    } catch (e) {
      setError('Failed to fetch expenses: ${e.toString()}');
      setLoading(false);
    }
  }

  Future<bool> createExpense(ExpenseModel expense) async {
    try {
      setLoading(true);
      setError(null);

      await FirebaseFirestore.instance
          .collection(AppConstants.expensesCollection)
          .doc(expense.id)
          .set(expense.toFirestore());

      _expenses.insert(0, expense);
      setLoading(false);
      return true;
    } catch (e) {
      setError('Failed to create expense: ${e.toString()}');
      setLoading(false);
      return false;
    }
  }

  Future<bool> updateExpense(ExpenseModel expense) async {
    try {
      setLoading(true);
      setError(null);

      await FirebaseFirestore.instance
          .collection(AppConstants.expensesCollection)
          .doc(expense.id)
          .update(expense.toFirestore());

      int index = _expenses.indexWhere((e) => e.id == expense.id);
      if (index != -1) {
        _expenses[index] = expense;
      }

      setLoading(false);
      return true;
    } catch (e) {
      setError('Failed to update expense: ${e.toString()}');
      setLoading(false);
      return false;
    }
  }

  Future<bool> deleteExpense(String expenseId) async {
    try {
      setLoading(true);
      setError(null);

      await FirebaseFirestore.instance
          .collection(AppConstants.expensesCollection)
          .doc(expenseId)
          .delete();

      _expenses.removeWhere((e) => e.id == expenseId);
      setLoading(false);
      return true;
    } catch (e) {
      setError('Failed to delete expense: ${e.toString()}');
      setLoading(false);
      return false;
    }
  }

  ExpenseModel? getExpenseById(String expenseId) {
    try {
      return _expenses.firstWhere((e) => e.id == expenseId);
    } catch (e) {
      return null;
    }
  }

  List<ExpenseModel> getExpensesByShop(String shopId) {
    return _expenses.where((e) => e.shopId == shopId).toList();
  }

  List<ExpenseModel> getExpensesBySalesman(String salesmanId) {
    return _expenses.where((e) => e.salesmanId == salesmanId).toList();
  }

  List<ExpenseModel> getExpensesByType(String type) {
    return _expenses.where((e) => e.type == type).toList();
  }

  List<ExpenseModel> getExpensesByDateRange(DateTime startDate, DateTime endDate) {
    return _expenses.where((e) => 
      e.expenseDate.isAfter(startDate.subtract(const Duration(days: 1))) &&
      e.expenseDate.isBefore(endDate.add(const Duration(days: 1)))
    ).toList();
  }

  Map<String, dynamic> getExpenseSummary({String? shopId, String? salesmanId, String? type, DateTime? startDate, DateTime? endDate}) {
    List<ExpenseModel> filteredExpenses = _expenses;

    if (shopId != null) {
      filteredExpenses = filteredExpenses.where((e) => e.shopId == shopId).toList();
    }

    if (salesmanId != null) {
      filteredExpenses = filteredExpenses.where((e) => e.salesmanId == salesmanId).toList();
    }

    if (type != null) {
      filteredExpenses = filteredExpenses.where((e) => e.type == type).toList();
    }

    if (startDate != null && endDate != null) {
      filteredExpenses = filteredExpenses.where((e) => 
        e.expenseDate.isAfter(startDate.subtract(const Duration(days: 1))) &&
        e.expenseDate.isBefore(endDate.add(const Duration(days: 1)))
      ).toList();
    }

    double totalAmount = 0;
    Map<String, double> typeBreakdown = {};
    Map<String, double> descriptionBreakdown = {};

    for (ExpenseModel expense in filteredExpenses) {
      totalAmount += expense.amount;
      
      // Type breakdown
      if (typeBreakdown.containsKey(expense.type)) {
        typeBreakdown[expense.type] = typeBreakdown[expense.type]! + expense.amount;
      } else {
        typeBreakdown[expense.type] = expense.amount;
      }

      // Description breakdown
      if (descriptionBreakdown.containsKey(expense.description)) {
        descriptionBreakdown[expense.description] = descriptionBreakdown[expense.description]! + expense.amount;
      } else {
        descriptionBreakdown[expense.description] = expense.amount;
      }
    }

    return {
      'totalAmount': totalAmount,
      'expenseCount': filteredExpenses.length,
      'averageExpense': filteredExpenses.isNotEmpty ? totalAmount / filteredExpenses.length : 0,
      'typeBreakdown': typeBreakdown,
      'descriptionBreakdown': descriptionBreakdown,
    };
  }

  List<String> getExpenseDescriptions() {
    Set<String> descriptions = _expenses
        .where((e) => e.type == AppConstants.dukaanExpense)
        .map((e) => e.description)
        .toSet();
    return descriptions.toList()..sort();
  }

  List<Map<String, dynamic>> getDailyExpenseCards(DateTime startDate, DateTime endDate) {
    Map<String, List<ExpenseModel>> dailyExpenses = {};
    
    for (ExpenseModel expense in _expenses) {
      if (expense.expenseDate.isAfter(startDate.subtract(const Duration(days: 1))) &&
          expense.expenseDate.isBefore(endDate.add(const Duration(days: 1)))) {
        String dateKey = expense.expenseDate.toString().substring(0, 10);
        if (!dailyExpenses.containsKey(dateKey)) {
          dailyExpenses[dateKey] = [];
        }
        dailyExpenses[dateKey]!.add(expense);
      }
    }

    List<Map<String, dynamic>> dailyCards = [];
    
    for (String date in dailyExpenses.keys) {
      List<ExpenseModel> dayExpenses = dailyExpenses[date]!;
      double dayTotal = dayExpenses.fold(0, (sum, expense) => sum + expense.amount);
      
      Map<String, double> dayBreakdown = {};
      for (ExpenseModel expense in dayExpenses) {
        if (dayBreakdown.containsKey(expense.description)) {
          dayBreakdown[expense.description] = dayBreakdown[expense.description]! + expense.amount;
        } else {
          dayBreakdown[expense.description] = expense.amount;
        }
      }

      dailyCards.add({
        'date': date,
        'total': dayTotal,
        'expenseCount': dayExpenses.length,
        'breakdown': dayBreakdown,
        'expenses': dayExpenses,
      });
    }

    dailyCards.sort((a, b) => b['date'].compareTo(a['date']));
    return dailyCards;
  }
}
