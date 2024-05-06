import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class CategoryDropDownController extends GetxController {
  RxList<Map<String, dynamic>> categories = <Map<String, dynamic>>[].obs;
  RxString? selectedCategoryId;
  RxString? selectedCategoryName;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchCategories();
  }
  Future<void> fetchCategories() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('categories').get();

      List<Map<String, dynamic>> categoriesList = [];
      querySnapshot.docs.forEach(
        (DocumentSnapshot<Map<String, dynamic>> document) {
          categoriesList.add(
            {
              'categoryId': document.id,
              'categoryName': document['categoryName'],
              'categoryImg': document['categoryImg'],
            },
          );
        },
      );
      categories.value = categoriesList;
      print('Categories $categoriesList');
      update();
    } catch (e) {
      print('Error $e');
    }
  }

  void setSelectedCategory(String? categoryId){
    selectedCategoryId = categoryId?.obs;
    print('selected category is: $selectedCategoryId');
    update();
  }

  Future<String?> getCategoryName(String? categoryId) async{
    try{
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance.collection('categories').doc(categoryId).get();
      if(snapshot.exists){
        return snapshot.data()?['categoryName'];
      }else{
        return null;
      }
    }catch(e){
      print('Error $e');
      return null;
    }
  }
// set category Name
  void setCategoryName(String? categoryName){
    selectedCategoryName = categoryName?.obs;
    print('selected category name: $selectedCategoryName');
    update();
  }

  // set old
  void setOldValue(String? categoryId){
    selectedCategoryId = categoryId?.obs;
    print('selected category id: $selectedCategoryId');
    update();
  }


}
