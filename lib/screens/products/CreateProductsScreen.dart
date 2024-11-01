import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants.dart';
import '../../controllers/product_controller.dart';
import '../dashboard/components/header.dart';
import 'LCreateProductScreen.dart';

class CreateProductsScreen extends StatefulWidget {
  @override
  _CreateProductsScreenState createState() => _CreateProductsScreenState();
}

class _CreateProductsScreenState extends State<CreateProductsScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductController());
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          primary: false,
          padding: EdgeInsets.all(defaultPadding),
          child: Column(
            children: [
              Header(title: "Tạo sản phẩm", isButton: true),
              LCreateProductScreen(),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: controller.createProduct,
          tooltip: 'Đăng sản phẩm',
          child: Icon(Icons.check),
          backgroundColor: Colors.blueAccent,
          elevation: 6,
          mini: false,
        ),
      ),
    );
  }
}
