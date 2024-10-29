import 'package:admin/models/order.dart';
import 'package:admin/responsive.dart';
import 'package:admin/screens/dashboard/components/my_fields.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import 'components/header.dart';

import 'components/recent_files.dart';
import 'components/storage_details.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Order> order = [
      Order(
          id: "1",
          date: "2024-01-01",
          items: "1",
          status: "Chuẩn bị hàng",
          amount: "120.000đ"),
      Order(
          id: "2",
          date: "2024-01-01",
          items: "2",
          status: "Đang xử lý",
          amount: "120.000đ"),
      Order(
          id: "3",
          date: "2024-01-01",
          items: "3",
          status: "Đang giao hàng",
          amount: "120.000đ"),
      Order(
          id: "4",
          date: "2024-01-01",
          items: "3",
          status: "Đã giao hàng",
          amount: "120.000đ"),
      Order(
          id: "5",
          date: "2024-01-01",
          items: "3",
          status: "Hủy đơn hàng",
          amount: "120.000đ"),
    ];
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header(
              title: "Thống kê",
            ),
            SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      MyFiles(),
                      SizedBox(height: defaultPadding),
                      RecentFiles(
                        title: "Danh sách đơn hàng",
                        data: order.map((order) {
                          return {
                            'id': order.id,
                            'date': order.date,
                            'items': order.items,
                            'status': order.status,
                            'amount': order.amount,
                          };
                        }).toList(),
                        columns: ['id', 'date', 'items', 'status', 'amount'],
                        isButton: false,
                      ),
                      if (Responsive.isMobile(context))
                        SizedBox(height: defaultPadding),
                      if (Responsive.isMobile(context)) StorageDetails(),
                    ],
                  ),
                ),
                if (!Responsive.isMobile(context))
                  SizedBox(width: defaultPadding),
                // On Mobile means if the screen is less than 850 we don't want to show it
                if (!Responsive.isMobile(context))
                  Expanded(
                    flex: 2,
                    child: StorageDetails(),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
