import 'package:flutter/material.dart';

import '../../constants.dart';
import '../brands/LCreateBrandsScreen.dart';
import '../dashboard/components/header.dart';
import 'LCreateCategoryScreen.dart';
class CreateCategoryScreen extends StatefulWidget {
  const CreateCategoryScreen({super.key});

  @override
  State<CreateCategoryScreen> createState() => _CreateCategoryScreenState();
}

class _CreateCategoryScreenState extends State<CreateCategoryScreen> {
  void _onFloatingButtonPressed() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Bạn đã tạo doanh mục"),
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
              Header(title: "Tạo doanh mục", isButton: true),
              Row(
                children: [
                  LCreateCategoryScreen(),
                ],
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _onFloatingButtonPressed,
          tooltip: 'Đăng doanh mục',
          child: Icon(Icons.check),
          backgroundColor: Colors.blueAccent,
          elevation: 6,
          mini: false,
        ),
      ),
    );
  }
}
