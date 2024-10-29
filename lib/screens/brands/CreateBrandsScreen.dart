import 'package:flutter/material.dart';

import '../../constants.dart';
import '../dashboard/components/header.dart';
import 'LCreateBrandsScreen.dart';
class CreateBrandsScreen extends StatefulWidget {
  const CreateBrandsScreen({super.key});

  @override
  State<CreateBrandsScreen> createState() => _CreateBrandsScreenState();
}

class _CreateBrandsScreenState extends State<CreateBrandsScreen> {
  void _onFloatingButtonPressed() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Bạn đã tạo thương hiệu"),
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
              Header(title: "Tạo thương hiệu", isButton: true),
              Row(
                children: [
                  LCreateBrandsScreen(),
                ],
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _onFloatingButtonPressed,
          tooltip: 'Đăng thương hiệu',
          child: Icon(Icons.check),
          backgroundColor: Colors.blueAccent,
          elevation: 6,
          mini: false,
        ),
      ),
    );
  }
}
