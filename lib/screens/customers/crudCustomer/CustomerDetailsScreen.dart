import 'package:admin/screens/customers/crudCustomer/LCustomerDetailsScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants.dart';
import '../../../controllers/customer_controller.dart';
import '../../dashboard/components/header.dart';

class CustomerDetailsScreen extends StatefulWidget {
  const CustomerDetailsScreen({super.key});
  @override
  State<CustomerDetailsScreen> createState() => _CustomerDetailsScreenState();
}

class _CustomerDetailsScreenState extends State<CustomerDetailsScreen> {
  final controller = Get.put(CustomerController());
  late final String? customerId;

  @override
  void initState() {
    super.initState();
    customerId = Get.arguments;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          primary: false,
          padding: EdgeInsets.all(defaultPadding),
          child: Column(
            children: [
              Header(title: "Chi tiết khách hàng", isButton: true),
              if (customerId != null && customerId!.isNotEmpty)
                LCustomerDetailsScreen(customerId: customerId!)
              else
                Center(child: Text('Không tìm thấy thông tin khách hàng')),
            ],
          ),
        ),
      ),
    );
  }
}
