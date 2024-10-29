//
// import 'package:admin/routes/routes.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:get/get.dart';
//
// class RouteObservers extends GetObserver {
//   /// Lui
//   @override
//   void didPop(Route<dynamic>? route, Route<dynamic>? previousRoute) {
//     final sidebarController = Get.put(SidebarController());
//     if (previousRoute != null) {
//       // Check the route name and update the active item in the sidebar accordingly
//       for (var routeName in Routes.sideMenuItems) {
//         if (previousRoute.settings.name == routeName) {
//           sidebarController.activeItem.value = routeName;
//         }
//       }
//     }
//   }
//
//   // Tien
//   @override
//   void didPush(Route<dynamic>? route, Route<dynamic>? previousRoute) {
//     final sidebarController = Get.put(SidebarController());
//     if (route != null) {
//       // Check the route name and update the active item in the sidebar accordingly
//       for (var routeName in Routes.sideMenuItems) {
//         if (route.settings.name == routeName) {
//           sidebarController.activeItem.value = routeName;
//         }
//       }
//     }
//   }
// }