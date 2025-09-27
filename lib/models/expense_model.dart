import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseModel {
  final String id;
  final String type; // 'Dukaan Kharcha Khata' or 'Commission Kharcha Khata'
  final String description;
  final double amount;
  final String shopId;
  final String? salesmanId;
  final String? productId;
  final String? saleId;
  final DateTime expenseDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  ExpenseModel({
    required this.id,
    required this.type,
    required this.description,
    required this.amount,
    required this.shopId,
    this.salesmanId,
    this.productId,
    this.saleId,
    required this.expenseDate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ExpenseModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ExpenseModel(
      id: doc.id,
      type: data['type'] ?? '',
      description: data['description'] ?? '',
      amount: (data['amount'] ?? 0).toDouble(),
      shopId: data['shopId'] ?? '',
      salesmanId: data['salesmanId'],
      productId: data['productId'],
      saleId: data['saleId'],
      expenseDate: (data['expenseDate'] as Timestamp).toDate(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'type': type,
      'description': description,
      'amount': amount,
      'shopId': shopId,
      'salesmanId': salesmanId,
      'productId': productId,
      'saleId': saleId,
      'expenseDate': Timestamp.fromDate(expenseDate),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  ExpenseModel copyWith({
    String? id,
    String? type,
    String? description,
    double? amount,
    String? shopId,
    String? salesmanId,
    String? productId,
    String? saleId,
    DateTime? expenseDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ExpenseModel(
      id: id ?? this.id,
      type: type ?? this.type,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      shopId: shopId ?? this.shopId,
      salesmanId: salesmanId ?? this.salesmanId,
      productId: productId ?? this.productId,
      saleId: saleId ?? this.saleId,
      expenseDate: expenseDate ?? this.expenseDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
