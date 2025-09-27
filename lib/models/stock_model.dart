import 'package:cloud_firestore/cloud_firestore.dart';

class StockModel {
  final String id;
  final String productId;
  final String productName;
  final String shopId;
  final String category;
  final int openingStock;
  final int purchase;
  final int sent;
  final int sale;
  final int closingStock;
  final double unitPrice;
  final double totalValue;
  final DateTime date;
  final DateTime createdAt;
  final DateTime updatedAt;

  StockModel({
    required this.id,
    required this.productId,
    required this.productName,
    required this.shopId,
    required this.category,
    required this.openingStock,
    required this.purchase,
    required this.sent,
    required this.sale,
    required this.closingStock,
    required this.unitPrice,
    required this.totalValue,
    required this.date,
    required this.createdAt,
    required this.updatedAt,
  });

  factory StockModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return StockModel(
      id: doc.id,
      productId: data['productId'] ?? '',
      productName: data['productName'] ?? '',
      shopId: data['shopId'] ?? '',
      category: data['category'] ?? '',
      openingStock: data['openingStock'] ?? 0,
      purchase: data['purchase'] ?? 0,
      sent: data['sent'] ?? 0,
      sale: data['sale'] ?? 0,
      closingStock: data['closingStock'] ?? 0,
      unitPrice: (data['unitPrice'] ?? 0).toDouble(),
      totalValue: (data['totalValue'] ?? 0).toDouble(),
      date: (data['date'] as Timestamp).toDate(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'productId': productId,
      'productName': productName,
      'shopId': shopId,
      'category': category,
      'openingStock': openingStock,
      'purchase': purchase,
      'sent': sent,
      'sale': sale,
      'closingStock': closingStock,
      'unitPrice': unitPrice,
      'totalValue': totalValue,
      'date': Timestamp.fromDate(date),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  StockModel copyWith({
    String? id,
    String? productId,
    String? productName,
    String? shopId,
    String? category,
    int? openingStock,
    int? purchase,
    int? sent,
    int? sale,
    int? closingStock,
    double? unitPrice,
    double? totalValue,
    DateTime? date,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return StockModel(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      shopId: shopId ?? this.shopId,
      category: category ?? this.category,
      openingStock: openingStock ?? this.openingStock,
      purchase: purchase ?? this.purchase,
      sent: sent ?? this.sent,
      sale: sale ?? this.sale,
      closingStock: closingStock ?? this.closingStock,
      unitPrice: unitPrice ?? this.unitPrice,
      totalValue: totalValue ?? this.totalValue,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
