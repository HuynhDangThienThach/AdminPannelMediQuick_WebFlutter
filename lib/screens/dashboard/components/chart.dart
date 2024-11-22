import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants.dart';
import '../../../controllers/customer_controller.dart';

class Chart extends StatelessWidget {
  const Chart({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CustomerController());

    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          Obx(() => PieChart(
            PieChartData(
              sectionsSpace: 0,
              centerSpaceRadius: 70,
              startDegreeOffset: -90,
              sections: [
                PieChartSectionData(
                  color: Color(0xFFFFEB1F),
                  value: controller.countOrderStatusPending().toDouble(),
                  showTitle: false,
                  radius: 25,
                ),
                PieChartSectionData(
                  color: Color(0xFF267DFF),
                  value: controller.countOrderStatusProcessing().toDouble(),
                  showTitle: false,
                  radius: 22,
                ),
                PieChartSectionData(
                  color: Color(0xFF55FF26),
                  value: controller.countOrderStatusPrepare().toDouble(),
                  showTitle: false,
                  radius: 19,
                ),
                PieChartSectionData(
                  color: Color(0xFFF8915A),
                  value: controller.countOrderStatusShipped().toDouble(),
                  showTitle: false,
                  radius: 16,
                ),
                PieChartSectionData(
                  color: Color(0xFFFAA100),
                  value: controller.countOrderStatusDelivered().toDouble(),
                  showTitle: false,
                  radius: 16,
                ),
                PieChartSectionData(
                  color: Color(0xFFFA0000),
                  value: controller.countOrderStatusCancelled().toDouble(),
                  showTitle: false,
                  radius: 13,
                ),
              ],
            ),
          )),
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: defaultPadding),
                Text(
                  controller.orders.length.toString(),
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    height: 0.5,
                  ),
                ),
                Text("tổng số đơn hàng")
              ],
            ),
          ),
        ],
      ),
    );
  }
}
