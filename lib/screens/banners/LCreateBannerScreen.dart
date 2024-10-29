import 'package:flutter/material.dart';

import '../../constants.dart';

class LCreateBannerScreen extends StatefulWidget {
  const LCreateBannerScreen({super.key});

  @override
  State<LCreateBannerScreen> createState() => _LCreateBannerScreenState();
}

class _LCreateBannerScreenState extends State<LCreateBannerScreen> {
  String? _visibilityStatus = 'show';

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
                  'Hình ảnh sự kiện',
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
                  'Địa chỉ chuyển tiếp',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Nhập màn hình chuyển tiếp',
                    hintText: '/home',
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
        ],
      ),
    );
  }
}
