import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';

import '../../constants.dart';
import '../../controllers/adminController.dart';
import '../../models/userAdmin_model.dart';
import '../dashboard/components/header.dart';

class ProfileScreen extends StatelessWidget {
  final String userId;
  ProfileScreen({required this.userId});

  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (userId.isEmpty) {
      return Center(
        child: Text(
          "Error: User ID is not provided.",
          style: TextStyle(color: Colors.red),
        ),
      );
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AdminController>(context, listen: false).fetchAdminData(userId);
    });

    return SafeArea(
      child: Consumer<AdminController>(
        builder: (context, adminController, child) {
          UserAdmin? admin = adminController.admin;

          if (admin == null) {
            return Center(child: CircularProgressIndicator());
          }

          nameController.text = admin.displayName;

          return Column(
            children: [
              Header(title: "Hồ sơ cá nhân"),
              SizedBox(height: defaultPadding),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: secondaryColor,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
                                if (result != null) {
                                  if (result.files.single.bytes != null) {

                                    Uint8List fileBytes = result.files.single.bytes!;
                                    String fileName = result.files.single.name;

                                    String? downloadUrl = await adminController.uploadProfileImageWeb(fileBytes, fileName, userId);
                                    if (downloadUrl != null) {
                                      adminController.updateAdminData(userId, {'Image': downloadUrl});
                                    }
                                  } else if (result.files.single.path != null) {

                                    File file = File(result.files.single.path!);
                                    String? downloadUrl = await adminController.uploadProfileImage(file, userId);
                                    if (downloadUrl != null) {
                                      adminController.updateAdminData(userId, {'Image': downloadUrl});
                                    }
                                  }
                                }
                              },

                              child: CircleAvatar(
                                radius: 50,
                                backgroundImage: admin.image.isNotEmpty
                                    ? NetworkImage(admin.image)
                                    : AssetImage('assets/images/profile_doctor.png')
                                as ImageProvider,
                                backgroundColor: Colors.grey[300],
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.blueAccent,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              admin.displayName,
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              admin.email,
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                        SizedBox(width: 30),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Trường Tên người dùng
                              TextField(
                                controller: nameController,
                                decoration: InputDecoration(
                                  labelText: 'Tên người dùng',
                                  prefixIcon: Icon(Icons.person),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              SizedBox(height: 20),
                              // Hiển thị Email
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: Icon(Icons.email),
                                title: Text('Email'),
                                subtitle: Text(
                                  admin.email,
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(height: 10),
                              // Hiển thị Roles
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: Icon(Icons.security),
                                title: Text('Vai trò'),
                                subtitle: Text(
                                  admin.roles,
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(height: 20),
                              // Nút cập nhật hồ sơ
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    adminController.updateAdminData(userId, {
                                      'DisplayName': nameController.text,
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(vertical: 16),
                                    backgroundColor: Colors.blueAccent,
                                  ),
                                  child: Text(
                                    "Cập nhật hồ sơ",
                                    style: TextStyle(fontSize: 16, color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

