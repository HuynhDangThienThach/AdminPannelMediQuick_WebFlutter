import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants.dart';
import '../../../controllers/product_controller.dart';
import '../../dashboard/components/header.dart';
import 'LEditProductScreen.dart';
class EditProductsScreen extends StatefulWidget {
  @override
  _EditProductsScreenState createState() => _EditProductsScreenState();
}

class _EditProductsScreenState extends State<EditProductsScreen> {
  final controller = Get.put(ProductController());
  late final String? productId;

  @override
  void initState() {
    super.initState();
    productId = Get.arguments;
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
              Header(title: "Chỉnh sửa sản phẩm", isButton: true),
              if (productId != null && productId!.isNotEmpty)
                LEditProductScreen(productId: productId!,)
              else
                Center(child: Text('Không tìm thấy thông tin sản phẩm')),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            controller.updateProduct(productId!);
          },
          tooltip: 'Hoàn tất',
          child: Icon(Icons.check),
          backgroundColor: Colors.blueAccent,
          elevation: 6,
          mini: false,
        ),
      ),
    );
  }
}
