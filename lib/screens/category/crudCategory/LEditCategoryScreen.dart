import 'package:admin/controllers/categoryController.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../constants.dart';

class LEditCategoryScreen extends StatefulWidget {
  const LEditCategoryScreen({super.key, required this.categoryId});
  final String categoryId;
  @override
  State<LEditCategoryScreen> createState() => _LEditCategoryScreenState();
}

class _LEditCategoryScreenState extends State<LEditCategoryScreen> {
  final controller = Get.put(CategoryController());
  Uint8List? _imageData;

  @override
  void initState() {
    super.initState();
    _loadCategoryData();
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.single.bytes != null) {
      setState(() {
        _imageData = result.files.single.bytes;
      });
      await controller.uploadImageToFirebase(_imageData!, result.files.single.name);
    }
  }

  Future<void> _loadCategoryData() async {
    await controller.getCategoryById(widget.categoryId);

    setState(() {
      if (controller.imageUrl.isNotEmpty) {
        _imageData = null;
      }
      controller.categoriesName.text = controller.categoriesName.text;
      controller.visibilityStatus = controller.tuyChonHienThi.value ? 'Hiển thị' : 'Ẩn';
      controller.parentID = controller.parentID;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.createCategoriesFormKey,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
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
                      Text(
                        'Thông tin cơ bản',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      SizedBox(height: 16.0),
                      Text('Hình ảnh danh mục', style: TextStyle(fontSize: 16, color: Colors.white),),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 16.0),
                          _imageData == null
                              ? controller.imageUrl.isNotEmpty
                              ? Image.network(
                            controller.imageUrl,
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              // Hiển thị ảnh mặc định khi xảy ra lỗi
                              return Image.asset("assets/images/default.png", height: 100, width: 100, fit: BoxFit.cover);
                            },
                          )
                              : Image.asset("assets/images/default.png", height: 100, width: 100, fit: BoxFit.cover)
                              : Image.memory(_imageData!, height: 100, width: 100, fit: BoxFit.cover),
                          SizedBox(height: 16.0),
                          ElevatedButton(onPressed: _pickImage, child: Text('Chọn ảnh'),),
                        ],
                      ),
                      SizedBox(height: 16.0),
                      Text('Tên danh mục', style: TextStyle(fontSize: 16, color: Colors.white),),
                      SizedBox(height: 16.0),
                      TextFormField(
                        controller: controller.categoriesName,
                        decoration: InputDecoration(
                          labelText: 'Nhập tên danh mục',
                          hintText: 'Dành cho trẻ em',
                          labelStyle: TextStyle(color: Colors.white),
                          filled: true,
                          fillColor: secondaryColor,
                          border: OutlineInputBorder(),
                        ),
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(height: 16.0),
                      Text('Chọn nhánh danh mục', style: TextStyle(fontSize: 16, color: Colors.white),),
                      SizedBox(height: 16.0),
                      Obx(
                            () => Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: List.generate(controller.categories.length, (index) {
                            final category = controller.categoriesList[index];
                            return ChoiceChip(
                              label: Text(category['Name']),
                              selected: controller.selectedCategoryName == category['Name'],
                              onSelected: (bool value) {
                                setState(() {
                                  if (value) {
                                    controller.selectedCategoryName = category['Name'];
                                    controller.parentID = category['ParentId'];
                                  } else {
                                    controller.selectedCategoryName = null;
                                    controller.parentID = null;
                                  }
                                });
                              },
                              selectedColor: Colors.blue,
                              backgroundColor: Colors.grey[200],
                              labelStyle: TextStyle(
                                color: controller.selectedCategoryName == category['Name'] ? Colors.white : Colors.black,
                              ),
                            );
                          }),
                        ),
                      ),

                      SizedBox(height: 16.0),
                      Text('Tùy chọn hiển thị', style: TextStyle(fontSize: 16, color: Colors.white),),
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
