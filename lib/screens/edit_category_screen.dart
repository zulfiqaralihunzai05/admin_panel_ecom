import 'package:admin_panel_ecom/models/categories_model.dart';
import 'package:admin_panel_ecom/utils/constant.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../controller/category_dropdown_controller.dart';
import '../controller/edit_category_controller.dart';

class EditCategoryScreen extends StatelessWidget {
  CategoriesModel categoriesModel;

  EditCategoryScreen({super.key, required this.categoriesModel});

  CategoryDropDownController categoryDropDownController =
      Get.put(CategoryDropDownController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditCategoryController>(
      init: EditCategoryController(categoriesModel: categoriesModel),
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
                                imageUrl: controller.images.toString(),
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
                                        categoriesModel.categoryId);
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

                            CategoriesModel newCategoryModel = CategoriesModel(
                                categoryId: categoriesModel.categoryId,
                                categoryImg: categoriesModel.categoryImg,
                                categoryName: categoriesModel.categoryName,
                                createdAt:categoriesModel.createdAt,
                                updatedAt: DateTime.now());

                            // ProductModel newProductModel = ProductModel(
                            //     productId: productModel.productId,
                            //     categoryId: categoryDropDownController
                            //         .selectedCategoryId
                            //         .toString(),
                            //     productName: productNameController.text.trim(),
                            //     categoryName: categoryDropDownController
                            //         .selectedCategoryName
                            //         .toString(),
                            //     salePrice: salePriceController.text != ''
                            //         ? salePriceController.text.trim()
                            //         : '',
                            //     fullPrice: fullPriceController.text.trim(),
                            //     productImages: productModel.productImages,
                            //     deliveryTime:
                            //         deliveryTimeController.text.trim(),
                            //     isSale: isSaleController.isSale.value,
                            //     productDescription:
                            //         productDescriptionController.text.trim(),
                            //     createdAt: productModel.createdAt,
                            //     updatedAt: DateTime.now());

                            await FirebaseFirestore.instance
                                .collection('categories')
                                .doc(categoriesModel.categoryId)
                                .update(newCategoryModel.toMap());
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
