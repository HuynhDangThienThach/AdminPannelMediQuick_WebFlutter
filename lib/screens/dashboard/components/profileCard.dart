import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../controllers/adminController.dart';
import '../../../responsive.dart';
import '../../../routes/routes.dart';
class ProfileCard extends StatelessWidget {
  ProfileCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final adminController = Provider.of<AdminController>(context);


    if (adminController.admin == null) {
      return Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(left: defaultPadding),
          padding: EdgeInsets.symmetric(
            horizontal: defaultPadding,
            vertical: defaultPadding / 2,
          ),
          decoration: BoxDecoration(
            color: secondaryColor,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(color: Colors.white10),
          ),
          child: Row(
            children: [
              Image.network(
                  adminController.admin!.image,
                  height: 38,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset("assets/images/profile_doctor.png", height: 38);
                  }

              ),
              if (!Responsive.isMobile(context))
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
                  child: Text(adminController.admin!.displayName),
                ),
              PopupMenuButton(
                icon: Icon(Icons.keyboard_arrow_down),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'profile',
                    child: ListTile(
                      leading: Icon(Icons.person),
                      title: Text('Profile'),
                    ),
                  ),
                  PopupMenuItem(
                    value: 'logout',
                    child: ListTile(
                      leading: Icon(Icons.logout),
                      title: Text('Logout'),
                    ),
                  ),
                ],
                onSelected: (value) {
                  if (value == 'profile') {
                    Get.offAllNamed(Routes.profile);
                  } else if (value == 'logout') {
                    logout();
                  }
                },
              ),
            ],
          ),
        ),
        SizedBox(height: 20,)
      ],
    );
  }
  final box = GetStorage();
  void logout() {
    box.erase();
    Get.offAllNamed(Routes.login);
  }
}