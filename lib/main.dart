import 'package:admin/constants.dart';
import 'package:admin/controllers/menu_app_controller.dart';
import 'package:admin/firebase_options.dart';
import 'package:admin/repository/product_repository.dart';
import 'package:admin/routes/app_routes.dart';
import 'package:admin/routes/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_strategy/url_strategy.dart';

import 'controllers/adminController.dart';

Future<void> main() async{
  setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await GetStorage.init();
  Get.put(ProductRepository());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = box.read('isLoggedIn') ?? false;

    AdminController adminController = AdminController();

    String userId = box.read('userId') ?? "default_user_id";


    adminController.fetchAdminData(userId);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MenuAppController(),
        ),
        ChangeNotifierProvider<AdminController>(
          create: (context) => adminController,
        ),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Mediquick Admin Panel',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: primaryColor,
          textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
              .apply(bodyColor: Colors.white),
          canvasColor: secondaryColor,
        ),
        defaultTransition: Transition.fade,
        enableLog: true,
        getPages: AppRoutes.pages,
        initialRoute: isLoggedIn ? Routes.mainScreen : Routes.login,
        unknownRoute: GetPage(
          name: '/page-not-found',
          page: () => Scaffold(body: Center(child: Text("Không tìm thấy trang"))),
        ),
      ),
    );
  }
}
