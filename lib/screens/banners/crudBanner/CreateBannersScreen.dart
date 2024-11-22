import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants.dart';
import '../../../controllers/banner_controller.dart';
import '../../dashboard/components/header.dart';
import 'LCreateBannerScreen.dart';
class CreateBannersScreen extends StatefulWidget {
  const CreateBannersScreen({super.key});

  @override
  State<CreateBannersScreen> createState() => _CreateBannersScreenState();
}
class _CreateBannersScreenState extends State<CreateBannersScreen> {

  @override
  Widget build(BuildContext context) {
  final controller = Get.put(BannerController());
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          primary: false,
          padding: EdgeInsets.all(defaultPadding),
          child: Column(
            children: [
              Header(title: "Tạo sự kiện", isButton: true),
              LCreateBannerScreen(),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: controller.createBanner,
          tooltip: 'Đăng sự kiện',
          child: Icon(Icons.check),
          backgroundColor: Colors.blueAccent,
          elevation: 6,
          mini: false,
        ),
      ),
    );
  }
}
