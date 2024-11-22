import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../constants.dart';
class SearchField extends StatelessWidget {
  final TextEditingController controller;
  final Color? color, colorHintText, textColor, borderSide;
  const SearchField({
    Key? key,
    required this.controller, this.color = secondaryColor, this.colorHintText, this.textColor, this.borderSide = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: TextStyle(color: textColor),
      decoration: InputDecoration(
        hintText: "Tìm kiếm",
        hintStyle: TextStyle(color: colorHintText),
        fillColor: color,
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderSide ?? Colors.white, width: 2), // Nếu null thì sử dụng màu đen
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),

        suffixIcon: InkWell(
          onTap: () {

          },
          child: Container(
            padding: EdgeInsets.all(defaultPadding * 0.75),
            margin: EdgeInsets.symmetric(horizontal: defaultPadding / 2),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: SvgPicture.asset("assets/icons/Search.svg"),
          ),
        ),
      ),
    );
  }
}
