import 'package:flutter/material.dart';
import '../../constants.dart';
import '../dashboard/components/header.dart';
import 'LCreateProductScreen.dart';
import 'RCreateProductscreen.dart';

class CreateProductsScreen extends StatefulWidget {
  @override
  _CreateProductsScreenState createState() => _CreateProductsScreenState();
}

class _CreateProductsScreenState extends State<CreateProductsScreen> {
  void _onFloatingButtonPressed() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Bạn đã tạo sản phẩm"),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          primary: false,
          padding: EdgeInsets.all(defaultPadding),
          child: Column(
            children: [
              Header(title: "Tạo sản phẩm", isButton: true),
              Row(
                children: [
                  LCreateProductScreen(),
                  SizedBox(width: 20),
                  RCreateProductScreen(),
                ],
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _onFloatingButtonPressed,
          tooltip: 'Đăng sản phẩm',
          child: Icon(Icons.check),
          backgroundColor: Colors.blueAccent,
          elevation: 6,
          mini: false,
        ),
      ),
    );
  }
}
