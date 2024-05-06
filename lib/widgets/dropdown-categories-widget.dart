import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/category_dropdown_controller.dart';

class DropDownCategoriesWidget extends StatelessWidget {
  const DropDownCategoriesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoryDropDownController>(
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
                    value:
                    categoriesDropDownController.selectedCategoryId?.value,
                    items:
                    categoriesDropDownController.categories.map((category) {
                      return DropdownMenuItem<String>(
                        value: category['categoryId'],
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(
                                category['categoryImg'].toString(),
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
                      String? categoryName = await categoriesDropDownController
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
    );
  }
}
