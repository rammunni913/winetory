import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String id;
  final String name;
  final String category;
  final String subCategory;
  final String brand;
  final String size;
  final String quantityType;
  final int quantityValue;
  final double unitPrice;
  final double totalPrice;
  final String? description;
  final String? imageUrl;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? shopId;

  ProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.subCategory,
    required this.brand,
    required this.size,
    required this.quantityType,
    required this.quantityValue,
    required this.unitPrice,
    required this.totalPrice,
    this.description,
    this.imageUrl,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
    this.shopId,
  });

  factory ProductModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ProductModel(
      id: doc.id,
      name: data['name'] ?? '',
      category: data['category'] ?? '',
      subCategory: data['subCategory'] ?? '',
      brand: data['brand'] ?? '',
      size: data['size'] ?? '',
      quantityType: data['quantityType'] ?? '',
      quantityValue: data['quantityValue'] ?? 0,
      unitPrice: (data['unitPrice'] ?? 0).toDouble(),
      totalPrice: (data['totalPrice'] ?? 0).toDouble(),
      description: data['description'],
      imageUrl: data['imageUrl'],
      isActive: data['isActive'] ?? true,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      shopId: data['shopId'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'category': category,
      'subCategory': subCategory,
      'brand': brand,
      'size': size,
      'quantityType': quantityType,
      'quantityValue': quantityValue,
      'unitPrice': unitPrice,
      'totalPrice': totalPrice,
      'description': description,
      'imageUrl': imageUrl,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'shopId': shopId,
    };
  }

  ProductModel copyWith({
    String? id,
    String? name,
    String? category,
    String? subCategory,
    String? brand,
    String? size,
    String? quantityType,
    int? quantityValue,
    double? unitPrice,
    double? totalPrice,
    String? description,
    String? imageUrl,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? shopId,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      subCategory: subCategory ?? this.subCategory,
      brand: brand ?? this.brand,
      size: size ?? this.size,
      quantityType: quantityType ?? this.quantityType,
      quantityValue: quantityValue ?? this.quantityValue,
      unitPrice: unitPrice ?? this.unitPrice,
      totalPrice: totalPrice ?? this.totalPrice,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      shopId: shopId ?? this.shopId,
    );
  }
}
