import 'package:admin/constants.dart';
import 'package:flutter/material.dart';

class CloudStorageInfo {
  final String? svgSrc, title, totalStorage;
  final int? numOfFiles, percentage;
  final Color? color;

  CloudStorageInfo({
    this.svgSrc,
    this.title,
    this.totalStorage,
    this.numOfFiles,
    this.percentage,
    this.color,
  });
}

List demoMyFiles = [
  CloudStorageInfo(
    title: "Doanh số bán hàng",
    numOfFiles: 345000000,
    svgSrc: "assets/icons/Documents.svg",
    totalStorage: "tăng 35%",
    color: bgColor,
    percentage: 35,
  ),
  CloudStorageInfo(
    title: "Đơn hàng trung bình",
    numOfFiles: 120000,
    svgSrc: "assets/icons/folder.svg",
    totalStorage: "giảm 13%",
    color: Color(0xFFFFA113),
    percentage: 28,
  ),
  CloudStorageInfo(
    title: "Tổng đơn hàng",
    numOfFiles: 1328,
    svgSrc: "assets/icons/drop_box.svg",
    totalStorage: "tăng 55%",
    color: Color(0xFFA4CDFF),
    percentage: 44,
  ),
  CloudStorageInfo(
    title: "Người dùng truy cập",
    numOfFiles: 129,
    svgSrc: "assets/icons/menu_profile.svg",
    totalStorage: "tăng 78%",
    color: Color(0xFF007EE5),
    percentage: 78,
  ),
];
