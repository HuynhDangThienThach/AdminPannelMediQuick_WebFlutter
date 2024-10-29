import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants.dart';
import '../../models/product.dart';
import '../../routes/routes.dart';
import '../dashboard/components/header.dart';
import '../dashboard/components/recent_files.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

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
            Header(title: "Quản lý sản phẩm"),
            SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      RecentFiles(
                        title: "Danh sách sản phẩm",
                        textButton: "Tạo sản phẩm",
                        routes: Routes.createProducts,
                        onPressed: (routes) {
                          Get.toNamed(routes);
                        },
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
                        columns: ['id', 'stock', 'sold', 'brand', 'price', 'date']
                      ),
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


class ProductDataSource extends DataTableSource {
  final List<Product> products;
  int _selectedCount = 0;

  ProductDataSource(this.products);

  @override
  DataRow? getRow(int index) {
    if (index >= products.length) return null;
    final product = products[index];

    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text(product.id)),
        DataCell(Text(product.stock)),
        DataCell(Text(product.sold)),
        DataCell(Text(product.brand)),
        DataCell(Text(product.price)),
        DataCell(Text(product.date)),
        DataCell(Row(
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: Colors.blue),
              onPressed: () {
                print('Chỉnh sửa sản phẩm ${product.id}');
              },
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                print('Xóa sản phẩm ${product.id}');
              },
            ),
          ],
        )),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => products.length;
  @override
  int get selectedRowCount => _selectedCount;
}

