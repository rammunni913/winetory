import 'package:cloud_firestore/cloud_firestore.dart';

class AssignmentModel {
  final String id;
  final String salesmanId;
  final String salesmanName;
  final String shopId;
  final String shopName;
  final String shopContact;
  final DateTime assignmentDate;
  final DateTime? startTime;
  final DateTime? endTime;
  final String status; // 'assigned', 'active', 'completed'
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  AssignmentModel({
    required this.id,
    required this.salesmanId,
    required this.salesmanName,
    required this.shopId,
    required this.shopName,
    required this.shopContact,
    required this.assignmentDate,
    this.startTime,
    this.endTime,
    this.status = 'assigned',
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AssignmentModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return AssignmentModel(
      id: doc.id,
      salesmanId: data['salesmanId'] ?? '',
      salesmanName: data['salesmanName'] ?? '',
      shopId: data['shopId'] ?? '',
      shopName: data['shopName'] ?? '',
      shopContact: data['shopContact'] ?? '',
      assignmentDate: (data['assignmentDate'] as Timestamp).toDate(),
      startTime: data['startTime'] != null 
          ? (data['startTime'] as Timestamp).toDate() 
          : null,
      endTime: data['endTime'] != null 
          ? (data['endTime'] as Timestamp).toDate() 
          : null,
      status: data['status'] ?? 'assigned',
      notes: data['notes'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'salesmanId': salesmanId,
      'salesmanName': salesmanName,
      'shopId': shopId,
      'shopName': shopName,
      'shopContact': shopContact,
      'assignmentDate': Timestamp.fromDate(assignmentDate),
      'startTime': startTime != null ? Timestamp.fromDate(startTime!) : null,
      'endTime': endTime != null ? Timestamp.fromDate(endTime!) : null,
      'status': status,
      'notes': notes,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  AssignmentModel copyWith({
    String? id,
    String? salesmanId,
    String? salesmanName,
    String? shopId,
    String? shopName,
    String? shopContact,
    DateTime? assignmentDate,
    DateTime? startTime,
    DateTime? endTime,
    String? status,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AssignmentModel(
      id: id ?? this.id,
      salesmanId: salesmanId ?? this.salesmanId,
      salesmanName: salesmanName ?? this.salesmanName,
      shopId: shopId ?? this.shopId,
      shopName: shopName ?? this.shopName,
      shopContact: shopContact ?? this.shopContact,
      assignmentDate: assignmentDate ?? this.assignmentDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
