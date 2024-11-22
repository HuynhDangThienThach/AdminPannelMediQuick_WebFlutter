import 'package:admin/controllers/brandController.dart';
import 'package:admin/controllers/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants.dart';
import '../../../controllers/categoryController.dart';
import '../../../models/brand_model.dart';

class LEditProductScreen extends StatefulWidget {
  const LEditProductScreen({super.key, required this.productId});

  final String productId;

  @override
  State<LEditProductScreen> createState() => _LEditProductScreenState();
}

class _LEditProductScreenState extends State<LEditProductScreen> {
  final controller = Get.put(ProductController());
  final controllerBrand = Get.put(BrandController());
  final controllerCategory = Get.put(CategoryController());

  void initState() {
    super.initState();
    _loadProduct();
  }

  Future<void> _loadProduct() async {
    await controller.getProductById(widget.productId);

    controller.attributes.clear();
    final product = controller.product.value;

    controller.tenSp.text = product.title;
    controller.motaSP.text = product.description ?? '';
    controller.soLuong.text = product.stock.toString();
    controller.giaBan.text = product.price.toString();
    controller.giamGia.text = product.salePrice.toString();
    controller.loaiGiaTri.value = product.productType;
    controller.hinhdh.text = product.thumbnail;

    controller.priceType = product.productType == 'ProductType.single' ? 'single' : 'variable';

    for (var attribute in product.productAttributes!) {
      controller.attributes.add({
        'name': attribute.name,
        'value': attribute.values,
      });
    }

    for (int i = 0; i < product.images!.length && i < controller.imageControllers.length; i++) {
      controller.imageControllers[i].text = product.images![i];
    }

    if (product.brand != null) {
      controllerBrand.setSelectedBrand(product.brand!);
    }
    if (product.categoryId != null) {
      final selectedCategory = controllerCategory.categories
          .firstWhere((cat) => cat.id == product.categoryId);
      controllerCategory.setSelectedCategory(selectedCategory);
    }

    controller.tuyChonHienThi.value = (controller.displayOption == 'Hiển thị');
    }


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
                        ),
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
                        ),
                        maxLines: 4,
                        textAlign: TextAlign.justify,
                        style: TextStyle(color: Colors.white),
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
                          ),
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
                          ),
                          keyboardType: TextInputType.number,
                          style: TextStyle(color: Colors.white),
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
                          ),
                          keyboardType: TextInputType.number,
                          style: TextStyle(color: Colors.white),
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
                                ),
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
                                ),
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
                                ),
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
                                ),
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
                                                          color: Colors.white),
                                                      filled: true,
                                                      fillColor: secondaryColor,
                                                      border:
                                                          OutlineInputBorder(),
                                                    ),
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  SizedBox(height: 16.0),
                                                  TextFormField(
                                                    controller:
                                                        controller.soLuong,
                                                    decoration: InputDecoration(
                                                      labelText: 'Số lượng',
                                                      labelStyle: TextStyle(
                                                          color: Colors.white),
                                                      filled: true,
                                                      fillColor: secondaryColor,
                                                      border:
                                                          OutlineInputBorder(),
                                                    ),
                                                    keyboardType:
                                                        TextInputType.number,
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  SizedBox(height: 16.0),
                                                  TextFormField(
                                                    controller:
                                                        controller.giaBan,
                                                    decoration: InputDecoration(
                                                      labelText: 'Giá bán',
                                                      labelStyle: TextStyle(
                                                          color: Colors.white),
                                                      filled: true,
                                                      fillColor: secondaryColor,
                                                      border:
                                                          OutlineInputBorder(),
                                                    ),
                                                    keyboardType:
                                                        TextInputType.number,
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  SizedBox(height: 16.0),
                                                  TextFormField(
                                                    controller:
                                                        controller.giamGia,
                                                    decoration: InputDecoration(
                                                      labelText: 'Giảm giá',
                                                      labelStyle: TextStyle(
                                                          color: Colors.white),
                                                      filled: true,
                                                      fillColor: secondaryColor,
                                                      border:
                                                          OutlineInputBorder(),
                                                    ),
                                                    keyboardType:
                                                        TextInputType.number,
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  SizedBox(height: 16.0),
                                                  TextFormField(
                                                    controller:
                                                        controller.motaSP,
                                                    decoration: InputDecoration(
                                                      labelText:
                                                          'Mô tả sản phẩm',
                                                      labelStyle: TextStyle(
                                                          color: Colors.white),
                                                      filled: true,
                                                      fillColor: secondaryColor,
                                                      border:
                                                          OutlineInputBorder(),
                                                    ),
                                                    maxLines: 4,
                                                    textAlign:
                                                        TextAlign.justify,
                                                    style: TextStyle(
                                                        color: Colors.white),
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
          SizedBox(width: 20,),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Container 1: Hình thu nhỏ (Thumbnail)
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
                        'Hình thu nhỏ (Thumbnail)',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      SizedBox(height: 16.0),
                      TextFormField(
                        controller: controller.hinhdh,
                        decoration: InputDecoration(
                          labelText: 'Nhập đường link của ảnh',
                          labelStyle: TextStyle(color: Colors.white),
                          filled: true,
                          fillColor: secondaryColor,
                          border: OutlineInputBorder(),
                        ),
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.0),

                // Container 2: Ảnh của sản phẩm
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
                        'Ảnh của sản phẩm',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      SizedBox(height: 16.0),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: 4,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: TextFormField(
                              controller: controller.imageControllers[index],
                              decoration: InputDecoration(
                                labelText: 'Nhập đường link ảnh ${index + 1}',
                                labelStyle: TextStyle(color: Colors.white),
                                filled: true,
                                fillColor: secondaryColor,
                                border: OutlineInputBorder(),
                              ),
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.0),

                // Container 3: Thương hiệu
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
                        'Thương hiệu',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      SizedBox(height: 16.0),
                      Obx(() {
                        // Kiểm tra xem danh sách thương hiệu có trống không
                        if (controllerBrand.brands.isEmpty) {
                          return CircularProgressIndicator(); // Hoặc một thông báo nào đó
                        }

                        // Kiểm tra xem selectedBrand có tồn tại trong danh sách brands không
                        final selectedBrand = controllerBrand.brands.firstWhere(
                          (brand) =>
                              brand.id == controllerBrand.selectedBrand?.id,
                        );

                        return DropdownButtonFormField<BrandModel>(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: secondaryColor,
                            border: OutlineInputBorder(),
                          ),
                          value: selectedBrand,
                          hint: Text(
                            'Chọn thương hiệu',
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                          dropdownColor: secondaryColor,
                          style: TextStyle(color: Colors.white),
                          items: controllerBrand.brands.map((brand) {
                            return DropdownMenuItem(
                              value: brand,
                              child: Text(brand.name),
                            );
                          }).toList(),
                          onChanged: (brand) {
                            if (brand != null) {
                              controllerBrand.setSelectedBrand(brand);
                            }
                          },
                        );
                      })
                    ],
                  ),
                ),
                SizedBox(height: 16.0),

                // Container 4: Loại sản phẩm
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
                        'Loại sản phẩm',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      SizedBox(height: 16.0),
                      Obx(
                        () => DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: secondaryColor,
                            border: OutlineInputBorder(),
                          ),
                          value: controllerCategory.selectedCategory?.id,
                          hint: Text('Chọn loại sản phẩm',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15)),
                          dropdownColor: secondaryColor,
                          style: TextStyle(color: Colors.white),
                          items: controllerCategory.categories.map((category) {
                            return DropdownMenuItem(
                              value: category.id,
                              child: Text(category.name,
                                  style: TextStyle(color: Colors.white)),
                            );
                          }).toList(),
                          onChanged: (value) {
                            final selectedCat = controllerCategory.categories
                                .firstWhere((cat) => cat.id == value);
                            controllerCategory.setSelectedCategory(selectedCat);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.0),

                // Container 5: Tùy chọn hiển thị
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
                        'Tùy chọn hiển thị',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Row(
                        children: [
                          Radio<String>(
                            value: 'Hiển thị',
                            groupValue: controller.displayOption.value,
                            onChanged: (value) {
                              setState(() {
                                controller.displayOption.value = value!;
                                controller.tuyChonHienThi.value = true;
                              });
                            },
                            activeColor: Colors.blue,
                          ),
                          Text('Hiển thị',
                              style: TextStyle(color: Colors.white)),
                          Radio<String>(
                            value: 'Ẩn',
                            groupValue: controller.displayOption.value,
                            onChanged: (value) {
                              setState(() {
                                controller.displayOption.value = value!;
                                controller.tuyChonHienThi.value = false;
                              });
                            },
                            activeColor: Colors.blue,
                          ),
                          Text('Ẩn', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
