import 'package:admin_panel_ecom/models/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

class EditProductController extends GetxController {
  ProductModel productModel;

  EditProductController({
    required this.productModel,
  });

  RxList<String> images = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    getRealTimeImages();
  }

  void getRealTimeImages() {
    FirebaseFirestore.instance
        .collection('products')
        .doc(productModel.productId)
        .snapshots()
        .listen((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>?;
        if (data != null && data['productImages'] != null) {
          images.value =
              List<String>.from(data['productImages'] as List<dynamic>);
          update();
        }
      }
    });
  }

  Future deleteImagesFromStorage(String imageUrl) async {
    final FirebaseStorage storage = FirebaseStorage.instance;
    try {
      Reference reference = storage.refFromURL(imageUrl);
      await reference.delete();
    } catch (e) {
      print('Error $e');
    }
  }

  Future<void> deleteImagesFromFireStore(String imageUrl, String productId) async {
    try{
      await FirebaseFirestore.instance.collection('products').doc(productId).update(
        {'productImages' : FieldValue.arrayRemove([imageUrl])}
      );
      update();
    }catch (e){
      print('Error $e');
    }
  }
}
