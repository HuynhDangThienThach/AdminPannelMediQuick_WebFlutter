import 'package:flutter/material.dart';

import '../../constants.dart';


class LCreateCategoryScreen extends StatefulWidget {
  const LCreateCategoryScreen({super.key});

  @override
  State<LCreateCategoryScreen> createState() => _LCreateCategoryScreenState();
}

class _LCreateCategoryScreenState extends State<LCreateCategoryScreen> {
  String? _visibilityStatus = 'show';
  final List<String> categories = [
    'Sports',
    'Electronics',
    'Clothes',
    'Animals',
    'Furniture',
    'Ahyayator',
  ];

  final List<bool> selected = [false, false, false, false, false, false];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Information section
          Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: secondaryColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Thông tin cơ bản',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: 16.0),

                // Hình thức
                Text(
                  'Tùy chọn hiển thị',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                Row(
                  children: [
                    Radio<String>(
                      value: 'Hiển thị',
                      groupValue: _visibilityStatus,
                      onChanged: (value) {
                        setState(() {
                          _visibilityStatus = value!;
                        });
                      },
                      activeColor: Colors.blue,
                    ),
                    Text('Hiển thị', style: TextStyle(color: Colors.white)),
                    Radio<String>(
                      value: 'Ẩn',
                      groupValue: _visibilityStatus,
                      onChanged: (value) {
                        setState(() {
                          _visibilityStatus = value!;
                        });
                      },
                      activeColor: Colors.blue,
                    ),
                    Text('Ẩn', style: TextStyle(color: Colors.white)),
                  ],
                ),

                SizedBox(height: 16.0),

                Text(
                  'Hình ảnh doanh mục',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Nhập đường link của ảnh',
                    labelStyle: TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: secondaryColor,
                    border: OutlineInputBorder(),
                  ),
                  style: TextStyle(color: Colors.white),
                ),

                SizedBox(height: 16.0),

                Text(
                  'Tên doanh mục',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Nhập tên doanh mục',
                    hintText: 'Dành cho trẻ em',
                    labelStyle: TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: secondaryColor,
                    border: OutlineInputBorder(),
                  ),
                  style: TextStyle(color: Colors.white),
                ),

                SizedBox(height: 16.0),

                Text(
                  'Chọn nhánh danh mục',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                SizedBox(height: 16.0),

                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: List.generate(categories.length, (index) {
                    return ChoiceChip(
                      label: Text(categories[index]),
                      selected: selected[index],
                      onSelected: (bool value) {
                        setState(() {
                          selected[index] = value;
                        });
                      },
                      selectedColor: Colors.blue, // Màu xanh khi được chọn
                      backgroundColor: Colors.grey[200], // Màu nền khi chưa được chọn
                      labelStyle: TextStyle(
                        color: selected[index] ? Colors.white : Colors.black,
                      ),
                    );
                  }),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
