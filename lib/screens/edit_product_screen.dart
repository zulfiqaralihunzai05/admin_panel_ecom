import 'package:admin_panel_ecom/models/product_model.dart';
import 'package:admin_panel_ecom/utils/constant.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../controller/category_dropdown_controller.dart';
import '../controller/edit_product_controller.dart';
import '../controller/is_sale_controller.dart';

class EditProductScreen extends StatelessWidget {
  ProductModel productModel;

  EditProductScreen({super.key, required this.productModel});

  IsSaleController isSaleController = Get.put(IsSaleController());
  CategoryDropDownController categoryDropDownController =
      Get.put(CategoryDropDownController());
  TextEditingController productNameController = TextEditingController();
  TextEditingController salePriceController = TextEditingController();
  TextEditingController fullPriceController = TextEditingController();
  TextEditingController deliveryTimeController = TextEditingController();
  TextEditingController productDescriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditProductController>(
      init: EditProductController(productModel: productModel),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppConstant.appScendoryColor,
            centerTitle: true,
            iconTheme: Theme.of(context).primaryIconTheme,
            title: const Text(
              'Edit Product',
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                  SingleChildScrollView(
                    child: Container(
                      width: MediaQuery.of(context).size.width - 20,
                      height: Get.height / 4.0,
                      child: GridView.builder(
                        itemCount: controller.images.length,
                        physics: const BouncingScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 2,
                          crossAxisSpacing: 2,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return Stack(
                            children: [
                              CachedNetworkImage(
                                imageUrl: controller.images[index],
                                fit: BoxFit.contain,
                                height: Get.height / 5.5,
                                width: Get.width / 2,
                                placeholder: (context, url) => const Center(
                                    child: CupertinoActivityIndicator()),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                              Positioned(
                                right: 10,
                                top: 0,
                                child: InkWell(
                                  onTap: () async {
                                    EasyLoading.show(status: 'Please Wait..');
                                    await controller.deleteImagesFromStorage(
                                        controller.images[index].toString());
                                    await controller.deleteImagesFromFireStore(
                                        controller.images[index].toString(),
                                        productModel.productId);
                                    EasyLoading.dismiss();
                                  },
                                  child: const CircleAvatar(
                                    backgroundColor:
                                        AppConstant.appScendoryColor,
                                    child: Icon(
                                      Icons.close,
                                      color: AppConstant.appTextColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  GetBuilder<CategoryDropDownController>(
                    init: CategoryDropDownController(),
                    builder: (categoriesDropDownController) {
                      return Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 0.0),
                            child: Card(
                              elevation: 10,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: DropdownButton<String>(
                                  value: categoriesDropDownController
                                      .selectedCategoryId?.value,
                                  items: categoriesDropDownController.categories
                                      .map((category) {
                                    return DropdownMenuItem<String>(
                                      value: category['categoryId'],
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          CircleAvatar(
                                            backgroundImage: NetworkImage(
                                              category['categoryImg']
                                                  .toString(),
                                            ),
                                          ),
                                          const SizedBox(width: 20),
                                          Text(category['categoryName']),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (String? selectedValue) async {
                                    categoriesDropDownController
                                        .setSelectedCategory(selectedValue);
                                    String? categoryName =
                                        await categoriesDropDownController
                                            .getCategoryName(selectedValue);
                                    categoriesDropDownController
                                        .setCategoryName(categoryName);
                                  },
                                  hint: const Text(
                                    'Select a category',
                                  ),
                                  isExpanded: true,
                                  elevation: 10,
                                  underline: const SizedBox.shrink(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  GetBuilder<IsSaleController>(
                    init: IsSaleController(),
                    builder: (isSaleController) {
                      return Card(
                        elevation: 10,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Is Sale'),
                              Switch(
                                value: isSaleController.isSale.value,
                                activeColor: AppConstant.appMainColor,
                                onChanged: (value) {
                                  isSaleController.toggleIsSale(value);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  Container(
                    height: 65,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextFormField(
                      cursorColor: AppConstant.appMainColor,
                      textInputAction: TextInputAction.next,
                      controller: productNameController
                        ..text = productModel.productName,
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          hintText: 'Product Name',
                          hintStyle: TextStyle(fontSize: 12),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)))),
                    ),
                  ),
                  GetBuilder<IsSaleController>(
                    init: IsSaleController(),
                    builder: (isSaleController) {
                      return isSaleController.isSale.value
                          ? Container(
                        height: 65,
                        margin: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: TextFormField(
                          cursorColor: AppConstant.appMainColor,
                          textInputAction: TextInputAction.next,
                          controller: salePriceController
                            ..text = productModel.salePrice,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 10.0,
                            ),
                            hintText: "Sale Price",
                            hintStyle: TextStyle(fontSize: 12.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                          ),
                        ),
                      )
                          : const SizedBox.shrink();
                    },
                  ),
                  Container(
                    height: 65,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextFormField(
                      cursorColor: AppConstant.appMainColor,
                      textInputAction: TextInputAction.next,
                      controller: fullPriceController
                        ..text = productModel.fullPrice,
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          hintText: 'Full Price',
                          hintStyle: TextStyle(fontSize: 12),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)))),
                    ),
                  ),
                  Container(
                    height: 65,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextFormField(
                      cursorColor: AppConstant.appMainColor,
                      textInputAction: TextInputAction.next,
                      controller: deliveryTimeController
                        ..text = productModel.deliveryTime,
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          hintText: 'Delivery Time',
                          hintStyle: TextStyle(fontSize: 12),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)))),
                    ),
                  ),
                  Container(
                    height: 65,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextFormField(
                      cursorColor: AppConstant.appMainColor,
                      textInputAction: TextInputAction.next,
                      controller: productDescriptionController
                        ..text = productModel.productDescription,
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          hintText: 'Product Description',
                          hintStyle: TextStyle(fontSize: 12),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)))),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Material(
                      child: Container(
                        width: Get.width / 2,
                        height: Get.height / 15,
                        decoration: BoxDecoration(
                            color: AppConstant.appScendoryColor,
                            borderRadius: BorderRadius.circular(20)),
                        child: TextButton(
                          onPressed: () async {
                            EasyLoading.show(status: 'Please Wait..');
                            ProductModel newProductModel = ProductModel(
                                productId: productModel.productId,
                                categoryId: categoryDropDownController
                                    .selectedCategoryId
                                    .toString(),
                                productName: productNameController.text.trim(),
                                categoryName: categoryDropDownController
                                    .selectedCategoryName
                                    .toString(),
                                salePrice: salePriceController.text != ''
                                    ? salePriceController.text.trim()
                                    : '',
                                fullPrice: fullPriceController.text.trim(),
                                productImages: productModel.productImages,
                                deliveryTime:
                                    deliveryTimeController.text.trim(),
                                isSale: isSaleController.isSale.value,
                                productDescription:
                                    productDescriptionController.text.trim(),
                                createdAt: productModel.createdAt,
                                updatedAt: DateTime.now());

                            await FirebaseFirestore.instance
                                .collection('products')
                                .doc(productModel.productId)
                                .update(newProductModel.toMap());
                            EasyLoading.dismiss();
                          },
                          child: const Text(
                            'Update',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
