import 'package:admin/controllers/banner_controller.dart';
import 'package:admin/repository/banner_repository.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants.dart';
import '../../../responsive.dart';
import '../../../routes/routes.dart';
class BannerRecentFiles extends StatefulWidget {
  final String title;
  final String? textButton;
  final String? routes;
  final List<Map<String, dynamic>>? data;
  final List<String> columns;
  final bool isButton;
  final Function(String)? onPressed;

  const BannerRecentFiles({
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
  _BannerRecentFilesState createState() => _BannerRecentFilesState();
}

class _BannerRecentFilesState extends State<BannerRecentFiles> {
  final controller = Get.put(BannerController());
  final repositoryBanner = Get.put(BannerRepository());
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
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
              Expanded(child: Text("")),
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
      DataColumn(label: Text('Kích hoạt')),
      DataColumn(label: Text('Action')),
    ];
  }

  List<DataRow> _buildRows() {
    return widget.data?.map((item) {
      List<DataCell> cells = [];

      for (var col in widget.columns) {
        if (col == 'Ảnh sự kiện') {
          // Hiển thị ảnh sự kiện từ URL
          cells.add(DataCell(
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0), // Thêm khoảng cách trên và dưới
              child: CachedNetworkImage(
                imageUrl: item[col],
                width: 100,
                height: 100,
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error, color: Colors.red),
              ),
            ),
          ));
        } else if (col == 'Đường dẫn ảnh') {
          cells.add(DataCell(
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0), // Thêm khoảng cách trên và dưới
              child: Text(item[col]?.toString() ?? ""),
            ),
          ));
        } else {
          cells.add(DataCell(
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0), // Thêm khoảng cách trên và dưới
              child: Text(item[col]?.toString() ?? ""),
            ),
          ));
        }
      }

      // Thêm DataCell cho cột "Kích hoạt" với 2 icon mở mắt và nhắm mắt
      cells.add(DataCell(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0), // Thêm khoảng cách trên và dưới
          child: IconButton(
            icon: Icon(
              item['Kích hoạt'] == true ? Icons.visibility : Icons.visibility_off,
              color: item['Kích hoạt'] == true ? Colors.green : Colors.grey,
            ),
            onPressed: () async {
              bool newStatus = !(item['Kích hoạt'] ?? false);
              await repositoryBanner.updateBannerStatusByInternalId(item['id'], newStatus);
              setState(() {
                item['Kích hoạt'] = newStatus;
              });
            },
          ),
        ),
      ));

      // Thêm các icon chỉnh sửa và xóa
      cells.add(DataCell(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0), // Thêm khoảng cách trên và dưới
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.edit, color: Colors.blue),
                onPressed: () {
                  Get.toNamed(Routes.editBanners, arguments: item['id']);
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
                        content: Text('Bạn có muốn xóa sự kiện này không?', style: TextStyle(color: Colors.white)),
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
                            onPressed: () {
                              Navigator.of(context).pop();
                              // Gọi phương thức deleteBanner trong BannerController
                              controller.deleteBanner(item['id']);
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ));

      return DataRow(cells: cells);
    }).toList() ?? [];
  }


}
