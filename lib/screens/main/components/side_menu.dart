import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants.dart';
import '../../../routes/routes.dart';
import 'drawerListTitle.dart';
class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: secondaryColor,
      child: ListView(
        children: [
          DrawerHeader(
            child: Image.asset("icons/t-store-splash-logo-black1.png"),
          ),
          DrawerListTile(
            title: "Thống kê",
            svgSrc: "assets/icons/menu_dashboard.svg",
            press: () => Get.toNamed(Routes.mainScreen),
          ),
          DrawerListTile(
            title: "Quản lý sản phẩm",
            svgSrc: "assets/icons/menu_store.svg",
            press: () => Get.toNamed(Routes.products),
          ),
          DrawerListTile(
            title: "Quản lý sự kiện",
            svgSrc: "assets/icons/menu_task.svg",
            press: () => Get.toNamed(Routes.banners),
          ),
          DrawerListTile(
            title: "Quản lý danh mục",
            svgSrc: "assets/icons/menu_dashboard.svg",
            press: () => Get.toNamed(Routes.category),
          ),
          DrawerListTile(
            title: "Quản lý thương hiệu",
            svgSrc: "assets/icons/menu_doc.svg",
            press: () => Get.toNamed(Routes.brands),
          ),
          DrawerListTile(
            title: "Quản lý khách hàng",
            svgSrc: "assets/icons/menu_profile.svg",
            press: () => Get.toNamed(Routes.customer),
          ),
          DrawerListTile(
            title: "Quản lý đơn hàng",
            svgSrc: "assets/icons/menu_tran.svg",
            press: () => Get.toNamed(Routes.orders),
          ),
        ],
      ),
    );
  }
}


