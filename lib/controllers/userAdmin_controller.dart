import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/userAdmin_model.dart';
import '../repository/user_admin_repository.dart';
import '../routes/routes.dart';

class UserAdminController extends GetxController {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final box = GetStorage();
  final UserAdminRepository _userAdminRepository = UserAdminRepository();
  var obscureText = true.obs;

  GlobalKey<FormState> get formKey => _formKey;
  TextEditingController get emailController => _emailController;
  TextEditingController get passwordController => _passwordController;

  void togglePasswordVisibility() {
    obscureText.value = !obscureText.value;
  }

  Future<void> login() async {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();

      try {
        UserAdmin? user = await _userAdminRepository.login(email, password);

        if (user != null) {
          box.write('isLoggedIn', true);
          box.write('userId', user.id);
          box.write('Email', user.email);
          Get.offNamed(Routes.mainScreen);
        } else {
          Get.snackbar("Lỗi đăng nhập", "Email hoặc mật khẩu không đúng",backgroundColor: Colors.red,
              snackPosition: SnackPosition.BOTTOM);
        }
      } catch (e) {
        Get.snackbar("Lỗi", e.toString(), snackPosition: SnackPosition.BOTTOM);
      }
    }
  }

  @override
  void onClose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.onClose();
  }
}
