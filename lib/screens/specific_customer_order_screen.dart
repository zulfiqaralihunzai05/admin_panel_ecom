import 'package:admin_panel_ecom/models/order_model.dart';
import 'package:admin_panel_ecom/utils/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import 'check_single_order_screen.dart';

class SpecificCustomerOrderScreen extends StatelessWidget {
  String docId;
  String customerName;

  SpecificCustomerOrderScreen({
    super.key,
    required this.docId,
    required this.customerName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appScendoryColor,
        iconTheme: Theme.of(context).primaryIconTheme,
        centerTitle: true,
        title: Text(
          customerName,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('orders')
            .doc(docId)
            .collection('confirmOrders')
            .orderBy('createdAt', descending: true)
            .get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Error occurred while fetching category!'),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          }
          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No Order found!'),
            );
          }

          if (snapshot.data != null) {
            return ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final data = snapshot.data!.docs[index];
                String orderDocId = data.id;

                OrderModel orderModel = OrderModel(
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
                    updatedAt: data['updatedAt'],
                    productQuantity: data['productQuantity'],
                    productTotalPrice: data['productTotalPrice'],
                    customerId: data['customerId'],
                    status: data['status'],
                    customerName: data['customerName'],
                    customerPhone: data['customerPhone'],
                    customerAddress: data['customerAddress'],
                    customerDeviceToken: data['customerDeviceToken']);

                return Card(
                  elevation: 5,
                  child: ListTile(
                    onTap: () => Get.to(
                      () => CheckSingleOrderScreen(
                        docId: snapshot.data!.docs[index].id,
                        orderModel: orderModel,
                      ),
                    ),
                    leading: CircleAvatar(
                      backgroundColor: AppConstant.appScendoryColor,
                      child: Text(orderModel.customerName[0]),
                    ),
                    title: Text(data['customerName']),
                    subtitle: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          orderModel.productName,
                          style: const TextStyle(fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        Text(orderModel.customerAddress),
                      ],
                    ),
                    trailing: GestureDetector(
                      onTap: () {
                        showBottomSheet(
                          userDocId: docId,
                          orderModel: orderModel,
                          orderDocId: orderDocId,
                        );
                      },
                      child: const Icon(Icons.arrow_forward),
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

  void showBottomSheet(
      {required String userDocId,
      required OrderModel orderModel,
      required String orderDocId}) {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      onPressed: () async {
                        EasyLoading.show(status: 'Please Wait..');
                        await FirebaseFirestore.instance
                            .collection('orders')
                            .doc(userDocId)
                            .collection('confirmOrders')
                            .doc(orderDocId)
                            .update({
                          'status': false,
                        });
                        EasyLoading.dismiss();
                      },
                      child: const Text('Pending')),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      onPressed: () async {
                        EasyLoading.show(status: 'Please Wait..');
                        await FirebaseFirestore.instance
                            .collection('orders')
                            .doc(userDocId)
                            .collection('confirmOrders')
                            .doc(orderDocId)
                            .update({
                          'status': true,
                        });
                        EasyLoading.dismiss();
                      },
                      child: const Text('Delivered')),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
