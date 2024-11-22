import 'package:admin/controllers/banner_controller.dart';
import 'package:admin/screens/banners/crudBanner/banner_recent_files.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants.dart';
import '../../routes/routes.dart';
import '../dashboard/components/header.dart';

class BannersScreen extends StatefulWidget {
  const BannersScreen({super.key});

  @override
  _BannersScreenState createState() => _BannersScreenState();
}

class _BannersScreenState extends State<BannersScreen> {
  final bannerController = Get.put(BannerController());
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header(title: "Quản lý sự kiện"),
            SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      SizedBox(height: defaultPadding),
                      Obx(() => BannerRecentFiles(
                        title: "Danh sách sự kiện",
                        textButton: "Tạo sự kiện",
                        routes: Routes.createBanners,
                        onPressed: (routes) {
                          Get.toNamed(routes);
                        },
                        data: bannerController.banners.map((banner) => banner.toJson())
                            .toList(),
                        columns: ['Ảnh sự kiện', 'Đường dẫn ảnh'],
                      )),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}