import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants.dart';
import '../../controllers/brandController.dart';
import '../../controllers/categoryController.dart';
import '../../controllers/product_controller.dart';
import '../../models/brand_model.dart';
class RCreateProductScreen extends StatefulWidget {
  const RCreateProductScreen({super.key});

  @override
  State<RCreateProductScreen> createState() => _RCreateProductScreenState();
}

class _RCreateProductScreenState extends State<RCreateProductScreen> {
  final controller = Get.put(ProductController());
  final controllerBrand = Get.put(BrandController());
  final controllerCategory = Get.put(CategoryController());
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Container 1: Hình thu nhỏ (Thumbnail)
          Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: secondaryColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hình thu nhỏ (Thumbnail)',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: controller.hinhdh,
                  decoration: InputDecoration(
                    labelText: 'Nhập đường link của ảnh',
                    labelStyle: TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: secondaryColor,
                    border: OutlineInputBorder(),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.0),

          // Container 2: Ảnh của sản phẩm
          Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: secondaryColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ảnh của sản phẩm',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                SizedBox(height: 16.0),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: TextFormField(
                        controller: controller.imageControllers[index],
                        decoration: InputDecoration(
                          labelText: 'Nhập đường link ảnh ${index + 1}',
                          labelStyle: TextStyle(color: Colors.white),
                          filled: true,
                          fillColor: secondaryColor,
                          border: OutlineInputBorder(),
                        ),
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 16.0),

          // Container 3: Thương hiệu
          Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: secondaryColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Thương hiệu',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                SizedBox(height: 16.0),
                Obx(() {
                  return DropdownButtonFormField<BrandModel>(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: secondaryColor,
                      border: OutlineInputBorder(),
                    ),
                    value: controllerBrand.selectedBrand,
                    hint: Text(
                      'Chọn thương hiệu',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    dropdownColor: secondaryColor,
                    style: TextStyle(color: Colors.white),
                    items: controllerBrand.brands.map((brand) {
                      return DropdownMenuItem(
                        value: brand,
                        child: Text(brand.name),
                      );
                    }).toList(),
                    onChanged: (brand) {
                      controllerBrand.setSelectedBrand(brand!);
                    },
                  );
                }),
              ],
            ),
          ),
          SizedBox(height: 16.0),

          // Container 4: Loại sản phẩm
          Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: secondaryColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Loại sản phẩm',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                SizedBox(height: 16.0),
                Obx(
                      () => DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: secondaryColor,
                      border: OutlineInputBorder(),
                    ),
                    value: controllerCategory.selectedCategory?.id,
                    hint: Text('Chọn loại sản phẩm',
                        style:
                        TextStyle(color: Colors.white, fontSize: 15)),
                    dropdownColor: secondaryColor,
                    style: TextStyle(color: Colors.white),
                    items: controllerCategory.categories.map((category) {
                      return DropdownMenuItem(
                        value: category.id,
                        child: Text(category.name,
                            style: TextStyle(color: Colors.white)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      final selectedCat = controllerCategory.categories
                          .firstWhere((cat) => cat.id == value);
                      controllerCategory.setSelectedCategory(selectedCat);
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.0),

          // Container 5: Tùy chọn hiển thị
          Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: secondaryColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tùy chọn hiển thị',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                Row(
                  children: [
                    Radio<String>(
                      value: 'Hiển thị',
                      groupValue: controller.displayOption,
                      onChanged: (value) {
                        setState(() {
                          controller.displayOption = value!;
                          controller.tuyChonHienThi.value = true;
                        });
                      },
                      activeColor: Colors.blue,
                    ),
                    Text('Hiển thị',
                        style: TextStyle(color: Colors.white)),
                    Radio<String>(
                      value: 'Ẩn',
                      groupValue: controller.displayOption,
                      onChanged: (value) {
                        setState(() {
                          controller.displayOption = value!;
                          controller.tuyChonHienThi.value = false;
                        });
                      },
                      activeColor: Colors.blue,
                    ),
                    Text('Ẩn', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

