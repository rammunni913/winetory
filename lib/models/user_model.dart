
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String mobile;
  final String role;
  final String name;
  final String? email;
  final String? shopId;
  final String? shopName;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic>? permissions;

  UserModel({
    required this.id,
    required this.mobile,
    required this.role,
    required this.name,
    this.email,
    this.shopId,
    this.shopName,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
    this.permissions,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      mobile: data['mobile'] ?? '',
      role: data['role'] ?? '',
      name: data['name'] ?? '',
      email: data['email'],
      shopId: data['shopId'],
      shopName: data['shopName'],
      isActive: data['isActive'] ?? true,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      permissions: data['permissions'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'mobile': mobile,
      'role': role,
      'name': name,
      'email': email,
      'shopId': shopId,
      'shopName': shopName,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'permissions': permissions,
    };
  }

  UserModel copyWith({
    String? id,
    String? mobile,
    String? role,
    String? name,
    String? email,
    String? shopId,
    String? shopName,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? permissions,
  }) {
    return UserModel(
      id: id ?? this.id,
      mobile: mobile ?? this.mobile,
      role: role ?? this.role,
      name: name ?? this.name,
      email: email ?? this.email,
      shopId: shopId ?? this.shopId,
      shopName: shopName ?? this.shopName,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      permissions: permissions ?? this.permissions,
    );
  }
}
