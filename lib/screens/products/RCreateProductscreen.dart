import 'package:flutter/material.dart';

import '../../constants.dart';

class RCreateProductScreen extends StatefulWidget {
  const RCreateProductScreen({super.key});

  @override
  State<RCreateProductScreen> createState() => _RCreateProductScreenState();
}

class _RCreateProductScreenState extends State<RCreateProductScreen> {
  String? selectedBrand;
  String? selectedProductType;
  String displayOption = 'Hiển thị';

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Container 1: Hình thu nhỏ (Thumbnail)
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
                  'Hình thu nhỏ (Thumbnail)',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
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
              ],
            ),
          ),
          SizedBox(height: 16.0),

          // Container 2: Ảnh của sản phẩm
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
                  'Ảnh của sản phẩm',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: 16.0),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Nhập đường link ảnh ${index + 1}',
                          labelStyle: TextStyle(color: Colors.white),
                          filled: true,
                          fillColor: secondaryColor,
                          border: OutlineInputBorder(),
                        ),
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 16.0),

          // Container 3: Thương hiệu
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
                  'Thương hiệu',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: 16.0),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: secondaryColor,
                    border: OutlineInputBorder(),
                  ),
                  value: selectedBrand,
                  hint: Text('Chọn thương hiệu', style: TextStyle(color: Colors.white, fontSize: 15)),
                  dropdownColor: secondaryColor,
                  style: TextStyle(color: Colors.white),
                  items: ['Brand A', 'Brand B', 'Brand C']
                      .map((brand) => DropdownMenuItem(
                    value: brand,
                    child: Text(brand),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedBrand = value;
                    });
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 16.0),

          // Container 4: Loại sản phẩm
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
                  'Loại sản phẩm',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: 16.0),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: secondaryColor,
                    border: OutlineInputBorder(),
                  ),
                  value: selectedProductType,
                  hint: Text('Chọn loại sản phẩm', style: TextStyle(color: Colors.white, fontSize: 15)),
                  dropdownColor: secondaryColor,
                  style: TextStyle(color: Colors.white),
                  items: ['Type A', 'Type B', 'Type C']
                      .map((type) => DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedProductType = value;
                    });
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 16.0),

          // Container 5: Tùy chọn hiển thị
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
                  'Tùy chọn hiển thị',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                Row(
                  children: [
                    Radio<String>(
                      value: 'Hiển thị',
                      groupValue: displayOption,
                      onChanged: (value) {
                        setState(() {
                          displayOption = value!;
                        });
                      },
                      activeColor: Colors.blue,
                    ),
                    Text('Hiển thị', style: TextStyle(color: Colors.white)),
                    Radio<String>(
                      value: 'Ẩn',
                      groupValue: displayOption,
                      onChanged: (value) {
                        setState(() {
                          displayOption = value!;
                        });
                      },
                      activeColor: Colors.blue,
                    ),
                    Text('Ẩn', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
