import 'package:admin_panel_ecom/controller/category_dropdown_controller.dart';
import 'package:admin_panel_ecom/models/product_model.dart';
import 'package:admin_panel_ecom/screens/add_products_screen.dart';
import 'package:admin_panel_ecom/screens/edit_product_screen.dart';
import 'package:admin_panel_ecom/screens/single_product_detail_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:get/get.dart';
import '../controller/is_sale_controller.dart';
import '../utils/constant.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AllProductsScreen extends StatefulWidget {
  const AllProductsScreen({super.key});

  @override
  State<AllProductsScreen> createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends State<AllProductsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: Theme
            .of(context)
            .primaryIconTheme,
        title: const Text(
          'All Products',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppConstant.appMainColor,
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(
                onTap: () => Get.to(() => AddProductsScreen()),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                )),
          )
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('products')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Error occurred while fetching product!'),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          }
          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No Product found!'),
            );
          }

          if (snapshot.data != null) {
            return ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final data = snapshot.data!.docs[index];

                ProductModel productModel = ProductModel(
                    productId: data['productId'],
                    categoryId: data['categoryId'],
                    productName: data['productName'],
                    categoryName: data['categoryName'],
                    salePrice: data['salePrice'],
                    fullPrice: data['fullPrice'],
                    productImages: data['productImages'],
                    deliveryTime: data['deliveryTime'],
                    isSale: data['isSale'],
                    productDescription: data['productDescription'],
                    createdAt: data['createdAt'],
                    updatedAt: data['updatedAt']);

                return SwipeActionCell(
                  key: ObjectKey(productModel.productId),
                  trailingActions: <SwipeAction>[
                    SwipeAction(
                      title: 'Delete',
                      onTap: (CompletionHandler handler) async {
                        await Get.defaultDialog(
                          title: 'Delete Product',
                          content: const Text(
                              'Are you sure you want delete this product'),
                          textCancel: 'Cancel',
                          textConfirm: 'Delete',
                          contentPadding: EdgeInsets.all(10),
                          confirmTextColor: Colors.white,
                          onCancel: () {},
                          onConfirm: () async {
                            Get.back();
                            EasyLoading.show(status: 'Please Wait..');
                            await deleteImagesFromFirebase(
                                productModel.productImages);

                            await FirebaseFirestore.instance
                                .collection('products')
                                .doc(productModel.productId)
                                .delete();
                            EasyLoading.dismiss();
                          },
                          buttonColor: Colors.red,
                          cancelTextColor: Colors.black,
                        );
                      },
                      color: Colors.red,
                    )
                  ],
                  child: Card(
                    elevation: 5,
                    child: ListTile(
                      onTap: () =>
                          Get.to(
                                () =>
                                SingleProductDetailsScreen(
                                    productModel: productModel),
                          ),
                      leading: CircleAvatar(
                        backgroundColor: AppConstant.appScendoryColor,
                        backgroundImage: CachedNetworkImageProvider(
                          productModel.productImages[0],
                          errorListener: (err) {
                            // Handle the error here
                            print('Error loading image');
                            const Icon(Icons.error);
                          },
                        ),
                      ),
                      title: Text(productModel.productName),
                      subtitle: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            productModel.fullPrice,
                            style: const TextStyle(fontSize: 12),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          Text(productModel.deliveryTime),
                        ],
                      ),
                      trailing: GestureDetector(
                        onTap: () {
                          final editProductCategory =
                          Get.put(CategoryDropDownController());
                          final isSaleController = Get.put(IsSaleController());
                          editProductCategory
                              .setOldValue(productModel.categoryId);
                          isSaleController
                              .setIsSaleOldValue(productModel.isSale);

                          Get.to(() =>
                              EditProductScreen(productModel: productModel));
                        },
                        child: const Icon(Icons.edit),
                      ),
                    ),
                  ),
                );
              },
            );
          }

          return Container();
        },
      ),
    );
  }

  Future deleteImagesFromFirebase(List imageUrls) async {
    final FirebaseStorage storage = FirebaseStorage.instance;

    for (String imageUrl in imageUrls) {
      try {
        Reference reference = storage.refFromURL(imageUrl);
        await reference.delete();
      } catch (e) {
        print('Error $e');
      }
      }
    }
  }
