import 'package:admin/controllers/menu_app_controller.dart';
import 'package:admin/responsive.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'components/side_menu.dart';

class MainScreen extends StatelessWidget {
  final Widget screen;
  final GlobalKey<ScaffoldState> scaffoldKey;
  const MainScreen({
    Key? key,
    required this.screen, required this.scaffoldKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final menuController = Provider.of<MenuAppController>(context);
    menuController.scaffoldKey = scaffoldKey;

    return Scaffold(
      key: scaffoldKey,
      drawer: SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Responsive.isDesktop(context))
              Expanded(
                child: SideMenu(),
              ),
            Expanded(
              flex: 5,
              child: screen,
            ),
          ],
        ),
      ),
    );
  }
}




