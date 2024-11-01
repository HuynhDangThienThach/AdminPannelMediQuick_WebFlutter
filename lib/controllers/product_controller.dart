import 'package:admin/controllers/categoryController.dart';
import 'package:admin/utils/validators/validation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../models/product_attribute_model.dart';
import '../models/product_model.dart';
import '../models/product_variation_model.dart';
import '../repository/product_repository.dart';
import '../utils/validators/loaders.dart';
import 'brandController.dart';

class ProductController extends GetxController {
  static ProductController get instance => Get.find();
  final productRepository = Get.put(ProductRepository());
  final controllerBrand = Get.put(BrandController());
  final controllerCategory = Get.put(CategoryController());

  final tenSp = TextEditingController();
  final motaSP = TextEditingController();
  final soLuong = TextEditingController();
  final giaBan = TextEditingController();
  final giamGia = TextEditingController();
  final hinhdh = TextEditingController();
  final TextEditingController tenThuocTinh = TextEditingController();
  final TextEditingController thuoctinh = TextEditingController();
  final List<TextEditingController> imageControllers = List.generate(4, (_) => TextEditingController());

  GlobalKey<FormState> createProductFormKey = GlobalKey<FormState>();
  String displayOption = 'Hiển thị';
  String priceType = 'single';
  var isVariantVisible = false.obs;
  var expandedVariants = <bool>[].obs;
  RxString loaiGiaTri = ''.obs;
  RxBool tuyChonHienThi = false.obs;
  final products = <ProductModel>[].obs;
  Rx<ProductModel> product = ProductModel.empty().obs;
  RxList<Map<String, dynamic>> attributes = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllFeaturedProducts();
  }

  void addAttribute() {
    List<String> values = thuoctinh.text.split('|');
    attributes.add({
      'name': tenThuocTinh.text,
      'value': values,
    });
    expandedVariants.add(false);
    tenThuocTinh.clear();
    thuoctinh.clear();
    update();
  }

  void clearFields() {
    tenSp.clear();
    motaSP.clear();
    soLuong.clear();
    giaBan.clear();
    giamGia.clear();
    hinhdh.clear();
    imageControllers.forEach((controller) => controller.clear());
    attributes.clear();
    tuyChonHienThi.value = false;
    loaiGiaTri.value = '';
  }

  void createProduct() async {
    try {
      if (!createProductFormKey.currentState!.validate()) {
        return;
      }

      int stockValue = int.tryParse(soLuong.text.trim()) ?? 0;
      double priceValue = double.tryParse(giaBan.text.trim()) ?? 0.0;
      double salePriceValue = double.tryParse(giamGia.text.trim()) ?? 0.0;

      List<ProductAttributeModel> productAttributes = attributes.map((attr) {
        return ProductAttributeModel(
          name: attr['name']!,
          values: List<String>.from(attr['value'] as List),
        );
      }).toList();

      List<String> images = imageControllers.map((controller) => controller.text.trim()).toList();

      List<ProductVariationModel> productVariations = attributes.map((attr) {
        Map<String, String> attributeValues = {
          for (var attribute in productAttributes)
            attribute.name ?? '': attribute.values!.join(', ')
        };

        return ProductVariationModel(
          id: '',  // ID sẽ được tạo sau nếu cần
          sku: TValidator.generateRandomSku(8),
          image: hinhdh.text.trim(),
          description: motaSP.text.trim(),
          price: priceValue,
          salePrice: salePriceValue,
          stock: stockValue,
          attributeValues: attributeValues,
        );
      }).toList();

      final newProduct = ProductModel(
        id: '',
        title: tenSp.text.trim(),
        description: motaSP.text.trim(),
        stock: stockValue,
        price: priceValue,
        salePrice: salePriceValue,
        productType: loaiGiaTri.value,
        thumbnail: hinhdh.text.trim(),
        brand: controllerBrand.selectedBrand,
        categoryId: controllerCategory.selectedCategory?.id,
        productAttributes: productAttributes,
        date: DateTime.now(),
        isFeatured: tuyChonHienThi.value,
        sku: TValidator.generateRandomSku(8),
        images: images,
        productVariations: productVariations,
      );

      await productRepository.saveUserRecord(newProduct);
      TLoaders.successSnackBar(
        title: 'Chúc mừng',
        message: 'Sản phẩm của bạn đã được thêm thành công!',
      );

      clearFields();

    } catch (e) {
      TLoaders.errorSnackBar(
        title: 'Chà, thật đáng tiếc!',
        message: e.toString(),
      );
    }
  }


  Future<void> fetchAllFeaturedProducts() async {
    try {
      final fetchedProducts = await productRepository.getAllFeaturedProducts();
      products.assignAll(fetchedProducts);
    } catch (e) {
      TLoaders.errorSnackBar(
          title: 'Chà, thật đáng tiếc!', message: e.toString());
    }
  }

  Future<void> getProductById(String productId) async {
    try {
      final fetchedProduct = await productRepository.getProductById(productId);
      if (fetchedProduct != null) {
        product.value = fetchedProduct;
      }
    } catch (e) {
      TLoaders.errorSnackBar(
        title: 'Không tìm thấy sản phẩm',
        message: e.toString(),
      );
    }
  }


  Future<void> updateProduct(String productId) async {
    try {
      int stockValue = int.tryParse(soLuong.text.trim()) ?? 0;
      double priceValue = double.tryParse(giaBan.text.trim()) ?? 0.0;
      double salePriceValue = double.tryParse(giamGia.text.trim()) ?? 0.0;

      Map<String, dynamic> updatedData = {
        'title': tenSp.text.trim(),
        'description': motaSP.text.trim(),
        'stock': stockValue,
        'price': priceValue,
        'salePrice': salePriceValue,
        'thumbnail': hinhdh.text.trim(),
        'isFeatured': tuyChonHienThi.value,
        'categoryId': controllerCategory.selectedCategory?.id,
        'productAttributes': attributes.map((attr) {
          return ProductAttributeModel(
            name: attr['name'],
            values: List<String>.from(attr['value']),
          ).toJson();
        }).toList(),
        'images': imageControllers.map((controller) => controller.text.trim()).toList(),
        'productType': loaiGiaTri.value,
      };


      await productRepository.updateProduct(productId, updatedData);

      int index = products.indexWhere((p) => p.id == productId);
      if (index != -1) {
        products[index] = products[index].copyWith(
          title: updatedData['title'],
          description: updatedData['description'],
          stock: updatedData['stock'],
          price: updatedData['price'],
          salePrice: updatedData['salePrice'],
          thumbnail: updatedData['thumbnail'],
          isFeatured: updatedData['isFeatured'],
          categoryId: updatedData['categoryId'],
          images: List<String>.from(updatedData['images'] ?? []),
          productType: updatedData['productType'],
          productAttributes: updatedData['productAttributes'].map<ProductAttributeModel>((json) => ProductAttributeModel.fromJson(json)).toList(),
        );
        products.refresh();
      }

      TLoaders.successSnackBar(
        title: 'Cập nhật thành công',
        message: 'Sản phẩm đã được cập nhật thành công!',
      );
    } catch (e) {
      TLoaders.errorSnackBar(
        title: 'Cập nhật thất bại',
        message: e.toString(),
      );
    }
  }
  Future<void> deleteProduct(String productId) async {
    try {
      // Giả sử bạn có một phương thức trong Firestore để xóa sản phẩm
      await FirebaseFirestore.instance.collection('Products').doc(productId).delete();
      // Nếu cần, cập nhật danh sách sản phẩm sau khi xóa
      products.removeWhere((product) => product.id == productId);
    } catch (e) {
      // Xử lý lỗi nếu có
      print('Error deleting product: $e');
    }
  }
}

