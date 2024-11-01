import 'package:admin/routes/routeMiddleware.dart';
import 'package:admin/routes/routes.dart';
import 'package:admin/screens/auth/login_screen.dart';
import 'package:admin/screens/category/CategoryScreen.dart';
import 'package:admin/screens/dashboard/dashboard_screen.dart';
import 'package:admin/screens/main/main_screen.dart';
import 'package:admin/screens/profile/profileScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../controllers/menu_app_controller.dart';
import '../screens/banners/BannersScreen.dart';
import '../screens/banners/CreateBannersScreen.dart';
import '../screens/banners/EditBannersScreen.dart';
import '../screens/brands/BrandsScreen.dart';
import '../screens/brands/CreateBrandsScreen.dart';
import '../screens/brands/EditBrandsScreen.dart';
import '../screens/category/CreateCategoryScreen.dart';
import '../screens/category/EditCategoryScreen.dart';
import '../screens/customers/CreateCustomerScreen.dart';
import '../screens/customers/CustomerDetailsScreen.dart';
import '../screens/customers/CustomerScreen.dart';
import '../screens/orders/CreateOrdersScreen.dart';
import '../screens/orders/EditOrdersScreen.dart';
import '../screens/orders/OrdersScreen.dart';
import '../screens/products/CreateProductsScreen.dart';
import '../screens/products/EditProductsScreen.dart';
import '../screens/products/ProductsScreen.dart';

class AppRoutes {
  static final List<GetPage> pages = [
    GetPage(
      name: Routes.login,
      page: () => LoginScreen(),
    ),
    GetPage(
      name: Routes.dashboard,
      page: () => ChangeNotifierProvider(
        create: (_) => MenuAppController(),
        child: MainScreen(
          screen: DashboardScreen(),
          scaffoldKey: GlobalKey<ScaffoldState>(),
        ),
      ),
    ),
    GetPage(
      name: Routes.mainScreen,
      page: () => MainScreen(
        screen: DashboardScreen(),
        scaffoldKey: GlobalKey<ScaffoldState>(),
      ),
      middlewares: [RouteMiddleware()],
    ),
    GetPage(
      name: Routes.products,
      page: () => MainScreen(
        screen: ProductsScreen(),
        scaffoldKey: GlobalKey<ScaffoldState>(),
      ),
      middlewares: [RouteMiddleware()],
    ),
    GetPage(
      name: Routes.createProducts,
      page: () => MainScreen(
        screen:  CreateProductsScreen(),
        scaffoldKey: GlobalKey<ScaffoldState>(),
      ),

      middlewares: [RouteMiddleware()],
    ),
    GetPage(
      name: Routes.editProducts,
      page: () => MainScreen(
        screen: EditProductsScreen(),
        scaffoldKey: GlobalKey<ScaffoldState>(),
      ),
      middlewares: [RouteMiddleware()],
    ),
    GetPage(
      name: Routes.banners,
      page: () => MainScreen(
        screen: BannersScreen(),
        scaffoldKey: GlobalKey<ScaffoldState>(),
      ),
      middlewares: [RouteMiddleware()],
    ),
    GetPage(
      name: Routes.createBanners,
      page: () => MainScreen(
        screen: CreateBannersScreen(),
        scaffoldKey: GlobalKey<ScaffoldState>(),
      ),
      middlewares: [RouteMiddleware()],
    ),
    GetPage(
      name: Routes.editBanners,
      page: () => MainScreen(
        screen: EditBannersScreen(),
        scaffoldKey: GlobalKey<ScaffoldState>(),
      ),
      middlewares: [RouteMiddleware()],
    ),
    GetPage(
      name: Routes.brands,
      page: () => MainScreen(
        screen: BrandsScreen(),
        scaffoldKey: GlobalKey<ScaffoldState>(),
      ),
      middlewares: [RouteMiddleware()],
    ),
    GetPage(
      name: Routes.createBrands,
      page: () => MainScreen(
        screen: CreateBrandsScreen(),
        scaffoldKey: GlobalKey<ScaffoldState>(),
      ),
      middlewares: [RouteMiddleware()],
    ),
    GetPage(
      name: Routes.editBrands,
      page: () => MainScreen(
        screen: EditBrandsScreen(),
        scaffoldKey: GlobalKey<ScaffoldState>(),
      ),
      middlewares: [RouteMiddleware()],
    ),
    GetPage(
      name: Routes.customer,
      page: () => MainScreen(
        screen: CustomerScreen(),
        scaffoldKey: GlobalKey<ScaffoldState>(),
      ),
      middlewares: [RouteMiddleware()],
    ),
    GetPage(
      name: Routes.createCustomer,
      page: () => MainScreen(
        screen: CreateCustomerScreen(),
        scaffoldKey: GlobalKey<ScaffoldState>(),
      ),
      middlewares: [RouteMiddleware()],
    ),
    GetPage(
      name: Routes.CustomerDetails,
      page: () => MainScreen(
        screen: CustomerDetailsScreen(),
        scaffoldKey: GlobalKey<ScaffoldState>(),
      ),
      middlewares: [RouteMiddleware()],
    ),
    GetPage(
      name: Routes.orders,
      page: () => MainScreen(
        screen: OrdersScreen(),
        scaffoldKey: GlobalKey<ScaffoldState>(),
      ),
      middlewares: [RouteMiddleware()],
    ),
    GetPage(
      name: Routes.createOrders,
      page: () => MainScreen(
        screen: CreateOrdersScreen(),
        scaffoldKey: GlobalKey<ScaffoldState>(),
      ),
      middlewares: [RouteMiddleware()],
    ),
    GetPage(
      name: Routes.editOrders,
      page: () => MainScreen(
        screen: EditOrdersScreen(),
        scaffoldKey: GlobalKey<ScaffoldState>(),
      ),
      middlewares: [RouteMiddleware()],
    ),

    GetPage(
      name: Routes.category,
      page: () => MainScreen(
        screen: CategoryScreen(),
        scaffoldKey: GlobalKey<ScaffoldState>(),
      ),
      middlewares: [RouteMiddleware()],
    ),
    GetPage(
      name: Routes.createCategory,
      page: () => MainScreen(
        screen: CreateCategoryScreen(),
        scaffoldKey: GlobalKey<ScaffoldState>(),
      ),
      middlewares: [RouteMiddleware()],
    ),
    GetPage(
      name: Routes.editCategory,
      page: () => MainScreen(
        screen: EditCategoryScreen(),
        scaffoldKey: GlobalKey<ScaffoldState>(),
      ),
      middlewares: [RouteMiddleware()],
    ),
    GetPage(
      name: Routes.profile,
      page: () => MainScreen(
        screen: ProfileScreen(userId: '',),
        scaffoldKey: GlobalKey<ScaffoldState>(),
      ),
      middlewares: [RouteMiddleware()],
    ),
  ];
}
