import 'dart:io';

import 'package:admin_panel_ecom/controller/is_sale_controller.dart';
import 'package:admin_panel_ecom/models/product_model.dart';
import 'package:admin_panel_ecom/utils/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../controller/category_dropdown_controller.dart';
import '../controller/product_images_controller.dart';
import '../services/generate_ids_service.dart';
import '../widgets/dropdown-categories-widget.dart';

class AddProductsScreen extends StatelessWidget {
  AddProductsScreen({super.key});

  AddProductImagesController addProductImagesController = Get.put(AddProductImagesController());
  CategoryDropDownController categoryDropDownController =
      Get.put(CategoryDropDownController());
  IsSaleController isSaleController = Get.put(IsSaleController());

  TextEditingController productNameController = TextEditingController();
  TextEditingController salePriceController = TextEditingController();
  TextEditingController fullPriceController = TextEditingController();
  TextEditingController deliveryTimeController = TextEditingController();
  TextEditingController productDescriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Product',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: Theme.of(context).primaryIconTheme,
        centerTitle: true,
        backgroundColor: AppConstant.appScendoryColor,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          child: Column(
            children: [
              ///Select Images
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Select Images'),
                    ElevatedButton(
                        onPressed: () {
                          addProductImagesController.showImagesPickerDialog();
                        },
                        child: const Text('Select Images'))
                  ],
                ),
              ),

              ///Show Images
              GetBuilder<AddProductImagesController>(
                init: AddProductImagesController(),
                builder: (imageController) {
                  return imageController.selectedImage.length > 0
                      ? Container(
                          width: MediaQuery.of(context).size.width - 20,
                          height: Get.height / 3.0,
                          child: GridView.builder(
                            itemCount: imageController.selectedImage.length,
                            physics: const BouncingScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 20,
                              crossAxisSpacing: 10,
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              return Stack(
                                children: [
                                  Image.file(
                                    File(addProductImagesController
                                        .selectedImage[index].path),
                                    fit: BoxFit.cover,
                                    height: Get.height / 4,
                                    width: Get.width / 2,
                                  ),
                                  Positioned(
                                    right: 10,
                                    top: 0,
                                    child: InkWell(
                                      onTap: () {
                                        imageController.removeImages(index);
                                        print(imageController
                                            .selectedImage.length);
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
                        )
                      : const SizedBox.shrink();
                },
              ),

              ///Show Categories in DropDown
              const Padding(
                padding: EdgeInsets.only(left: 15.0, right: 15),
                child: DropDownCategoriesWidget(),
              ),

              ///IsSale Toggle
              GetBuilder(
                  init: IsSaleController(),
                  builder: (isSaleController) {
                    return Card(
                      child: Padding(
                        padding: EdgeInsets.all(8),
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
                  }),
              //Form

              const SizedBox(
                height: 5,
              ),
              Container(
                height: 65,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: TextFormField(
                  cursorColor: AppConstant.appMainColor,
                  textInputAction: TextInputAction.next,
                  controller: productNameController,
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      hintText: 'Product Name',
                      hintStyle: TextStyle(fontSize: 12),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)))),
                ),
              ),

              Obx(() {
                return isSaleController.isSale.value
                    ? Container(
                        height: 65,
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextFormField(
                          cursorColor: AppConstant.appMainColor,
                          textInputAction: TextInputAction.next,
                          controller: salePriceController,
                          decoration: const InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10),
                              hintText: 'Sale Price',
                              hintStyle: TextStyle(fontSize: 12),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)))),
                        ),
                      )
                    : const SizedBox.shrink();
              }),

              Container(
                height: 65,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: TextFormField(
                  cursorColor: AppConstant.appMainColor,
                  textInputAction: TextInputAction.next,
                  controller: fullPriceController,
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      hintText: 'Full Price',
                      hintStyle: TextStyle(fontSize: 12),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)))),
                ),
              ),
              Container(
                height: 65,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: TextFormField(
                  cursorColor: AppConstant.appMainColor,
                  textInputAction: TextInputAction.next,
                  controller: deliveryTimeController,
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      hintText: 'Delivery Time',
                      hintStyle: TextStyle(fontSize: 12),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)))),
                ),
              ),
              Container(
                height: 65,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: TextFormField(
                  cursorColor: AppConstant.appMainColor,
                  textInputAction: TextInputAction.next,
                  controller: productDescriptionController,
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      hintText: 'Product Description',
                      hintStyle: TextStyle(fontSize: 12),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)))),
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
                        // print(productId);
                        try {
                          EasyLoading.show(status: 'Please Wait...');
                          await addProductImagesController.uploadFunction(
                              addProductImagesController.selectedImage);
                          String productId =
                              await GenerateIds().generatedProductId();
                          ProductModel productModel = ProductModel(
                              productId: productId,
                              categoryId: categoryDropDownController.selectedCategoryId.toString(),
                              productName: productNameController.text.trim(),
                              categoryName: categoryDropDownController.selectedCategoryName.toString(),
                              salePrice: salePriceController.text != '' ? salePriceController.text.trim() : '',
                              fullPrice: fullPriceController.text.trim(),
                              productImages: addProductImagesController.arrImagesUrl,
                              deliveryTime: deliveryTimeController.text.trim(),
                              isSale: isSaleController.isSale.value,
                              productDescription: productDescriptionController.text.trim(),
                              createdAt: DateTime.now(),
                              updatedAt: DateTime.now());
                          print(addProductImagesController.arrImagesUrl);

                          await FirebaseFirestore.instance.collection('products').doc(productId).set(productModel.toMap());
                          EasyLoading.dismiss();
                        } catch (e) {
                          print('Error $e');
                        }
                      },
                      child: const Text(
                        'Upload',
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
  }
}
