import 'package:admin/controllers/customer_controller.dart';
import 'package:admin/repository/customer_repository.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants.dart';
import '../../../responsive.dart';
import '../../../routes/routes.dart';
import '../../search/SearchScreen.dart';

class CustomerRecentFiles extends StatefulWidget {
  final String title;
  final String? textButton;
  final String? routes;
  final List<Map<String, dynamic>>? data;
  final List<String> columns;
  final bool isButton;
  final Function(String)? onPressed;

  const CustomerRecentFiles({
    Key? key,
    required this.title,
    required this.data,
    required this.columns,
    this.textButton,
    this.isButton = false,
    this.onPressed,
    this.routes,
  }) : super(key: key);

  @override
  _CustomerRecentFilesState createState() => _CustomerRecentFilesState();
}

class _CustomerRecentFilesState extends State<CustomerRecentFiles> {
  final controller = Get.put(CustomerController());
  final repositoryCustomer = Get.put(CustomerRepository());
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
    final filteredData = widget.data?.where((item) {
        String brandName = item['Tên người dùng']?.toString() ?? '';
      return brandName.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList() ?? [];

    return filteredData.map((item) {
      List<DataCell> cells = [];
      for (var col in widget.columns) {
        if (col == 'Ảnh') {
          cells.add(DataCell(
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1),
                    color: Colors.grey,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: item[col],
                      fit: BoxFit.contain,
                      placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error, color: Colors.red),
                    ),
                  ),
                ),
              )

          ));
        } else if (col == 'Tên người dùng') {
          String userName = item[col]?.toString() ?? "";
          String displayUserName = userName.length > 30 ? '${userName.substring(0, 30)}...' : userName;
          cells.add(DataCell(
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                displayUserName,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ));
        } else if (col == 'Email') {
          String emailUser = item[col]?.toString() ?? "";
          String displayEmailUser = emailUser.length > 40 ? '${emailUser.substring(0, 40)}...' : emailUser;
          cells.add(DataCell(
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                displayEmailUser,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ));
        }else if (col == 'Số điện thoại') {
          String phoneUser = item[col]?.toString() ?? "";
          String displayPhoneUser = phoneUser.length > 30 ? '${phoneUser.substring(0, 30)}...' : phoneUser;
          cells.add(DataCell(
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                displayPhoneUser,
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
                Get.toNamed(Routes.customerDetails, arguments: item['Id']);
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
            //           content: Text('Bạn có muốn xóa người dùng này không?', style: TextStyle(color: Colors.white)),
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





