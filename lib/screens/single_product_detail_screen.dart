import 'package:admin_panel_ecom/models/product_model.dart';
import 'package:admin_panel_ecom/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SingleProductDetailsScreen extends StatelessWidget {
  ProductModel productModel;
  SingleProductDetailsScreen({super.key, required this.productModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appScendoryColor,
        centerTitle: true,
        iconTheme: Theme.of(context).primaryIconTheme,
        title: Text(productModel.productName, style: TextStyle(color: Colors.white),),
      ),
      body: Container(
        child: Column(
          children: [
            Card(
              elevation: 10,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Product Name "),
                        Container(
                          width: Get.width / 2,
                          child: Text(productModel.productName,
                          overflow: TextOverflow.ellipsis,),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Product Price "),
                        Container(
                          width: Get.width / 2,
                          child: Text(productModel.salePrice != ''? productModel.salePrice : productModel.fullPrice,
                          overflow: TextOverflow.ellipsis,),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Delivery Time "),
                        Container(
                          width: Get.width / 2,
                          child: Text(productModel.deliveryTime,
                          overflow: TextOverflow.ellipsis,),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("isSale"),
                        Container(
                          width: Get.width / 2,
                          child: Text(productModel.isSale ? 'true' : 'false',
                          overflow: TextOverflow.ellipsis,),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Description "),
                        Container(
                          width: Get.width / 2,
                          child: Text(productModel.productDescription,
                          overflow: TextOverflow.ellipsis,maxLines: 3,),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
