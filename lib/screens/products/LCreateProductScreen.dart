import 'package:flutter/material.dart';

import '../../constants.dart';

class LCreateProductScreen extends StatefulWidget {
  const LCreateProductScreen({super.key});

  @override
  State<LCreateProductScreen> createState() => _LCreateProductScreenState();
}

class _LCreateProductScreenState extends State<LCreateProductScreen> {
  String priceType = 'single';
  List<Map<String, String>> attributes = [];
  final TextEditingController attributeNameController = TextEditingController();
  final TextEditingController attributeValueController = TextEditingController();

  // Hàm thêm thuộc tính vào danh sách
  void addAttribute() {
    setState(() {
      attributes.add({
        'name': attributeNameController.text,
        'value': attributeValueController.text,
      });
      attributeNameController.clear();
      attributeValueController.clear();
    });
  }

  // Hàm xóa thuộc tính
  void removeAttribute(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Xác nhận xóa', style: TextStyle(color: Colors.white)),
          content: Text('Bạn có muốn xóa thuộc tính này không?', style: TextStyle(color: Colors.white)),
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
                setState(() {
                  attributes.removeAt(index);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 7,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thông tin cơ bản
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
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Tên sản phẩm',
                    labelStyle: TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: secondaryColor,
                    border: OutlineInputBorder(),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Mô tả sản phẩm',
                    labelStyle: TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: secondaryColor,
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 4,
                  textAlign: TextAlign.justify,
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.0),

          // Số lượng và giá cả
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
                  'Số lượng và giá cả',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: 16.0),
                Text('Loại giá cả', style: TextStyle(fontSize: 16, color: Colors.white)),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            priceType = 'single';
                          });
                        },
                        child: Row(
                          children: [
                            Radio(
                              value: 'single',
                              groupValue: priceType,
                              onChanged: (value) {
                                setState(() {
                                  priceType = value.toString();
                                });
                              },
                              activeColor: Colors.blue,
                            ),
                            Text('Một giá', style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            priceType = 'variable';
                          });
                        },
                        child: Row(
                          children: [
                            Radio(
                              value: 'variable',
                              groupValue: priceType,
                              onChanged: (value) {
                                setState(() {
                                  priceType = value.toString();
                                });
                              },
                              activeColor: Colors.blue,
                            ),
                            Text('Nhiều giá', style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Số lượng',
                    labelStyle: TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: secondaryColor,
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Giá bán',
                    labelStyle: TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: secondaryColor,
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Giảm giá',
                    labelStyle: TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: secondaryColor,
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 16.0),
                Divider(thickness: 2, color: Colors.grey[300]),
                SizedBox(height: 16.0),
                Text(
                  'Thuộc tính của sản phẩm',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: attributeNameController,
                        decoration: InputDecoration(
                          labelText: 'Tên thuộc tính',
                          labelStyle: TextStyle(color: Colors.white),
                          filled: true,
                          fillColor: secondaryColor,
                          border: OutlineInputBorder(),
                        ),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(width: 16.0),
                    Expanded(
                      child: TextFormField(
                        controller: attributeValueController,
                        decoration: InputDecoration(
                          labelText: 'Thuộc tính',
                          labelStyle: TextStyle(color: Colors.white),
                          filled: true,
                          fillColor: secondaryColor,
                          border: OutlineInputBorder(),
                        ),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(width: 16.0),
                    ElevatedButton(
                      onPressed: addAttribute,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blue,
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 5,
                      ),
                      child: Text('Thêm', style: TextStyle(color: Colors.white)),
                    ),

                  ],
                ),
                SizedBox(height: 20.0),

                // Tất cả thuộc tính
                Text(
                  'Tất cả thuộc tính',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: 16.0),
                Column(
                  children: attributes.map((attribute) {
                    int index = attributes.indexOf(attribute);
                    return Card(
                      child: ListTile(
                        title: Text('${attribute['name']}:${attribute['value']}', style: TextStyle(color: Colors.white)),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => removeAttribute(index),
                        ),
                      ),
                      color: secondaryColor,
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
