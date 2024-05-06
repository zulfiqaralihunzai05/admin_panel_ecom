import 'package:admin_panel_ecom/screens/edit_category_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:get/get.dart';
import '../models/categories_model.dart';
import '../utils/constant.dart';
import 'add_category_screen.dart';
import 'add_products_screen.dart';

class AllCategoriesScreen extends StatelessWidget {
  const AllCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: Theme.of(context).primaryIconTheme,
        title: const Text(
          'All Categories',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppConstant.appMainColor,
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(
                onTap: () => Get.to(() => AddCategoryScreen()),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                )),
          )
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('categories')
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
              child: Text('No Category found!'),
            );
          }

          if (snapshot.data != null) {
            return ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final data = snapshot.data!.docs[index];

                CategoriesModel categoriesModel = CategoriesModel(
                    categoryId: data['categoryId'],
                    categoryImg: data['categoryImg'],
                    categoryName: data['categoryName'],
                    createdAt: data['createdAt'],
                    updatedAt: data['updatedAt']);

                return SwipeActionCell(
                  key: ObjectKey(categoriesModel.categoryId),
                  trailingActions: <SwipeAction>[
                    SwipeAction(
                      title: 'Delete',
                      onTap: (CompletionHandler handler) async {
                        await Get.defaultDialog(
                          title: 'Delete Category',
                          content: const Text(
                              'Are you sure you want delete this category'),
                          textCancel: 'Cancel',
                          textConfirm: 'Delete',
                          contentPadding: EdgeInsets.all(10),
                          confirmTextColor: Colors.white,
                          onCancel: () {},
                          onConfirm: () async {
                            Get.back();
                            EasyLoading.show(status: 'Please Wait..');
                            // await deleteImagesFromFirebase(
                            //     categoriesModel.categoryImg[0]);
                            //
                            // await FirebaseFirestore.instance
                            //     .collection('categories')
                            //     .doc(categoriesModel.categoryId)
                            //     .delete();
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
                      onTap: () {},
                      leading: CircleAvatar(
                        backgroundColor: AppConstant.appScendoryColor,
                        backgroundImage: CachedNetworkImageProvider(
                          categoriesModel.categoryImg,
                          errorListener: (err) {
                            // Handle the error here
                            print('Error loading image');
                            const Icon(Icons.error);
                          },
                        ),
                      ),
                      title: Text(categoriesModel.categoryName),
                      subtitle: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            categoriesModel.categoryId,
                            style: const TextStyle(fontSize: 12),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ],
                      ),
                      trailing: GestureDetector(
                        onTap: () {
                          // editProductCategory
                          //     .setOldValue(productModel.categoryId);

                          Get.to(() =>
                              EditCategoryScreen(categoriesModel: categoriesModel));
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
