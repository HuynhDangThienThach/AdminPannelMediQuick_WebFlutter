import 'dart:ui';

import 'package:admin/models/UserModel.dart';
import 'package:admin/models/order_model.dart';
import 'package:admin/repository/customer_repository.dart';
import 'package:get/get.dart';
import '../constants.dart';
import '../models/AddressModel.dart';
import '../models/my_files.dart';
import '../utils/validators/enums.dart';
import '../utils/validators/loaders.dart';

class CustomerController extends GetxController {
  static CustomerController get instance => Get.find();
  final customerRepository = Get.put(CustomerRepository());
  final RxList<UserModel> customers = <UserModel>[].obs;
  RxList<AddressModel> addresses = <AddressModel>[].obs;
  RxList<OrderModel> orders = <OrderModel>[].obs;
  final isLoading = false.obs;
  RxString fullName = ''.obs;
  RxString email = ''.obs;
  RxString imageUrl = ''.obs;

  @override
  void onInit() async {
    super.onInit();
    await fetchAllCustomer();
    await fetchAllOrder();
    updateCloudStorageInfo();
  }


  Future<void> fetchAllCustomer() async {
    isLoading(true);
    try {
      customers.clear();
      final fetchedCustomer = await customerRepository.fetchAllCustomer();
      customers.assignAll(fetchedCustomer);
    } catch (e) {
      TLoaders.errorSnackBar(
        title: 'Chà, thật đáng tiếc!',
        message: e.toString(),
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchAllOrder() async {
    isLoading(true);
    try {
      orders.clear();
      final allUsers = await customerRepository.fetchAllCustomer();
      final allOrders = await Future.wait(
        allUsers.map((user) => customerRepository.fetchOrdersByUserId(user.id)),
      );
      orders.assignAll(allOrders.expand((x) => x).toList());
    } catch (e) {
      TLoaders.errorSnackBar(
        title: 'Lỗi',
        message: 'Không thể tải tất cả đơn hàng: ${e.toString()}',
      );
    } finally {
      isLoading(false);
    }
  }


  Future<void> fetchCustomerById(String cusId) async {
    isLoading(true);
    try {
      final snapshot = await customerRepository.getUserById(cusId);
      if (snapshot != null) {
        fullName.value = snapshot.fullName;
        email.value = snapshot.email;
        imageUrl.value = snapshot.profilePicture;

        addresses.assignAll(snapshot.addresses);
        orders.assignAll(snapshot.orders);
      } else {
        TLoaders.errorSnackBar(
          title: 'Lỗi',
          message: 'Không tìm thấy khách hàng với ID: $cusId',
        );
      }
    } catch (e) {
      TLoaders.errorSnackBar(
        title: 'Lỗi',
        message: 'Đã xảy ra lỗi: ${e.toString()}',
      );
    } finally {
      isLoading(false);
    }
  }


  double calculateOrderStatusPending() {
    return orders
        .where((order) => order.status == OrderStatus.pending)
        .fold(0.0, (sum, order) => sum + order.totalAmount);
  }

  int countOrderStatusPending() {
    return orders.where((order) => order.status == OrderStatus.pending).length;
  }

  double calculateOrderStatusPrepare() {
    return orders
        .where((order) => order.status == OrderStatus.prepare)
        .fold(0.0, (sum, order) => sum + order.totalAmount);
  }

  int countOrderStatusPrepare() {
    return orders.where((order) => order.status == OrderStatus.prepare).length;
  }

  double calculateOrderStatusProcessing() {
    return orders
        .where((order) => order.status == OrderStatus.processing)
        .fold(0.0, (sum, order) => sum + order.totalAmount);
  }

  int countOrderStatusProcessing() {
    return orders.where((order) => order.status == OrderStatus.processing).length;
  }

  double calculateOrderStatusDelivered() {
    return orders
        .where((order) => order.status == OrderStatus.delivered)
        .fold(0.0, (sum, order) => sum + order.totalAmount);
  }

  int countOrderStatusDelivered() {
    return orders.where((order) => order.status == OrderStatus.delivered).length;
  }

  double calculateOrderStatusCancelled() {
    return orders
        .where((order) => order.status == OrderStatus.cancel)
        .fold(0.0, (sum, order) => sum + order.totalAmount);
  }

  int countOrderStatusCancelled() {
    return orders.where((order) => order.status == OrderStatus.cancel).length;
  }

  double calculateOrderStatusShipped() {
    return orders
        .where((order) => order.status == OrderStatus.shipped)
        .fold(0.0, (sum, order) => sum + order.totalAmount);
  }

  int countOrderStatusShipped() {
    return orders.where((order) => order.status == OrderStatus.shipped).length;
  }

  // Tính doanh số bán hàng
  double calculateSalesRevenue() {
    return orders
        .where((order) => order.status == OrderStatus.delivered)
        .fold(0.0, (sum, order) => sum + order.totalAmount);
  }

  // Tính đơn hàng trung bình
  double calculateAverageOrderValue() {
    final deliveredOrders = orders.where((order) =>
    order.status == OrderStatus.delivered).toList();
    if (deliveredOrders.isEmpty) return 0.0;
    final totalRevenue = deliveredOrders.fold(
        0.0, (sum, order) => sum + order.totalAmount);
    return totalRevenue / deliveredOrders.length;
  }

  // Tính tổng đơn hàng
  double calculateTotalOrderAmount() {
    return orders.fold(0.0, (sum, order) => sum + order.totalAmount);
  }

  // Tính số lượng người dùng
  int calculateTotalUsers() {
    return customers.length;
  }

  // Gán giá trị tính toán vào demoMyFiles
  RxList<CloudStorageInfo> demoMyFiles = <CloudStorageInfo>[].obs;

  void updateCloudStorageInfo() {
    // Cập nhật vào danh sách
    demoMyFiles.value = [
      CloudStorageInfo(
        title: "Doanh số bán hàng",
        numOfFiles: calculateSalesRevenue().toInt(),
        svgSrc: "assets/icons/sales.svg",
        totalStorage: "tăng 12%",
        color: bgColor,
        percentage: 12,
      ),
      CloudStorageInfo(
        title: "Đơn hàng trung bình",
        numOfFiles: calculateAverageOrderValue().toInt(),
        svgSrc: "assets/icons/avegare.svg",
        totalStorage: "tăng 15",
        color: Color(0xFFFFA113),
        percentage: 15,
      ),
      CloudStorageInfo(
        title: "Tổng đơn hàng",
        numOfFiles: calculateTotalOrderAmount().toInt(),
        svgSrc: "assets/icons/drop_box.svg",
        totalStorage: "tăng 30%",
        color: Color(0xFFA4CDFF),
        percentage: 30,
      ),
      CloudStorageInfo(
        title: "Người dùng truy cập",
        numOfFiles: calculateTotalUsers() ,
        svgSrc: "assets/icons/menu_profile.svg",
        totalStorage: "tăng 10%",
        color: Color(0xFF007EE5),
        percentage: 10,
      ),
    ];
  }

}
