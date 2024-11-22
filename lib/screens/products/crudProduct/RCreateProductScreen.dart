import 'package:admin/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants.dart';
import '../../../controllers/brandController.dart';
import '../../../controllers/categoryController.dart';
import '../../../controllers/product_controller.dart';
import '../../../models/brand_model.dart';

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
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildThumbnailField(),
            SizedBox(height: 16.0),
            _buildImageFields(),
            SizedBox(height: 16.0),
            _buildBrandDropdown(),
            SizedBox(height: 16.0),
            _buildCategoryDropdown(),
            SizedBox(height: 16.0),
            _buildDisplayOptions(),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnailField() {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Hình thu nhỏ (Thumbnail)', style: _textStyleHeader()),
          SizedBox(height: 16.0),
          TextFormField(
            controller: controller.hinhdh,
            decoration: _inputDecoration('Nhập đường link của ảnh'),
            style: TextStyle(color: Colors.white),
            validator: (value) => TValidator.validateLinkImageProduct(value),
          ),
        ],
      ),
    );
  }

  Widget _buildImageFields() {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Ảnh của sản phẩm', style: _textStyleHeader()),
          SizedBox(height: 16.0),
          ListView.builder(
            shrinkWrap: true,
            itemCount: 4,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: TextFormField(
                  controller: controller.imageControllers[index],
                  decoration: _inputDecoration('Nhập đường link ảnh ${index + 1}'),
                  style: TextStyle(color: Colors.white),
                  validator: (value) => TValidator.validateLinkImageProduct(value),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBrandDropdown() {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Thương hiệu', style: _textStyleHeader()),
          SizedBox(height: 16.0),
          Obx(() {
            return DropdownButtonFormField<BrandModel>(
              decoration: _inputDecoration(''),
              value: controllerBrand.selectedBrand,
              hint: Text('Chọn thương hiệu', style: TextStyle(color: Colors.white)),
              dropdownColor: secondaryColor,
              style: TextStyle(color: Colors.white),
              validator: (value) => TValidator.validateBrand(value),
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
    );
  }

  Widget _buildCategoryDropdown() {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Loại sản phẩm', style: _textStyleHeader()),
          SizedBox(height: 16.0),
          Obx(() {
            return DropdownButtonFormField<String>(
              decoration: _inputDecoration(''),
              value: controllerCategory.selectedCategory?.id,
              hint: Text('Chọn loại sản phẩm', style: TextStyle(color: Colors.white)),
              dropdownColor: secondaryColor,
              validator: (value) => TValidator.validateProductType(value),
              style: TextStyle(color: Colors.white),
              items: controllerCategory.categories.map((category) {
                return DropdownMenuItem(
                  value: category.id,
                  child: Text(category.name, style: TextStyle(color: Colors.white)),
                );
              }).toList(),
              onChanged: (value) {
                final selectedCat = controllerCategory.categories
                    .firstWhere((cat) => cat.id == value);
                controllerCategory.setSelectedCategory(selectedCat);
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildDisplayOptions() {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Tùy chọn hiển thị', style: _textStyleHeader()),
          Obx(() {
            return Row(
              children: [
                Radio<String>(
                  value: 'Hiển thị',
                  groupValue: controller.displayOption.value,
                  onChanged: (value) {
                    controller.displayOption.value = value!;
                    controller.tuyChonHienThi.value = true;
                  },
                  activeColor: Colors.blue,
                ),
                Text('Hiển thị', style: TextStyle(color: Colors.white)),
                Radio<String>(
                  value: 'Ẩn',
                  groupValue: controller.displayOption.value,
                  onChanged: (value) {
                    controller.displayOption.value = value!;
                    controller.tuyChonHienThi.value = false;
                  },
                  activeColor: Colors.blue,
                ),
                Text('Ẩn', style: TextStyle(color: Colors.white)),
              ],
            );
          }),
        ],
      ),
    );
  }

  TextStyle _textStyleHeader() {
    return TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white);
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.white),
      filled: true,
      fillColor: secondaryColor,
      border: OutlineInputBorder(),
      hintText: label,
    );
  }
}
