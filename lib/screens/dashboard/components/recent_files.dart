import 'package:admin/controllers/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../constants.dart';
import '../../../responsive.dart';
import '../../../routes/routes.dart';
import '../../search/SearchScreen.dart';

class RecentFiles extends StatefulWidget {
  final String title;
  final String? textButton;
  final String? routes;
  final List<Map<String, dynamic>>? data;
  final List<String> columns;
  final bool isButton;
  final Function(String)? onPressed;

  const RecentFiles({
    Key? key,
    required this.title,
    required this.data,
    required this.columns,
    this.textButton,
    this.isButton = true,
    this.onPressed,
    this.routes,
  }) : super(key: key);

  @override
  _RecentFilesState createState() => _RecentFilesState();
}

class _RecentFilesState extends State<RecentFiles> {
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
  final controller = Get.put(ProductController());

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                widget.title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(width: 20,),
              if (!Responsive.isMobile(context))
                Spacer(flex: Responsive.isDesktop(context) ? 1 : 1),
              Expanded(child: Column(
                children: [
                  if (widget.isButton)
                    ElevatedButton(
                      onPressed: () {
                        if (widget.onPressed != null) {
                          widget.onPressed!(widget.routes!);
                        }
                      },
                      child: Text(
                        widget.textButton!,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blue,
                        minimumSize: Size(130, 30),
                        padding: EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 5,
                      ),
                    ),
                ],
              ),),
              if (!Responsive.isMobile(context))
                Spacer(flex: Responsive.isDesktop(context) ? 1 : 1),
              Expanded(child: SearchField(controller: _searchController)),
            ],
          ),
          SizedBox(
            width: double.infinity,
            child: DataTable(
              columnSpacing: defaultPadding,
              columns: _buildColumns(),
              rows: _buildRows(),
            ),
          ),
        ],
      ),
    );
  }

  List<DataColumn> _buildColumns() {
    return [
      ...widget.columns.map((col) => DataColumn(label: Text(col))),
      DataColumn(label: Text('Action')),
    ];
  }

  List<DataRow> _buildRows() {
    // Lọc dữ liệu theo _searchQuery
    final filteredData = widget.data?.where((item) {
      String productName = item['Tên sản phẩm']?.toString() ?? '';
      return productName.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList() ?? [];

    return filteredData.map((item) {
      List<DataCell> cells = [];
      for (var col in widget.columns) {
        if (col == 'Tên sản phẩm') {
          String productName = item[col]?.toString() ?? "";
          String displayName = productName.length > 30 ? '${productName.substring(0, 30)}...' : productName;

          cells.add(DataCell(
            Text(
              displayName,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ));
        } else if (col == 'Ngày nhập') {
          DateTime? entryDate = DateTime.tryParse(item[col]?.toString() ?? "");
          String formattedDate = entryDate != null ? '${entryDate.day}/${entryDate.month}/${entryDate.year}' : '';
          cells.add(DataCell(Text(formattedDate)));
        } else if (col == 'Giá bán' || col == 'Giảm giá') {
          double price = item[col] != null ? double.tryParse(item[col]?.toString() ?? "") ?? 0 : 0;
          String formattedPrice = '${NumberFormat('#,##0').format(price)}đ';
          cells.add(DataCell(Text(formattedPrice)));
        } else {
          cells.add(DataCell(Text(item[col]?.toString() ?? "")));
        }
      }

      cells.add(DataCell(Row(
        children: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.blue),
            onPressed: () {
              Get.toNamed(Routes.editProducts, arguments: item['id']);
              print('${item['id']}');
            },
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Xác nhận xóa', style: TextStyle(color: Colors.white)),
                    content: Text('Bạn có muốn xóa sản phẩm này không?', style: TextStyle(color: Colors.white)),
                    backgroundColor: secondaryColor,
                    actions: [
                      TextButton(
                        child: Text('Không', style: TextStyle(color: Colors.white)),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text('Có', style: TextStyle(color: Colors.white)),
                        onPressed: () async {
                          Navigator.of(context).pop();
                          await controller.deleteProduct(item['id']);
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      )));


      return DataRow(cells: cells);
    }).toList();
  }
}





