import 'package:admin/models/order.dart';
import 'package:admin/responsive.dart';
import 'package:admin/screens/dashboard/components/my_fields.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants.dart';
import '../../controllers/customer_controller.dart';
import '../orders/crudOrder/order_recent_files.dart';
import 'components/header.dart';
import 'components/storage_details.dart';

class DashboardScreen extends StatelessWidget {
  final controller = Get.put(CustomerController());
  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header(title: "Thống kê",),
            SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      MyFiles(),
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
                      if (Responsive.isMobile(context))
                        SizedBox(height: defaultPadding),
                      if (Responsive.isMobile(context)) StorageDetails(),
                    ],
                  ),
                ),
                if (!Responsive.isMobile(context))
                  SizedBox(width: defaultPadding),
                if (!Responsive.isMobile(context))
                  Expanded(
                    flex: 2,
                    child: StorageDetails(),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
