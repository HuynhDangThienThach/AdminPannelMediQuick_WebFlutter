import 'package:admin/controllers/product_controller.dart';
import 'package:admin/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants.dart';
import 'RCreateProductScreen.dart';

class LCreateProductScreen extends StatefulWidget {
  const LCreateProductScreen({super.key});

  @override
  State<LCreateProductScreen> createState() => _LCreateProductScreenState();
}

class _LCreateProductScreenState extends State<LCreateProductScreen> {
  final controller = Get.put(ProductController());
  // Hàm xóa thuộc tính
  void removeAttribute(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Xác nhận xóa', style: TextStyle(color: Colors.white)),
          content: Text('Bạn có muốn xóa thuộc tính này không?',
              style: TextStyle(color: Colors.white)),
          backgroundColor: secondaryColor,
          actions: [
            TextButton(
              child: Text('Không', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Có', style: TextStyle(color: Colors.white)),
              onPressed: () {
                setState(() {
                  controller.attributes.removeAt(index);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.createProductFormKey,
      child: Row(
        children: [
          Expanded(
            flex: 7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Thông tin cơ bản
                Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Thông tin cơ bản',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      SizedBox(height: 16.0),
                      TextFormField(
                        controller: controller.tenSp,
                        decoration: InputDecoration(
                            labelText: 'Tên sản phẩm',
                            labelStyle: TextStyle(color: Colors.white),
                            filled: true,
                            fillColor: secondaryColor,
                            border: OutlineInputBorder(),
                            hintText: "Viên nén Tanakan 40mg"),
                        validator: (value) =>
                            TValidator.validateProductName(value),
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(height: 16.0),
                      TextFormField(
                        controller: controller.motaSP,
                        decoration: InputDecoration(
                            labelText: 'Mô tả sản phẩm',
                            labelStyle: TextStyle(color: Colors.white),
                            filled: true,
                            fillColor: secondaryColor,
                            border: OutlineInputBorder(),
                            hintText:
                                "Viên nén Tanakan 40mg là một loại thuốc chiết xuất từ cây bạch quả (Ginkgo biloba),...."),
                        maxLines: 4,
                        textAlign: TextAlign.justify,
                        style: TextStyle(color: Colors.white),
                        validator: (value) =>
                            TValidator.validateProductDescription(value),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.0),

                // Số lượng và giá cả
                Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Số lượng và giá cả',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      SizedBox(height: 16.0),
                      Text('Loại giá cả',
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  controller.priceType = 'single';
                                  controller.loaiGiaTri.value =
                                      'ProductType.single';
                                });
                              },
                              child: Row(
                                children: [
                                  Radio(
                                    value: 'single',
                                    groupValue: controller.priceType,
                                    onChanged: (value) {
                                      setState(() {
                                        controller.priceType = value.toString();
                                        controller.loaiGiaTri.value =
                                            'ProductType.single';
                                      });
                                    },
                                    activeColor: Colors.blue,
                                  ),
                                  Text('Một giá',
                                      style: TextStyle(color: Colors.white)),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  controller.priceType = 'variable';
                                  controller.loaiGiaTri.value =
                                      'ProductType.variable';
                                });
                              },
                              child: Row(
                                children: [
                                  Radio(
                                    value: 'variable',
                                    groupValue: controller.priceType,
                                    onChanged: (value) {
                                      setState(() {
                                        controller.priceType = value.toString();
                                        controller.loaiGiaTri.value =
                                            'ProductType.variable';
                                      });
                                    },
                                    activeColor: Colors.blue,
                                  ),
                                  Text('Nhiều giá',
                                      style: TextStyle(color: Colors.white)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.0),

                      // Hiển thị trường nhập liệu nếu chọn "Một giá"
                      if (controller.priceType == 'single') ...[
                        TextFormField(
                          controller: controller.soLuong,
                          decoration: InputDecoration(
                              labelText: 'Số lượng',
                              labelStyle: TextStyle(color: Colors.white),
                              filled: true,
                              fillColor: secondaryColor,
                              border: OutlineInputBorder(),
                              hintText: "123"),
                          validator: (value) =>
                              TValidator.validateProductStock(value),
                          keyboardType: TextInputType.number,
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(height: 16.0),
                        TextFormField(
                          controller: controller.giaBan,
                          decoration: InputDecoration(
                              labelText: 'Giá bán',
                              labelStyle: TextStyle(color: Colors.white),
                              filled: true,
                              fillColor: secondaryColor,
                              border: OutlineInputBorder(),
                              hintText: "15000"),
                          keyboardType: TextInputType.number,
                          style: TextStyle(color: Colors.white),
                          validator: (value) =>
                              TValidator.validateProductPrice(value),
                        ),
                        SizedBox(height: 16.0),
                        TextFormField(
                          controller: controller.giamGia,
                          decoration: InputDecoration(
                              labelText: 'Giảm giá',
                              labelStyle: TextStyle(color: Colors.white),
                              filled: true,
                              fillColor: secondaryColor,
                              border: OutlineInputBorder(),
                              hintText: "10000"),
                          keyboardType: TextInputType.number,
                          style: TextStyle(color: Colors.white),
                          validator: (value) =>
                              TValidator.validateProductSalePrice(value),
                        ),
                        SizedBox(height: 20.0),
                        Text(
                          'Thuộc tính của sản phẩm',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        SizedBox(height: 20.0),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: controller.tenThuocTinh,
                                decoration: InputDecoration(
                                    labelText: 'Tên thuộc tính',
                                    labelStyle: TextStyle(color: Colors.white),
                                    filled: true,
                                    fillColor: secondaryColor,
                                    border: OutlineInputBorder(),
                                    hintText: "Phân loại"),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            SizedBox(width: 16.0),
                            Expanded(
                              child: TextFormField(
                                controller: controller.thuoctinh,
                                decoration: InputDecoration(
                                    labelText: 'Thuộc tính',
                                    labelStyle: TextStyle(color: Colors.white),
                                    filled: true,
                                    fillColor: secondaryColor,
                                    border: OutlineInputBorder(),
                                    hintText: "Hộp hoặc Hộp|Chai|Viên "),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            SizedBox(width: 16.0),
                            ElevatedButton(
                              onPressed: controller.addAttribute,
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.blue,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 5,
                              ),
                              child: Text('Thêm',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.0),
                        Text(
                          'Tất cả thuộc tính',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        SizedBox(height: 16.0),
                        Obx(
                          () => Column(
                            children: controller.attributes.map((attribute) {
                              int index =
                                  controller.attributes.indexOf(attribute);
                              String values =
                                  (attribute['value'] as List<String>)
                                      .join(', ');
                              return Card(
                                child: ListTile(
                                  title: Text('${attribute['name']}:$values',
                                      style: TextStyle(color: Colors.white)),
                                  trailing: IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => removeAttribute(index),
                                  ),
                                ),
                                color: secondaryColor,
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                      // Hiển thị trường nhập liệu nếu chọn "Nhiều giá"
                      if (controller.priceType == 'variable') ...[
                        Text(
                          'Thuộc tính của sản phẩm',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        SizedBox(height: 16.0),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: controller.tenThuocTinh,
                                decoration: InputDecoration(
                                    labelText: 'Tên thuộc tính',
                                    labelStyle: TextStyle(color: Colors.white),
                                    filled: true,
                                    fillColor: secondaryColor,
                                    border: OutlineInputBorder(),
                                    hintText: "Phân loại"),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            SizedBox(width: 16.0),
                            Expanded(
                              child: TextFormField(
                                controller: controller.thuoctinh,
                                decoration: InputDecoration(
                                    labelText: 'Thuộc tính',
                                    labelStyle: TextStyle(color: Colors.white),
                                    filled: true,
                                    fillColor: secondaryColor,
                                    border: OutlineInputBorder(),
                                    hintText: "Hộp hoặc Hộp|Chai|Viên "),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            SizedBox(width: 16.0),
                            ElevatedButton(
                              onPressed: controller.addAttribute,
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.blue,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 5,
                              ),
                              child: Text('Thêm',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.0),
                        Text(
                          'Tất cả thuộc tính',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        SizedBox(height: 16.0),
                        Obx(
                          () => Column(
                            children: controller.attributes.map((attribute) {
                              int index =
                                  controller.attributes.indexOf(attribute);
                              String values =
                                  (attribute['value'] as List<String>)
                                      .join(', ');
                              return Card(
                                child: ListTile(
                                  title: Text('${attribute['name']}: $values',
                                      style: TextStyle(color: Colors.white)),
                                  trailing: IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => removeAttribute(index),
                                  ),
                                ),
                                color: secondaryColor,
                              );
                            }).toList(),
                          ),
                        ),
                        SizedBox(height: 16.0),
                        Obx(
                          () => controller.attributes.isNotEmpty
                              ? Center(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      controller.isVariantVisible.value = true;
                                      controller.expandedVariants.value =
                                          List.generate(
                                        controller.attributes.length,
                                        (index) => false,
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: Colors.blue,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 24, vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      elevation: 5,
                                    ),
                                    child: Text('Tạo biến thể cho thuộc tính',
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                )
                              : SizedBox.shrink(),
                        ),
                        SizedBox(height: 20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Biến thể sản phẩm',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Spacer(),
                            TextButton(
                              child: Text("Xóa tất cả biến thể "),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Xóa biến thể"),
                                      content: Text(
                                          "Bạn có muốn xóa biến thể không?"),
                                      actions: [
                                        TextButton(
                                          child: Text("Không"),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          child: Text("Có"),
                                          onPressed: () {
                                            controller.isVariantVisible.value =
                                                false;
                                            controller.expandedVariants.clear();
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                        Obx(
                          () => controller.isVariantVisible.value
                              ? Column(
                                  children:
                                      controller.attributes.map((attribute) {
                                    int index = controller.attributes
                                        .indexOf(attribute);
                                    return Card(
                                      color: secondaryColor,
                                      child: Column(
                                        children: [
                                          ListTile(
                                            title: Text(
                                                '${attribute['name']}:${attribute['value']}',
                                                style: TextStyle(
                                                    color: Colors.white)),
                                            trailing: IconButton(
                                              icon: Icon(
                                                controller
                                                        .expandedVariants[index]
                                                    ? Icons.arrow_upward_rounded
                                                    : Icons
                                                        .arrow_downward_rounded,
                                                color: Colors.white,
                                              ),
                                              onPressed: () {
                                                controller.expandedVariants[
                                                        index] =
                                                    !controller
                                                            .expandedVariants[
                                                        index];
                                              },
                                            ),
                                          ),
                                          if (controller
                                              .expandedVariants[index])
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 16.0),
                                              child: Column(
                                                children: [
                                                  TextFormField(
                                                    controller:
                                                        controller.hinhdh,
                                                    decoration: InputDecoration(
                                                        labelText:
                                                            'Nhập đường link của ảnh',
                                                        labelStyle: TextStyle(
                                                            color:
                                                                Colors.white),
                                                        filled: true,
                                                        fillColor:
                                                            secondaryColor,
                                                        border:
                                                            OutlineInputBorder(),
                                                        hintText:
                                                            "https://i.pinimg.com/236x/4a/4c/0e/4a4c0ef22c89c4a504fb0ee8d420b996.jpg"),
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                    validator: (value) => TValidator
                                                        .validateLinkImageProduct(
                                                            value),
                                                  ),
                                                  SizedBox(height: 16.0),
                                                  TextFormField(
                                                    controller:
                                                        controller.soLuong,
                                                    decoration: InputDecoration(
                                                        labelText: 'Số lượng',
                                                        labelStyle: TextStyle(
                                                            color:
                                                                Colors.white),
                                                        filled: true,
                                                        fillColor:
                                                            secondaryColor,
                                                        border:
                                                            OutlineInputBorder(),
                                                        hintText: "123"),
                                                    keyboardType:
                                                        TextInputType.number,
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                    validator: (value) =>
                                                        TValidator
                                                            .validateProductStock(
                                                                value),
                                                  ),
                                                  SizedBox(height: 16.0),
                                                  TextFormField(
                                                    controller:
                                                        controller.giaBan,
                                                    decoration: InputDecoration(
                                                        labelText: 'Giá bán',
                                                        labelStyle: TextStyle(
                                                            color:
                                                                Colors.white),
                                                        filled: true,
                                                        fillColor:
                                                            secondaryColor,
                                                        border:
                                                            OutlineInputBorder(),
                                                        hintText: "15000"),
                                                    keyboardType:
                                                        TextInputType.number,
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                    validator: (value) =>
                                                        TValidator
                                                            .validateProductPrice(
                                                                value),
                                                  ),
                                                  SizedBox(height: 16.0),
                                                  TextFormField(
                                                    controller:
                                                        controller.giamGia,
                                                    decoration: InputDecoration(
                                                        labelText: 'Giảm giá',
                                                        labelStyle: TextStyle(
                                                            color:
                                                                Colors.white),
                                                        filled: true,
                                                        fillColor:
                                                            secondaryColor,
                                                        border:
                                                            OutlineInputBorder(),
                                                        hintText: "10000"),
                                                    keyboardType:
                                                        TextInputType.number,
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                    validator: (value) => TValidator
                                                        .validateProductSalePrice(
                                                            value),
                                                  ),
                                                  SizedBox(height: 16.0),
                                                  TextFormField(
                                                    controller:
                                                        controller.motaSP,
                                                    decoration: InputDecoration(
                                                        labelText:
                                                            'Mô tả sản phẩm',
                                                        labelStyle: TextStyle(
                                                            color:
                                                                Colors.white),
                                                        filled: true,
                                                        fillColor:
                                                            secondaryColor,
                                                        border:
                                                            OutlineInputBorder(),
                                                        hintText:
                                                            "Viên nén Tanakan 40mg là một loại thuốc chiết xuất từ cây bạch quả (Ginkgo biloba), thường được sử dụng để cải thiện tuần hoàn máu não và hỗ trợ điều trị các triệu chứng liên quan đến rối loạn tuần hoàn não như chóng mặt, ù tai, suy giảm trí nhớ, và khả năng tập trung."),
                                                    maxLines: 4,
                                                    textAlign:
                                                        TextAlign.justify,
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                    validator: (value) => TValidator
                                                        .validateProductDescription(
                                                            value),
                                                  ),
                                                ],
                                              ),
                                            ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                )
                              : SizedBox.shrink(),
                        ),
                      ],
                      SizedBox(height: 20.0),
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            width: 20,
          ),
          RCreateProductScreen(),
        ],
      ),
    );
  }
}
