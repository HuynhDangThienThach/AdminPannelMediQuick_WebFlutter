import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../utils/validators/enums.dart';
import '../utils/validators/helper_functions.dart';
import 'AddressModel.dart';
import 'cart_item_model.dart';

class OrderModel{
  final String id;
  final String userId;
  OrderStatus status;
  final double totalAmount;
  final DateTime orderDate;
  final String paymentMethod;
  final AddressModel? address;
  final DateTime? deliveryDate;
  final List<CartItemModel> items;

  OrderModel({
    required this.id,
    this.userId = '',
    required this.status,
    required this.items,
    required this.totalAmount,
    required this.orderDate,
    this.paymentMethod = 'Paypal',
    this.address,
    this.deliveryDate,
  });

  String get formattedOrderDate => THelperFunctions.getFormattedDate(orderDate);
  String get formattedDeliveryDate => deliveryDate != null ? THelperFunctions.getFormattedDate(orderDate) :  '';
  String get orderStatusText {
    switch (status) {
      case OrderStatus.pending:
        return 'Đang chờ xử lý';
      case OrderStatus.processing:
        return 'Đang xử lý';
      case OrderStatus.prepare:
        return 'Đang chuẩn bị';
      case OrderStatus.shipped:
        return 'Đang giao hàng';
      case OrderStatus.delivered:
        return 'Đã giao hàng';
      case OrderStatus.cancel:
        return 'Đã hủy';
      default:
        return 'Không xác định';
    }
  }

  Color get orderStatusColor {
    switch (status) {
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.processing:
        return Colors.blue;
      case OrderStatus.prepare:
        return Colors.amber;
      case OrderStatus.shipped:
        return Colors.lightBlue;
      case OrderStatus.delivered:
        return Colors.green;
      case OrderStatus.cancel:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'status': status.toString(),
      'totalAmount': totalAmount,
      'orderDate': orderDate,
      'paymentMethod': paymentMethod,
      'address': address?.toJson(),
      'deliveryDate': deliveryDate,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'Id đơn hàng': id,
      'Trạng thái': orderStatusText,
      'Tổng tiền': totalAmount,
      'Ngày': deliveryDate,
      'Sản phẩm': items.length,
      'userId': userId,
      'orderDate': orderDate,
      'paymentMethod': paymentMethod,
      'address': address?.toJson(),
    };
  }

  factory OrderModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return OrderModel(
      id: data['id'] as String,
      userId: data['userId'] as String,
      status: OrderStatus.values.firstWhere((e) => e.toString() == data['status']),
      totalAmount: data['totalAmount'] as double,
      orderDate: (data['orderDate'] as Timestamp).toDate(),
      paymentMethod: data['paymentMethod'] as String,
      address: AddressModel.fromMap(data['address'] as Map<String, dynamic>),
      deliveryDate: data['deliveryDate'] == null ? null : (data['deliveryDate'] as Timestamp).toDate(),
      items: (data['items'] as List<dynamic>)
          .map((itemData) =>
          CartItemModel.fromJson(itemData as Map<String, dynamic>))
          .toList(),
    );
  }
}
