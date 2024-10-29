import 'package:flutter/material.dart';

import '../../../constants.dart';
import 'chart.dart';
import 'storage_info_card.dart';

class StorageDetails extends StatelessWidget {
  const StorageDetails({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            svgSrc: "assets/icons/Documents.svg",
            title: "Chuẩn bị hàng",
            amountOfFiles: "999.999 đồng",
            numOfFiles: 25,
          ),
          StorageInfoCard(
            svgSrc: "assets/icons/media.svg",
            title: "Đang xử lý",
            amountOfFiles: "888.888 đồng",
            numOfFiles: 20,
          ),
          StorageInfoCard(
            svgSrc: "assets/icons/media_file.svg",
            title: "Đang giao hàng",
            amountOfFiles: "777.777 đồng",
            numOfFiles: 40,
          ),
          StorageInfoCard(
            svgSrc: "assets/icons/folder.svg",
            title: "Đã giao hàng",
            amountOfFiles: "666.666 đồng",
            numOfFiles: 50,
          ),
          StorageInfoCard(
            svgSrc: "assets/icons/unknown.svg",
            title: "Hủy đơn hàng",
            amountOfFiles: "555.555 đồng",
            numOfFiles: 10,
          ),
        ],
      ),
    );
  }
}
