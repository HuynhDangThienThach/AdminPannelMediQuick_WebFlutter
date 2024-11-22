import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants.dart';
import '../../controllers/customer_controller.dart';
import '../dashboard/components/header.dart';
import 'crudOrder/order_recent_files.dart';
class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CustomerController());
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header(title: "Quản lý đơn hàng"),
            SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      SizedBox(height: defaultPadding),
                      Obx(() {
                        final isLoading = controller.isLoading.value;
                        return OrderRecentFiles(
                          title: "Danh sách đơn hàng",
                          data: controller.orders.map((order) => order.toMap()).toList(),
                          order: controller.orders,
                          columns: ['Id đơn hàng', 'Ngày', 'Sản phẩm', 'Trạng thái', 'Tổng tiền'],
                          isLoading: isLoading,
                        );
                      }),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

