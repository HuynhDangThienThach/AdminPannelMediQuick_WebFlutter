import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import '../../../controllers/customer_controller.dart';
import '../../../models/AddressModel.dart';
import '../../../models/order_model.dart';
import '../../../routes/routes.dart';
import '../../../utils/validators/enums.dart';
import '../../search/SearchScreen.dart';

class LCustomerDetailsScreen extends StatefulWidget {
  final String customerId;
  const LCustomerDetailsScreen({Key? key, required this.customerId}) : super(key: key);

  @override
  State<LCustomerDetailsScreen> createState() => _LCustomerDetailsScreenState();
}

class _LCustomerDetailsScreenState extends State<LCustomerDetailsScreen> {
  final controller = Get.put(CustomerController());
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  @override
  void initState() {
    super.initState();
    loadCustomerData();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  Future<void> loadCustomerData() async {
    await controller.fetchCustomerById(widget.customerId);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }

      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Column: Customer Information
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Customer Information Card
                _buildCustomerInfoCard(),
                const SizedBox(height: 16),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Right Column: Orders Table
          Expanded(
            flex: 2,
            child: Obx(() {
              if (controller.orders.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 200,
                        width: 200,
                        child: Lottie.asset(
                          'assets/images/bounching_ball.json',
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Không có đơn hàng nào.",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ],
                  ),
                );
              }
              return _buildOrdersTable(controller.orders);
            }),
          ),
        ],
      );
    });
  }


  // Widget for Customer Info Card
  Widget _buildCustomerInfoCard() {
    return Card(
      elevation: 4,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: const Text(
                "Thông tin khách hàng",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ),
            Divider(thickness: 1,),
            const SizedBox(height: 16.0),
            Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return Row(
                children: [
                  Obx(() => CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(controller.imageUrl.value),
                  )),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(
                            () => Text(
                          controller.fullName.value,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Obx(
                            () => Text(
                          controller.email.value,
                          style: TextStyle(color: Colors.black54),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }),
            const SizedBox(height: 8),
            Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (controller.addresses.isEmpty) {
                return const Text(
                  "Không có địa chỉ nào được lưu.",
                  style: TextStyle(color: Colors.black54),
                );
              }

              return Column(
                children: controller.addresses.map((address) => _buildAddressInfo(address)).toList(),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressInfo(AddressModel address) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow("Tên người dùng", address.name),
        const SizedBox(height: 8),
        _buildInfoRow("Thành phố", address.toString()),
        const SizedBox(height: 16),
        _buildInfoRow("Số điện thoại", address.formattedPhoneNo),
        const SizedBox(height: 16),
        _buildInfoRow("Ngày tạo tài khoản", address.dateTime?.toString() ?? "Không rõ"),
        const SizedBox(height: 16),
        _buildInfoRow("Đơn hàng cuối cùng", "7 Days Ago, #13d541"),
        const SizedBox(height: 16),
        _buildInfoRow("Đơn hàng trung bình", "352.000đ"),
        const SizedBox(height: 16),
        _buildInfoRow("Đăng ký qua email", "Đã đăng ký"),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: Text(
            "$label:",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.black54,
            ),
          ),
        ),
      ],
    );
  }

  // Widget for Orders Table
  Widget _buildOrdersTable(List<OrderModel>? orders) {
    if (orders == null || orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              "Không có đơn hàng nào.",
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ],
        ),
      );
    }

    // Lọc danh sách đơn hàng dựa trên từ khóa tìm kiếm
    final filteredOrders = orders.where((order) {
      return order.id.toString().contains(_searchQuery);
    }).toList();

    return Card(
      elevation: 4,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Text(
                  "Đơn hàng của bạn",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Spacer(),
                Text(
                  "Tổng số tiền: ${filteredOrders.fold(0, (sum, order) => sum + order.totalAmount.toInt())} đồng trên ${filteredOrders.length} đơn hàng",
                  style: TextStyle(
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Search Field
            SearchField(
              controller: _searchController,
              color: Colors.white,
              colorHintText: Colors.black,
              textColor: Colors.black,
              borderSide: Colors.grey,
            ),
            const SizedBox(height: 16),
            // Orders Table
            SingleChildScrollView(
              child: DataTable(
                showCheckboxColumn: false,
                columnSpacing: 16,
                columns: const [
                  DataColumn(
                    label: Text(
                      "Order ID",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "Date",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "Items",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "Status",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "Amount",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
                rows: filteredOrders.map((order) {
                  return DataRow(
                    onSelectChanged: (selected) {
                      if (selected ?? false) {
                        Get.toNamed(Routes.detailsOrders, arguments: order);
                      }
                    },
                    cells: [
                      DataCell(
                        Text(
                          "${order.id}",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      DataCell(
                        Text(
                          order.formattedOrderDate,
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      DataCell(
                        Text(
                          "${order.items.length} Items",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      DataCell(
                        Chip(
                          label: Text(
                            order.orderStatusText,
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: order.orderStatusColor
                        ),
                      ),
                      DataCell(
                        Text(
                          '${NumberFormat('#,##0').format(order.totalAmount)}đ',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }



}
