import 'package:flutter/material.dart';

import '../../constants.dart';
import '../dashboard/components/header.dart';
import 'LCreateBannerScreen.dart';
class CreateBannersScreen extends StatefulWidget {
  const CreateBannersScreen({super.key});

  @override
  State<CreateBannersScreen> createState() => _CreateBannersScreenState();
}

class _CreateBannersScreenState extends State<CreateBannersScreen> {
  void _onFloatingButtonPressed() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Bạn đã tạo sự kiện"),
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
              Header(title: "Tạo sự kiện", isButton: true),
              Row(
                children: [
                  LCreateBannerScreen(),
                ],
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _onFloatingButtonPressed,
          tooltip: 'Đăng sự kiện',
          child: Icon(Icons.check),
          backgroundColor: Colors.blueAccent,
          elevation: 6,
          mini: false,
        ),
      ),
    );
  }
}
