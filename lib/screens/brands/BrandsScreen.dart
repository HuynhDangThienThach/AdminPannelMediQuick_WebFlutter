import 'package:admin/controllers/brandController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants.dart';
import '../../routes/routes.dart';
import '../dashboard/components/header.dart';
import 'crudBrand/brand_recent_files.dart';
class BrandsScreen extends StatelessWidget {
  const BrandsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BrandController());
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header(title: "Quản lý thương hiệu"),
            SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      SizedBox(height: defaultPadding),
                      Obx(
                        () => BrandRecentFiles(
                          textButton: "Tạo thương hiệu",
                          title: "Danh sách thương hiệu",
                          routes: Routes.createBrands,
                          onPressed: (routes){Get.toNamed(routes);},
                          data: controller.brands.map((brand) => brand.toJson()).toList(),
                          columns: ['Ảnh', 'Tên thương hiệu'],
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
