import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../models/brand_model.dart';

class BrandController extends GetxController {
  static BrandController get instance => Get.find();

  //--- Variables
  final RxList<BrandModel> brands = <BrandModel>[].obs;
  BrandModel? selectedBrand;

  void onInit() {
    super.onInit();
    fetchBrands();
  }
  //--- Functions
  Future<void> fetchBrands() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('Brands').get();
      brands.value = snapshot.docs.map((doc) => BrandModel.fromSnapshot(doc)).toList();
    } catch (e) {
      print('Lỗi khi tải thương hiệu: $e');
    }
  }

  void setSelectedBrand(BrandModel brand) {
    selectedBrand = brand;
  }
}
