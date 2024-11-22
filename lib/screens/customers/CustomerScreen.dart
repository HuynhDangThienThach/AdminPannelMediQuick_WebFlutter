import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants.dart';
import '../../controllers/customer_controller.dart';
import '../dashboard/components/header.dart';
import 'crudCustomer/customer_recent_files.dart';
class CustomerScreen extends StatelessWidget {
  const CustomerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CustomerController());
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header(title: "Quản lý khách hàng"),
            SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      SizedBox(height: defaultPadding),
                      Obx(
                          () => CustomerRecentFiles(
                            title: "Danh sách khách hàng",
                            data: controller.customers.map((cus) => cus.toMap()).toList(),
                            columns: ['Ảnh', 'Tên người dùng', 'Email', 'Số điện thoại'],
                        ),
                      ),
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
