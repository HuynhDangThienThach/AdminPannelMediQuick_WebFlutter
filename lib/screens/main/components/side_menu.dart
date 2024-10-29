
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../constants.dart';
import '../../../routes/routes.dart';


final box = GetStorage();
void logout() {
  box.erase();
  Get.offAllNamed(Routes.login);
}
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
            title: "Quản lý doanh mục",
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
          DrawerListTile(
            title: "Profile",
            svgSrc: "assets/icons/menu_profile.svg",
            press: () {},
          ),
          DrawerListTile(
            title: "Logout",
            svgSrc: "assets/icons/menu_setting.svg",
            press: () => logout(),
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.svgSrc,
    required this.press,
  }) : super(key: key);

  final String title, svgSrc;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
        svgSrc,
        colorFilter: ColorFilter.mode(Colors.grey, BlendMode.srcIn),
        height: 16,
      ),
      title: Text(
        title,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
