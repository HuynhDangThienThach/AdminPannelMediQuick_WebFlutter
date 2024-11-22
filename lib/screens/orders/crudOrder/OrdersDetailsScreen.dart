import 'package:admin/models/order_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../dashboard/components/header.dart';
import 'LOrdersDetailsScreen.dart';

class OrdersDetailsScreen extends StatefulWidget {
  const OrdersDetailsScreen({super.key});

  @override
  State<OrdersDetailsScreen> createState() => _OrdersDetailsScreenState();
}

class _OrdersDetailsScreenState extends State<OrdersDetailsScreen> {
  late final OrderModel? order;

  @override
  void initState() {
    super.initState();
    order = Get.arguments as OrderModel;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Header(
                  title: (order != null && order!.id.isNotEmpty)
                      ? order!.id.toString()
                      : 'Chi tiết đơn hàng',
                  isButton: true,
                ),
                const SizedBox(height: 16),
                if (order != null && order!.id.isNotEmpty)
                  LOrdersDetailsScreen(order: order)
                else
                  const Center(
                    child: Text(
                      'Không tìm thấy thông tin đơn hàng',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
