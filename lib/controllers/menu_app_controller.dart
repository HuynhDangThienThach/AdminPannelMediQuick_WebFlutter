import 'package:flutter/material.dart';

class MenuAppController extends ChangeNotifier {
  GlobalKey<ScaffoldState>? _scaffoldKey;

  GlobalKey<ScaffoldState>? get scaffoldKey => _scaffoldKey;
  set scaffoldKey(GlobalKey<ScaffoldState>? key) => _scaffoldKey = key;

  void controlMenu() {
    if (_scaffoldKey?.currentState?.isDrawerOpen == false) {
      _scaffoldKey?.currentState?.openDrawer();
    }
  }
}

