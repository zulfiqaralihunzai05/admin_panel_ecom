import 'package:admin_panel_ecom/models/categories_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

class EditCategoryController extends GetxController {
  CategoriesModel categoriesModel;

  EditCategoryController({
    required this.categoriesModel,
  });

  RxList<String> images = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    getRealTimeImages();
  }

  void getRealTimeImages() {
    FirebaseFirestore.instance
        .collection('categories')
        .doc(categoriesModel.categoryId)
        .snapshots()
        .listen((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>?;
        if (data != null && data['categoryImg'] != null) {
          images.value =
              List<String>.from(data['categoryImg'] as List<dynamic>);
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
      await FirebaseFirestore.instance.collection('categories').doc(productId).update(
        {'categoryImg' : FieldValue.arrayRemove([imageUrl])}
      );
      update();
    }catch (e){
      print('Error $e');
    }
  }
}
