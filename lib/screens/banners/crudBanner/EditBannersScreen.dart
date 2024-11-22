import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants.dart';
import '../../../controllers/banner_controller.dart';
import '../../dashboard/components/header.dart';
import 'LEditBannerScreen.dart';
class EditBannersScreen extends StatefulWidget {
  const EditBannersScreen({super.key});

  @override
  State<EditBannersScreen> createState() => _EditBannersScreenState();
}
class _EditBannersScreenState extends State<EditBannersScreen> {
  final controller = Get.put(BannerController());
  late final String? bannerId;

  @override
  void initState() {
    super.initState();
    bannerId = Get.arguments;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          primary: false,
          padding: EdgeInsets.all(defaultPadding),
          child: Column(
            children: [
              Header(title: "Chỉnh sửa sự kiện", isButton: true),
              if (bannerId != null && bannerId!.isNotEmpty)
                LEditBannerScreen(bannerId: bannerId!,)
              else
                Center(child: Text('Không tìm thấy thông tin sự kiện')),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            controller.updateBanner(bannerId!);
          },
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
