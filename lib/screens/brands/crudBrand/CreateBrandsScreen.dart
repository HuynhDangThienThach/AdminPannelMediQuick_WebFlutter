import 'package:admin/controllers/brandController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants.dart';
import '../../dashboard/components/header.dart';
import 'LCreateBrandsScreen.dart';
class CreateBrandsScreen extends StatefulWidget {
  const CreateBrandsScreen({super.key});

  @override
  State<CreateBrandsScreen> createState() => _CreateBrandsScreenState();
}

class _CreateBrandsScreenState extends State<CreateBrandsScreen> {
  final controller = Get.put(BrandController());
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          primary: false,
          padding: EdgeInsets.all(defaultPadding),
          child: Column(
            children: [
              Header(title: "Tạo thương hiệu", isButton: true),
              LCreateBrandsScreen(),
           ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: controller.createBrand,
          tooltip: 'Đăng thương hiệu',
          child: Icon(Icons.check),
          backgroundColor: Colors.blueAccent,
          elevation: 6,
          mini: false,
        ),
      ),
    );
  }
}
