import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants.dart';
import '../../controllers/product_controller.dart';
import '../../routes/routes.dart';
import '../dashboard/components/header.dart';
import 'recent_files.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final productController = Get.put(ProductController());
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header(title: "Quản lý sản phẩm"),
            SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      SizedBox(height: defaultPadding),
                      Obx(() => RecentFiles(
                        title: "Danh sách sản phẩm",
                        textButton: "Tạo sản phẩm",
                        routes: Routes.createProducts,
                        onPressed: (routes) {
                          Get.toNamed(routes);
                        },
                        data: productController.products
                            .where((product) => product.title.toLowerCase().contains(_searchQuery.toLowerCase()))
                            .map((product) => product.toMap())
                            .toList(),
                        columns: ['Tên sản phẩm', 'Số lượng', 'Thương hiệu', "Giá bán", "Giảm giá", "Ngày nhập"],
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
