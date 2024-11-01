import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../controllers/adminController.dart';
import '../../models/userAdmin_model.dart';
import '../dashboard/components/header.dart';

class ProfileScreen extends StatelessWidget {
  final String userId;
  ProfileScreen({required this.userId});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AdminController>(context, listen: false).fetchAdminData(userId);
    });

    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: EdgeInsets.all(defaultPadding),
        child: Consumer<AdminController>(
          builder: (context, adminController, child) {
            UserAdmin? admin = adminController.admin;

            if (admin == null) {
              return Center(child: CircularProgressIndicator());
            }

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
                          // Profile Picture
                          Column(
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundImage: admin.image.isNotEmpty
                                    ? AssetImage('assets/images/profile_doctor.png') as ImageProvider
                                    : NetworkImage(admin.image),
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
                          // Profile Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Chi tiết hồ sơ",
                                  style: TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                                SizedBox(height: 20),
                                TextField(
                                  decoration: InputDecoration(
                                    labelText: 'Tên người dùng',
                                    hintText: admin.displayName,
                                    prefixIcon: Icon(Icons.person),
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                SizedBox(height: 20),
                                // Email
                                TextField(
                                  decoration: InputDecoration(
                                    labelText: 'Email',
                                    hintText: admin.email,
                                    prefixIcon: Icon(Icons.email),
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                SizedBox(height: 20),
                                // Role
                                TextField(
                                  decoration: InputDecoration(
                                    labelText: 'Vai trò',
                                    hintText: admin.roles,
                                    prefixIcon: Icon(Icons.person_rounded),
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                SizedBox(height: 20),
                                // Update Button
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // Add your update profile logic here
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
      ),
    );
  }
}
