import 'package:flutter/material.dart';
import '../../../constants.dart';
import '../../../responsive.dart';
import '../../search/SearchScreen.dart';

class RecentFiles extends StatelessWidget {
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
                title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(width: 20,),
              if (!Responsive.isMobile(context))
                Spacer(flex: Responsive.isDesktop(context) ? 1 : 1),
              Expanded(child: Column(
                children: [
                  if (isButton)
                    ElevatedButton(
                      onPressed: () {
                        if (onPressed != null) {
                          onPressed!(routes!);
                        }
                      },
                      child: Text(
                        textButton!,
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
              ),),
              if (!Responsive.isMobile(context))
                Spacer(flex: Responsive.isDesktop(context) ? 1 : 1),
              Expanded(child: SearchField()),
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
      ...columns.map((col) => DataColumn(label: Text(col))),
      DataColumn(label: Text('Action')),
    ];
  }

  List<DataRow> _buildRows() {
    return data?.map((item) {
      List<DataCell> cells = [];
      for (var col in columns) {
        cells.add(DataCell(Text(item[col]?.toString() ?? "")));
      }


      cells.add(DataCell(Row(
        children: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.blue),
            onPressed: () {
              print('Chỉnh sửa sản phẩm ${item['id']}');
            },
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              print('Xóa sản phẩm ${item['id']}');
            },
          ),
        ],
      )));

      return DataRow(cells: cells);
    }).toList() ?? [];
  }
}




