import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

import '../services/generate_ids_service.dart';


class AddCategoryScreen extends StatelessWidget {
  AddCategoryScreen({super.key});

  final TextEditingController _controllerName = TextEditingController();

  GlobalKey<FormState> key = GlobalKey();

  final CollectionReference _reference =
  FirebaseFirestore.instance.collection('categories');

  String imageUrl = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add an item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: key,
          child: Column(
            children: [
              TextFormField(
                controller: _controllerName,
                decoration:
                const InputDecoration(hintText: 'Enter the name of the item'),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the item name';
                  }

                  return null;
                },
              ),
              IconButton(
                  onPressed: () async {

                    ImagePicker imagePicker = ImagePicker();
                    XFile? file =
                    await imagePicker.pickImage(source: ImageSource.gallery);
                    print('${file?.path}');

                    if (file == null) return;
                    //Import dart:core
                    String uniqueFileName =
                    DateTime.now().millisecondsSinceEpoch.toString();

                    //Get a reference to storage root
                    Reference referenceRoot = FirebaseStorage.instance.ref();
                    Reference referenceDirImages =
                    referenceRoot.child('categoriesImages');

                    //Create a reference for the image to be stored
                    Reference referenceImageToUpload =
                    referenceDirImages.child('categoryImg');

                    //Handle errors/success
                    try {
                      //Store the file
                      await referenceImageToUpload.putFile(File(file!.path));
                      //Success: get the download URL
                      imageUrl = await referenceImageToUpload.getDownloadURL();
                    } catch (error) {
                      //Some error occurred
                    }
                  },
                  icon: Icon(Icons.camera_alt)),
              ElevatedButton(
                  onPressed: () async {
                    if (imageUrl.isEmpty) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(const SnackBar(content: Text('Please upload an image')));

                      return;
                    }

                    if (key.currentState!.validate()) {
                      String itemName = _controllerName.text;

                      //Create a Map of data
                      String categoryId =
                      await GenerateIds().generatedCategoryId();
                      Map<String, String> dataToSend = {
                        'categoryId': categoryId,
                        'categoryImg': imageUrl,
                        'categoryName': itemName,
                        'createdAt': DateTime.now().toString(),
                        'updatedAt': DateTime.now().toString(),



                      };

                      //Add a new item
                      _reference.add(dataToSend);
                      print('Data: $dataToSend');
                    }
                  },
                  child: const Text('Upload'))
            ],
          ),
        ),
      ),
    );
  }
}