import 'package:admin/models/order_model.dart';
import 'package:admin/repository/customer_repository.dart';
import 'package:admin/utils/validators/enums.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class LOrdersDetailsScreen extends StatelessWidget {
  final OrderModel? order;

  const LOrdersDetailsScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildSection(
                  title: "Thông tin đơn hàng",
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildRow("Ngày", order!.formattedOrderDate),
                      Spacer(),
                      _buildRow("Các sản phẩm", "${order!.items.length} sản phẩm"),
                      Spacer(),
                      _buildRow("Trạng thái", _buildStatusDropdown(order!.status)),
                      Spacer(),
                      _buildRow("Tổng", "${NumberFormat('#,##0').format(order!.totalAmount)}đ"),
                      SizedBox(width: 20,),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _buildSection(
                  title: "Các sản phẩm",
                  child: Column(
                    children: [
                      Column(
                        children: order!.items.map((item) {
                          double subtotal = item.price * item.quantity;
                          double tax = subtotal / 100;
                          return Column(
                            children: [
                              ListTile(
                                leading: Image.network(
                                  item.image,
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    }
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress.expectedTotalBytes != null
                                            ? loadingProgress.cumulativeBytesLoaded /
                                            (loadingProgress.expectedTotalBytes ?? 1)
                                            : null,
                                      ),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return SizedBox.shrink();
                                  },
                                ),
                                title: Text(item.title),
                                trailing: Text("${NumberFormat('#,##0').format(item.price)} x ${item.quantity} đ"),
                              ),
                              const Divider(),
                              _buildRow1("Giá", "${NumberFormat('#,##0').format(subtotal)} đ"),
                              _buildRow1("Giảm giá", "0.00 đ"),
                              _buildRow1("Phí vận chuyển", "10,000 đ"),
                              _buildRow1("Thuế", "${NumberFormat('#,##0').format(tax)} đ"),
                              const Divider(),
                            ],
                          );
                        }).toList(),
                      ),
                      _buildRow1("Tổng cộng", "${NumberFormat('#,##0').format(order!.totalAmount)} đ")
                    ],
                  ),
                ),

              ],
            ),
          ),
          SizedBox(width: 40,),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                _buildSection(
                  title: "Khách hàng",
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: const CircleAvatar(
                          backgroundImage: AssetImage('assets/images/profile_doctor.png'),
                        ),
                        title: Text(order!.address!.name),
                        subtitle: Text(order!.address!.id),
                      ),
                      _buildRow1("Số điện thoại", order!.address?.phoneNumber ?? 'Không có số điện thoại'),
                      _buildRow1("Địa chỉ giao hàng", order!.address?.toString() ?? 'Không có địa chỉ'),
                      _buildRow1("Ngày giao hàng", order!.formattedDeliveryDate),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
                _buildSection(
                  title: "Hình thức thanh toán",
                  child: ListTile(
                    leading: Icon(
                      order!.paymentMethod == 'Paypal' ? Icons.paypal : Icons.credit_card,
                      color: Colors.blue,
                      size: 40,
                    ),
                    title: Text("Payment via ${order!.paymentMethod}"),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Ngày thanh toán: ${order!.formattedOrderDate}"),
                        Text("Tổng: ${NumberFormat('#,##0').format(order!.totalAmount)}đ"),
                      ],
                    ),
                  ),
                ),

              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String key, dynamic value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(key),
          SizedBox(height: 20,),
          value is Widget
              ? value
              : Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow1(String key, dynamic value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(key),
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerRight,  // Căn chỉnh value sang bên phải
              child: Text(
                value,
                style: TextStyle(
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 5,
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildStatusDropdown(OrderStatus currentStatus) {
    final controller = Get.put(CustomerRepository());
    return DropdownButton<OrderStatus>(
      value: currentStatus,
      items: OrderStatus.values.map((status) {
        return DropdownMenuItem(
          value: status,
          child: Text(
            status == OrderStatus.pending
                ? "Đang chờ xử lý"
                : status == OrderStatus.processing
                ? "Đang xử lý"
                : status == OrderStatus.prepare
                ? "Đang chuẩn bị hàng"
                : status == OrderStatus.shipped
                ? "Đang giao hàng"
                : status == OrderStatus.delivered
                ? "Đã giao hàng"
                : status == OrderStatus.cancel
                ? "Hủy đơn hàng"
                : '',
          ),
        );
      }).toList(),
        onChanged: (newStatus) async {
          if (newStatus != null) {
            try {
              // Lấy documentId của đơn hàng từ Firestore
              final documentId = await controller.getOrderDocumentIdByOrderId(
                userId: order!.userId,
                orderId: order!.id,
              );

              if (documentId == null) {
                Get.snackbar("Lỗi", "Không tìm thấy đơn hàng",
                    snackPosition: SnackPosition.BOTTOM);
                return;
              }

              // Cập nhật trạng thái trên Firebase
              await controller.updateOrderStatus(
                userId: order!.userId,
                orderId: documentId,
                newStatus: newStatus,
              );

              // Cập nhật giao diện
              order!.status = newStatus;
              Get.snackbar("Thành công", "Đã cập nhật trạng thái đơn hàng",
                  snackPosition: SnackPosition.BOTTOM);
            } catch (e) {
              Get.snackbar("Lỗi", "Không thể cập nhật trạng thái: $e",
                  snackPosition: SnackPosition.BOTTOM);
            }
          }
        }

    );
  }

}

