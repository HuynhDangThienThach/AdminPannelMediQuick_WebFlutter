import 'package:admin/controllers/banner_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';
import '../../../constants.dart';
import '../../../utils/validators/validation.dart';

class LCreateBannerScreen extends StatefulWidget {
  const LCreateBannerScreen({super.key});

  @override
  State<LCreateBannerScreen> createState() => _LCreateBannerScreenState();
}

class _LCreateBannerScreenState extends State<LCreateBannerScreen> {
  final controller = Get.put(BannerController());
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
      key: controller.createProductFormKey,
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _imageData == null
                              ? Image.asset("assets/images/default.png")
                              : Image.memory(_imageData!, height: 100, width: 100, fit: BoxFit.cover),
                          ElevatedButton(onPressed: _pickImage, child: Text('Chọn ảnh'),),
                          SizedBox(height: 16.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
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
                        ],
                      ),
                      SizedBox(height: 16.0),
                      Text('Địa chỉ chuyển tiếp', style: TextStyle(fontSize: 16, color: Colors.white),),
                      SizedBox(height: 16.0),
                      TextFormField(
                        controller: controller.redirect,
                        decoration: InputDecoration(
                          labelText: 'Màn hình chuyển hướng',
                          hintText: '/home',
                          labelStyle: TextStyle(color: Colors.white),
                          filled: true,
                          fillColor: secondaryColor,
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) => TValidator.validateBannerRedirect(value),
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(flex: 5,child: Text(""),)
        ],
      ),
    );
  }
}
