import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants.dart';
import '../../../models/order_model.dart';
import '../../../responsive.dart';
import '../../search/SearchScreen.dart';
import 'OrdersDetailsScreen.dart';

class OrderRecentFiles extends StatefulWidget {
  final String title;
  final String? textButton;
  final String? routes;
  final List<Map<String, dynamic>>? data;
  final List<String> columns;
  final bool isButton;
  final Function(String)? onPressed;
  final bool isLoading;
  final List<OrderModel>? order;

  const OrderRecentFiles({
    Key? key,
    required this.title,
    required this.data,
    required this.columns,
    this.textButton,
    this.isButton = false,
    this.onPressed,
    this.routes, this.isLoading = false, this.order,
  }) : super(key: key);

  @override
  _OrderRecentFilesState createState() => _OrderRecentFilesState();
}

class _OrderRecentFilesState extends State<OrderRecentFiles> {
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
              SizedBox(width: 20),
              if (!Responsive.isMobile(context)) Spacer(flex: Responsive.isDesktop(context) ? 1 : 1),
              Expanded(
                child: Column(
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
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blue,
                          minimumSize: Size(130, 30),
                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 5,
                        ),
                      ),
                  ],
                ),
              ),
              if (!Responsive.isMobile(context)) Spacer(flex: Responsive.isDesktop(context) ? 1 : 1),
              Expanded(child: SearchField(controller: _searchController)),
            ],
          ),
          const SizedBox(height: defaultPadding),
          if (widget.isLoading)
            Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            )
          else
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
    final filteredData = widget.data?.where((item) {
        String orderName = item['Id đơn hàng']?.toString() ?? '';
      return orderName.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList() ?? [];

    return filteredData.map((item) {
      List<DataCell> cells = [];
      for (var col in widget.columns) {
        if (col == 'Id đơn hàng') {
          String orderName = item[col]?.toString() ?? "";
          String displayOrderName = orderName.length > 30 ? '${orderName.substring(0, 30)}...' : orderName;
          cells.add(DataCell(
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                displayOrderName,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ));
        } else if (col == 'Ngày') {
          String ngayOrder= item[col]?.toString() ?? "";
          String displayNgayOrder = ngayOrder.length > 40 ? '${ngayOrder.substring(0, 40)}...' : ngayOrder;
          cells.add(DataCell(
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                displayNgayOrder,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ));
        } else if (col == 'Sản phẩm') {
          String sanPhamOrder= item[col]?.toString() ?? "";
          String displaySanPhamOrder = sanPhamOrder.length > 40 ? '${sanPhamOrder.substring(0, 40)}...' : sanPhamOrder;
          cells.add(DataCell(
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 20.0),
              child: Text(
                displaySanPhamOrder,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ));
        } else if (col == 'Trạng thái') {
          final selectedOrder = widget.order?.firstWhere(
                (order) => order.id == item["Id đơn hàng"],
            orElse: null,
          );
          final trangThaiOrder = selectedOrder?.orderStatusText ?? '';
          final orderColor = selectedOrder?.orderStatusColor ?? Colors.white;

          cells.add(DataCell(
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                decoration: BoxDecoration(
                  color: orderColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: orderColor,
                    width: 1.5,
                  ),
                ),
                child: Text(
                  trangThaiOrder,
                  style: TextStyle(
                    color: orderColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ),
          ));
        }


        else if (col == 'Tổng tiền') {
          String tongTienOrder= item[col]?.toString() ?? "";
          String displayTongTienOrder = tongTienOrder.length > 40 ? '${tongTienOrder.substring(0, 40)}...' : tongTienOrder;
          cells.add(DataCell(
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                displayTongTienOrder,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ));
        }
      }
      cells.add(DataCell(Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: Colors.blue),
              onPressed: () {
                final selectedOrder = widget.order?.firstWhere(
                      (order) => order.id == item["Id đơn hàng"],
                  orElse: null,
                );

                if (selectedOrder != null) {
                  Get.to(
                        () => OrdersDetailsScreen(),
                    arguments: selectedOrder,
                  );
                }
              },
            ),



            // IconButton(
            //   icon: Icon(Icons.delete, color: Colors.red),
            //   onPressed: () {
            //     showDialog(
            //       context: context,
            //       builder: (BuildContext context) {
            //         return AlertDialog(
            //           title: Text('Xác nhận xóa', style: TextStyle(color: Colors.white)),
            //           content: Text('Bạn có muốn xóa đơn hàng này không?', style: TextStyle(color: Colors.white)),
            //           backgroundColor: secondaryColor,
            //           actions: [
            //             TextButton(
            //               child: Text('Không', style: TextStyle(color: Colors.white)),
            //               onPressed: () {
            //                 Navigator.of(context).pop();
            //               },
            //             ),
            //             TextButton(
            //               child: Text('Có', style: TextStyle(color: Colors.white)),
            //               onPressed: () async {
            //                 Navigator.of(context).pop();
            //                 // await controller.deleteBrand(item['Id']);
            //               },
            //             ),
            //           ],
            //         );
            //       },
            //     );
            //   },
            // ),
          ],
        ),
      )));

      return DataRow(cells: cells);
    }).toList();
  }
}





