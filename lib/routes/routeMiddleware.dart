
import 'package:admin/routes/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class RouteMiddleware extends GetMiddleware{

  @override
  RouteSettings? redirect(String? route) {
    print("-----------MiddleWare Called----------------");
    final authenticated = true;
    return authenticated ? null : RouteSettings(name: Routes.login);
  }
}