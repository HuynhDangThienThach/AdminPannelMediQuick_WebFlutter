import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../controllers/customer_controller.dart';
import 'chart.dart';
import 'storage_info_card.dart';

import 'package:get/get.dart'; // Để sử dụng GetX

class StorageDetails extends StatelessWidget {
  const StorageDetails({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CustomerController());

    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Trạng thái đơn hàng",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: defaultPadding),
          Chart(),
          StorageInfoCard(
            svgSrc: "assets/icons/pending.svg",
            title: "Đang chờ xử lý",
            amountOfFiles:
            controller.calculateOrderStatusPending().toInt(),
            numOfFiles: controller.countOrderStatusPending(),
          ),
          StorageInfoCard(
            svgSrc: "assets/icons/processing.svg",
            title: "Đang xử lý",
            amountOfFiles:
            controller.calculateOrderStatusProcessing().toInt(),
            numOfFiles: controller.countOrderStatusProcessing(),
          ),
          StorageInfoCard(
            svgSrc: "assets/icons/prepare.svg",
            title: "Đang chuẩn bị hàng",
            amountOfFiles:
            controller.calculateOrderStatusPrepare().toInt(),
            numOfFiles: controller.countOrderStatusPrepare(),
          ),
          StorageInfoCard(
            svgSrc: "assets/icons/shipped.svg",
            title: "Đang giao hàng",
            amountOfFiles:
            controller.calculateOrderStatusShipped().toInt(),
            numOfFiles: controller.countOrderStatusShipped(),
          ),
          StorageInfoCard(
            svgSrc: "assets/icons/delivered.svg",
            title: "Đã giao hàng",
            amountOfFiles:
            controller.calculateOrderStatusDelivered().toInt(),
            numOfFiles: controller.countOrderStatusDelivered(),
          ),
          StorageInfoCard(
            svgSrc: "assets/icons/cancel.svg",
            title: "Hủy đơn hàng",
            amountOfFiles:
            controller.calculateOrderStatusCancelled().toInt(),
            numOfFiles: controller.countOrderStatusCancelled(),
          ),
        ],
      ),
    );
  }
}


