import 'package:cloud_firestore/cloud_firestore.dart';

class SalesModel {
  final String id;
  final String invoiceNumber;
  final String productId;
  final String productName;
  final String shopId;
  final String salesmanId;
  final String customerName;
  final String customerPhone;
  final int quantity;
  final double unitPrice;
  final double totalAmount;
  final double commission;
  final String? notes;
  final DateTime saleDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  SalesModel({
    required this.id,
    required this.invoiceNumber,
    required this.productId,
    required this.productName,
    required this.shopId,
    required this.salesmanId,
    required this.customerName,
    required this.customerPhone,
    required this.quantity,
    required this.unitPrice,
    required this.totalAmount,
    required this.commission,
    this.notes,
    required this.saleDate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SalesModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return SalesModel(
      id: doc.id,
      invoiceNumber: data['invoiceNumber'] ?? '',
      productId: data['productId'] ?? '',
      productName: data['productName'] ?? '',
      shopId: data['shopId'] ?? '',
      salesmanId: data['salesmanId'] ?? '',
      customerName: data['customerName'] ?? '',
      customerPhone: data['customerPhone'] ?? '',
      quantity: data['quantity'] ?? 0,
      unitPrice: (data['unitPrice'] ?? 0).toDouble(),
      totalAmount: (data['totalAmount'] ?? 0).toDouble(),
      commission: (data['commission'] ?? 0).toDouble(),
      notes: data['notes'],
      saleDate: (data['saleDate'] as Timestamp).toDate(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'invoiceNumber': invoiceNumber,
      'productId': productId,
      'productName': productName,
      'shopId': shopId,
      'salesmanId': salesmanId,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'totalAmount': totalAmount,
      'commission': commission,
      'notes': notes,
      'saleDate': Timestamp.fromDate(saleDate),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  SalesModel copyWith({
    String? id,
    String? invoiceNumber,
    String? productId,
    String? productName,
    String? shopId,
    String? salesmanId,
    String? customerName,
    String? customerPhone,
    int? quantity,
    double? unitPrice,
    double? totalAmount,
    double? commission,
    String? notes,
    DateTime? saleDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SalesModel(
      id: id ?? this.id,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      shopId: shopId ?? this.shopId,
      salesmanId: salesmanId ?? this.salesmanId,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      totalAmount: totalAmount ?? this.totalAmount,
      commission: commission ?? this.commission,
      notes: notes ?? this.notes,
      saleDate: saleDate ?? this.saleDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
