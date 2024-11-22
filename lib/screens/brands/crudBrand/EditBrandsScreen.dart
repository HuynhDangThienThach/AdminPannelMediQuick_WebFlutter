import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants.dart';
import '../../../controllers/brandController.dart';
import '../../dashboard/components/header.dart';
import 'LEditBrandScreen.dart';
class EditBrandScreen extends StatefulWidget {
  const EditBrandScreen({super.key});

  @override
  State<EditBrandScreen> createState() => _EditBrandScreenState();
}
class _EditBrandScreenState extends State<EditBrandScreen> {
  final controller = Get.put(BrandController());
  late final String? brandId;

  @override
  void initState() {
    super.initState();
    brandId = Get.arguments;
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
              Header(title: "Chỉnh sửa thương hiệu", isButton: true),
              if (brandId != null && brandId!.isNotEmpty)
                LEditBrandsScreen(brandId: brandId!)
              else
                Center(child: Text('Không tìm thấy thông tin thương hiệu')),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            controller.updateBrand(brandId!);
          },
          tooltip: 'Cập nhật thương hiệu',
          child: Icon(Icons.check),
          backgroundColor: Colors.blueAccent,
          elevation: 6,
          mini: false,
        )
      ),
    );
  }
}
