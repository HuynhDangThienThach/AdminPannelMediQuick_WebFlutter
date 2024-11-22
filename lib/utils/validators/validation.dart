
import 'dart:math';

import 'package:admin/models/brand_model.dart';

class TValidator {
  // Empty Text Validation
  static String? validateEmptyText(String? fieldName, String? value){
    if(value == null || value.isEmpty){
      return  '$fieldName không để trống.';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email không để trống.';
    }

    // Regular expression for email validation
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegExp.hasMatch(value)) {
      return 'Địa chỉ email không hợp lệ.';
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mật khẩu không để trống.';
    }

    // Check for minimum password length
    if (value.length < 6) {
      return 'Mật khẩu phải dài ít nhất 6 ký tự';
    }

    // Check for uppercase letters
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Mật khẩu phải chứa ít nhất một chữ viết hoa';
    }

    // Check for numbers
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Mật khẩu phải chứa ít nhất một chữ số.';
    }

    // Check for special characters
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Mật khẩu phải chứa ít nhất một ký tự đặc biệt.';
    }

    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Số điện thoại không để trống.';
    }

    // Regular expression for phone number validation (assuming a 10-digit US phone number format)
    final phoneRegExp = RegExp(r'^\d{10}$');



    if (!phoneRegExp.hasMatch(value)) {
      return 'Định dạng số điện thoại không hợp lệ (yêu cầu 10 chữ số).';
    }

    return null;
  }

  static String generateRandomSku(int length) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random random = Random();
    return List.generate(length, (index) => chars[random.nextInt(chars.length)]).join();
  }

  static String? validateProductName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Tên sản phẩm không để trống.';
    }
    return null;
  }

  static String? validateBrands(String? value) {
    if (value == null || value.isEmpty) {
      return 'Tên thương hiệu không để trống.';
    }
    return null;
  }

  static String? validateProductAttributeName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Tên thuộc tính không để trống.';
    }
    return null;
  }
  static String? validateProductAttribute(String? value) {
    if (value == null || value.isEmpty) {
      return 'Thuộc tính không để trống.';
    }
    return null;
  }
  static String? validateBrand(BrandModel? value) {
    if (value == null) {
      return 'Vui lòng chọn thương hiệu';
    }
    return null;
  }
  static String? validateProductType(String? value) {
    if (value == null) {
      return 'Vui lòng chọn loại sản phẩm';
    }
    return null;
  }

  static String? validateProductDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mô tả sản phẩm không để trống.';
    }
    return null;
  }

  static String? validateBannerRedirect(String? value) {
    if (value == null || value.isEmpty) {
      return 'Địa chỉ chuyển tiếp không để trống.';
    }
    return null;
  }
  static String? validateProductStock(String? value) {
    if (value == null || value.isEmpty) {
      return 'Số lượng không để trống.';
    }
    final parsedValue = int.tryParse(value);
    if (parsedValue == null) {
      return 'Số lượng chỉ chứa các chữ số.';
    }
    if (parsedValue < 0) {
      return 'Số lượng phải là số dương.';
    }
    return null;
  }

  static String? validateProductPrice(String? value) {
    if (value == null || value.isEmpty) {
      return 'Giá bán không để trống.';
    }
    final parsedValue = int.tryParse(value);
    if (parsedValue == null) {
      return 'Giá bán chỉ chứa các chữ số.';
    }
    if (parsedValue < 0) {
      return 'Giá bán phải là số dương.';
    }
    return null;
  }

  static String? validateProductSalePrice(String? value) {
    if (value == null || value.isEmpty) {
      return 'Giảm giá không để trống.';
    }
    final parsedValue = int.tryParse(value);
    if (parsedValue == null) {
      return 'Giảm giá chỉ chứa các chữ số.';
    }
    if (parsedValue < 0) {
      return 'Giảm giá phải là số dương.';
    }
    return null;
  }

  static String? validateLinkImageProduct(String? value) {
    if (value == null || value.isEmpty) {
      return 'Đường link ảnh không để trống.';
    }

    final regex = RegExp(r'^(http(s?):)([/|.|\w|\s|-])*\.(?:jpg|jpeg|png|gif|bmp|webp)$');

    if (!regex.hasMatch(value)) {
      return 'Vui lòng nhập một đường link ảnh hợp lệ (định dạng .jpg, .jpeg, .png, .gif, .bmp, hoặc .webp).';
    }

    return null;
  }





}
