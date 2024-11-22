import 'package:admin/controllers/categoryController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants.dart';
import '../../routes/routes.dart';
import '../dashboard/components/header.dart';
import 'crudCategory/categories_recent_files.dart';
class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CategoryController());
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header(title: "Quản lý danh mục"),
            SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      SizedBox(height: defaultPadding),
                      Obx(
                        () => CategoriesRecentFiles(
                          textButton: "Tạo danh mục",
                          title: "Danh sách danh mục",
                          routes: Routes.createCategory,
                          onPressed: (routes){Get.toNamed(routes);},
                          data: controller.categories.map((categories) => categories.toJson()).toList(),
                          columns: ['Ảnh', 'Tên danh mục'],
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
