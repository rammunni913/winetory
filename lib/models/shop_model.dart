import 'package:cloud_firestore/cloud_firestore.dart';

class ShopModel {
  final String id;
  final String shopCode;
  final String name;
  final String address;
  final String contact;
  final String? email;
  final String? ownerName;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic>? location;
  final List<String>? assignedSalesmen;

  ShopModel({
    required this.id,
    required this.shopCode,
    required this.name,
    required this.address,
    required this.contact,
    this.email,
    this.ownerName,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
    this.location,
    this.assignedSalesmen,
  });

  factory ShopModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ShopModel(
      id: doc.id,
      shopCode: data['shopCode'] ?? '',
      name: data['name'] ?? '',
      address: data['address'] ?? '',
      contact: data['contact'] ?? '',
      email: data['email'],
      ownerName: data['ownerName'],
      isActive: data['isActive'] ?? true,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      location: data['location'],
      assignedSalesmen: List<String>.from(data['assignedSalesmen'] ?? []),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'shopCode': shopCode,
      'name': name,
      'address': address,
      'contact': contact,
      'email': email,
      'ownerName': ownerName,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'location': location,
      'assignedSalesmen': assignedSalesmen,
    };
  }

  ShopModel copyWith({
    String? id,
    String? shopCode,
    String? name,
    String? address,
    String? contact,
    String? email,
    String? ownerName,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? location,
    List<String>? assignedSalesmen,
  }) {
    return ShopModel(
      id: id ?? this.id,
      shopCode: shopCode ?? this.shopCode,
      name: name ?? this.name,
      address: address ?? this.address,
      contact: contact ?? this.contact,
      email: email ?? this.email,
      ownerName: ownerName ?? this.ownerName,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      location: location ?? this.location,
      assignedSalesmen: assignedSalesmen ?? this.assignedSalesmen,
    );
  }
}
