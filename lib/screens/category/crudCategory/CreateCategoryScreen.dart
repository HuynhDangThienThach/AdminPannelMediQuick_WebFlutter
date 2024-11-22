import 'package:admin/controllers/categoryController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../constants.dart';
import '../../dashboard/components/header.dart';
import 'LCreateCategoryScreen.dart';
class CreateCategoryScreen extends StatefulWidget {
  const CreateCategoryScreen({super.key});

  @override
  State<CreateCategoryScreen> createState() => _CreateCategoryScreenState();
}

class _CreateCategoryScreenState extends State<CreateCategoryScreen> {
  final controller = Get.put(CategoryController());
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          primary: false,
          padding: EdgeInsets.all(defaultPadding),
          child: Column(
            children: [
              Header(title: "Tạo danh mục", isButton: true),
              LCreateCategoryScreen(),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: controller.createCategory,
          tooltip: 'Đăng danh mục',
          child: Icon(Icons.check),
          backgroundColor: Colors.blueAccent,
          elevation: 6,
          mini: false,
        ),
      ),
    );
  }
}
