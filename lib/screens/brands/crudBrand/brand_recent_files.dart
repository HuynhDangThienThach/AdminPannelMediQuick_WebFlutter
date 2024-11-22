import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants.dart';
import '../../../controllers/brandController.dart';
import '../../../repository/brandRepository.dart';
import '../../../responsive.dart';
import '../../../routes/routes.dart';
import '../../search/SearchScreen.dart';

class BrandRecentFiles extends StatefulWidget {
  final String title;
  final String? textButton;
  final String? routes;
  final List<Map<String, dynamic>>? data;
  final List<String> columns;
  final bool isButton;
  final Function(String)? onPressed;

  const BrandRecentFiles({
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

class _RecentFilesState extends State<BrandRecentFiles> {
  final controller = Get.put(BrandController());
  final repositoryBrand = Get.put(BrandRepository());
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
      DataColumn(label: Text('Kích hoạt')),
      DataColumn(label: Text('Action')),
    ];
  }

  List<DataRow> _buildRows() {
    final filteredData = widget.data?.where((item) {
        String brandName = item['Tên thương hiệu']?.toString() ?? '';
      return brandName.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList() ?? [];

    return filteredData.map((item) {
      List<DataCell> cells = [];
      for (var col in widget.columns) {
        if (col == 'Ảnh') {
          cells.add(DataCell(
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: CachedNetworkImage(
                imageUrl: item[col],
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error, color: Colors.red),
              ),
            )
          ));
        } else if (col == 'Tên thương hiệu') {
          String brandName = item[col]?.toString() ?? "";
          String displayBrandName = brandName.length > 30 ? '${brandName.substring(0, 30)}...' : brandName;
          cells.add(DataCell(
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                displayBrandName,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ));
        }
      }

      cells.add(DataCell(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: IconButton(
            icon: Icon(
              item['Kích hoạt'] == true ? Icons.visibility : Icons.visibility_off,
              color: item['Kích hoạt'] == true ? Colors.green : Colors.grey,
            ),
            onPressed: () async {
              bool newStatus = !(item['Kích hoạt'] ?? false);
              await repositoryBrand.updateBrandStatusByInternalId(item['Id'], newStatus);
              setState(() {
                item['Kích hoạt'] = newStatus;
              });
            },
          ),
        ),
      ));

      cells.add(DataCell(Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: Colors.blue),
              onPressed: () {
                Get.toNamed(Routes.editBrands, arguments: item['Id']);
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
                      content: Text('Bạn có muốn xóa thương hiệu này không?', style: TextStyle(color: Colors.white)),
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
                            await controller.deleteBrand(item['Id']);
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
      )));

      return DataRow(cells: cells);
    }).toList();
  }
}





