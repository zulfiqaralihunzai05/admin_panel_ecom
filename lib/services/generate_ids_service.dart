

import 'package:uuid/uuid.dart';

class GenerateIds{

  String generatedProductId(){
    String formatedProductId;
    String uuid = const Uuid().v4();

    formatedProductId = 'admin_panel_ecom-${uuid.substring(0, 5)}';

    return formatedProductId;
  }
  String generatedCategoryId(){
    String formatedCategoryId;
    String uuid = const Uuid().v4();

    formatedCategoryId = 'admin_panel_ecom-${uuid.substring(0, 8)}';

    return formatedCategoryId;
  }

}