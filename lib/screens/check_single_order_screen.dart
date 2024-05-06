import 'package:admin_panel_ecom/models/order_model.dart';
import 'package:admin_panel_ecom/utils/constant.dart';
import 'package:flutter/material.dart';

class CheckSingleOrderScreen extends StatelessWidget {
  String docId;
  OrderModel orderModel;

  CheckSingleOrderScreen({
    super.key,
    required this.docId,
    required this.orderModel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Orders',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppConstant.appScendoryColor,
        centerTitle: true,
        iconTheme: Theme.of(context).primaryIconTheme,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(orderModel.productName),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(orderModel.productTotalPrice.toString()),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('x ${orderModel.productQuantity}'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(orderModel.productDescription),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                foregroundImage: NetworkImage(orderModel.productImages[0]),
              ),
              CircleAvatar(
                radius: 50,
                foregroundImage: NetworkImage(orderModel.productImages[0]),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(orderModel.customerName),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(orderModel.customerPhone),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(orderModel.customerAddress),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(orderModel.customerId),
          ),

        ],
      ),
    );
  }
}
