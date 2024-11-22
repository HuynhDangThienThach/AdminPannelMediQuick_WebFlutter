import 'package:admin/controllers/categoryController.dart';
import 'package:admin/screens/category/crudCategory/LEditCategoryScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants.dart';
import '../../dashboard/components/header.dart';
class EditCategoryScreen extends StatefulWidget {
  const EditCategoryScreen({super.key});

  @override
  State<EditCategoryScreen> createState() => _EditCategoryScreenState();
}
class _EditCategoryScreenState extends State<EditCategoryScreen> {
  final controller = Get.put(CategoryController());
  late final String? categoryId;

  @override
  void initState() {
    super.initState();
    categoryId = Get.arguments;
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
              Header(title: "Chỉnh sửa danh mục", isButton: true),
              if (categoryId!= null && categoryId!.isNotEmpty)
                LEditCategoryScreen(categoryId: categoryId!)
              else
                Center(child: Text('Không tìm thấy thông tin danh mục')),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            controller.updateCategory(categoryId!);
          },
          tooltip: 'Cập nhật danh mục',
          child: Icon(Icons.check),
          backgroundColor: Colors.blueAccent,
          elevation: 6,
          mini: false,
        ),
      ),
    );
  }
}
