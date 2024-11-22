import 'dart:typed_data';
import 'package:admin/controllers/brandController.dart';
import 'package:admin/utils/validators/validation.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants.dart';

class LCreateBrandsScreen extends StatefulWidget {
  const LCreateBrandsScreen({super.key});
  @override
  State<LCreateBrandsScreen> createState() => _LCreateBrandsScreenState();
}

class _LCreateBrandsScreenState extends State<LCreateBrandsScreen> {
  final controller = Get.put(BrandController());


  Uint8List? _imageData;

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.single.bytes != null) {
      setState(() {
        _imageData = result.files.single.bytes;
      });
      await controller.uploadImageToFirebase(_imageData!, result.files.single.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.createBannerFormKey,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Information section
                Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Thông tin cơ bản', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),),
                      SizedBox(height: 16.0),
                      Text('Hình ảnh thương hiệu', style: TextStyle(fontSize: 16, color: Colors.white),),
                      SizedBox(height: 16.0),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _imageData == null
                              ? Image.asset("assets/images/default.png")
                              : Image.memory(_imageData!, height: 100, width: 100, fit: BoxFit.cover),
                          ElevatedButton(onPressed: _pickImage, child: Text('Chọn ảnh'),),
                        ],
                      ),
                      SizedBox(height: 16.0),
                      Text('Tên thương hiệu', style: TextStyle(fontSize: 16, color: Colors.white),),
                      SizedBox(height: 16.0),
                      TextFormField(
                        controller: controller.brandName,
                        decoration: InputDecoration(
                          labelText: 'Nhập tên thương hiệu',
                          hintText: 'Phamarcity',
                          labelStyle: TextStyle(color: Colors.white),
                          filled: true,
                          fillColor: secondaryColor,
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) => TValidator.validateBrands(value),
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(height: 16.0),
                      Text('Số lượng sản phẩm', style: TextStyle(fontSize: 16, color: Colors.white),),
                      SizedBox(height: 16.0),
                      TextFormField(
                        controller: controller.brandCount,
                        decoration: InputDecoration(
                          labelText: 'Nhập số lượng sản phẩm',
                          hintText: '123',
                          labelStyle: TextStyle(color: Colors.white),
                          filled: true,
                          fillColor: secondaryColor,
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) => TValidator.validateProductStock(value),
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(height: 16.0),
                      Text('Chọn danh mục', style: TextStyle(fontSize: 16, color: Colors.white),),
                      SizedBox(height: 16.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: List.generate(controller.categories.length, (index) {
                              return ChoiceChip(
                                label: Text(controller.categories[index].name),
                                selected: controller.selectedCategory[index],
                                onSelected: (bool value) {
                                  setState(() {
                                    controller.selectedCategory[index] = value;
                                  });
                                },
                                selectedColor: Colors.blue,
                                backgroundColor: Colors.grey[200],
                                labelStyle: TextStyle(
                                  color: controller.selectedCategory[index] ? Colors.white : Colors.black,
                                ),
                              );
                            }),
                          ),
                          SizedBox(height: 8),
                          Obx(() {
                            return controller.validateCategorySelection()
                                ? Container()
                                : Text(
                              'Vui lòng chọn ít nhất một danh mục',
                              style: TextStyle(color: Colors.red),
                            );
                          }),
                        ],
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        'Tùy chọn hiển thị',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      SizedBox(height: 16.0),
                      Row(
                        children: [
                          Radio<String>(
                            value: 'Hiển thị',
                            groupValue: controller.visibilityStatus,
                            onChanged: (value) {
                              setState(() {
                                controller.visibilityStatus = value!;
                                controller.tuyChonHienThi.value = true;
                              });
                            },
                            activeColor: Colors.blue,
                          ),
                          Text('Hiển thị', style: TextStyle(color: Colors.white)),
                          Radio<String>(
                            value: 'Ẩn',
                            groupValue: controller.visibilityStatus,
                            onChanged: (value) {
                              setState(() {
                                controller.visibilityStatus = value!;
                                controller.tuyChonHienThi.value = false;
                              });
                            },
                            activeColor: Colors.blue,
                          ),
                          Text('Ẩn', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                      SizedBox(height: 16.0),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
