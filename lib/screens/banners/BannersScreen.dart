import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants.dart';
import '../../models/product.dart';
import '../../responsive.dart';
import '../../routes/routes.dart';
import '../dashboard/components/header.dart';
import '../dashboard/components/recent_files.dart';
import '../dashboard/components/storage_details.dart';
class BannersScreen extends StatelessWidget {
  const BannersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dữ liệu mẫu
    final List<Product> products = [
      Product(id: "1", stock: "20", sold: "5", brand: "Brand A", price: "\$10", date: "2024-01-01"),
      Product(id: "2", stock: "15", sold: "3", brand: "Brand B", price: "\$15", date: "2024-01-02"),
      Product(id: "3", stock: "30", sold: "8", brand: "Brand C", price: "\$20", date: "2024-01-03"),
    ];

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
                  flex: 5,
                  child: Column(
                    children: [
                      RecentFiles(
                        textButton: "Tạo sự kiện",
                        title: "Danh sách sự kiện",
                        routes: Routes.createBanners,
                        onPressed: (routes){Get.toNamed(routes);},
                        data: products.map((product) {
                          return {
                            'id': product.id,
                            'stock': product.stock,
                            'sold': product.sold,
                            'brand': product.brand,
                            'price': product.price,
                            'date': product.date,
                          };
                        }).toList(),
                        columns: ['id', 'stock', 'sold', 'brand', 'price', 'date'],
                      ),
                      if (Responsive.isMobile(context))
                        SizedBox(height: defaultPadding),
                      if (Responsive.isMobile(context)) StorageDetails(),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
