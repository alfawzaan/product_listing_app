import 'dart:io';

import 'package:image_picker_web_redux/image_picker_web_redux.dart';
import 'package:product_listing_app/web_specific_lib.dart';
import 'package:universal_html/html.dart' as html;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:product_listing_app/model/category_list_response.dart';
import 'package:product_listing_app/model/login_model.dart';
import 'package:product_listing_app/model/product_list_response.dart';

class Repository {
  Future<LoginModel> doUserLogin(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return LoginModel(userCredential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      return LoginModel.withError(e.message);
    }
  }

  Future<LoginModel> doRegisterUser(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return LoginModel(userCredential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      return LoginModel.withError(e.message);
    }
  }

  Future<CategoryListResponse> doGetCategoryList() async {
    List<Map<dynamic, dynamic>> catResponse = [];
    var firebaseFirestore = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot =
        await firebaseFirestore.collection('Products').get();
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      var element = querySnapshot.docs[i];
      var value = await element.reference.get();

      catResponse.add(value.data());
      debugPrint("doGetCategoryListResponse ${value.data()}");
    }
    debugPrint("DONE WITH FIREBASE");
    if (catResponse.contains(null)) {
      return CategoryListResponse.withError("Error while fetching data");
    } else {
      return CategoryListResponse.fromJson(catResponse);
    }
  }

/*
For Testing
  Future<CategoryListResponse> doGetCategoryList1() async {
    List<Map<dynamic, dynamic>> catResponse = [];
    var firebaseFirestore = FirebaseFirestore.instance;
    await firebaseFirestore.collection('Products').get().then((value) {
      value.docs.forEach((element) {
        print("doGetCategoryListResponse ${element.id}");
        var docPath = element.id;
        firebaseFirestore
            .collection('Products')
            .doc(docPath)
            .get()
            .then((value) {
          print("doGetCategoryListResponse ${value.data()}");
        });
      });
    });
  }
*/

  Future<ProductListResponse> doGetProductsList(String category) async {
    List<Map<dynamic, dynamic>> productResponse = [];
    var firebaseFirestore = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot = await firebaseFirestore
        .collection('ProductListing')
        .doc("Products")
        .collection(category)
        .get();
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      var element = querySnapshot.docs[i];
      var value = await element.reference.get();

      productResponse.add(value.data());
      debugPrint("doGetProductListResponse ${value.data()}");
    }
    debugPrint("DONE WITH FIREBASE");
    if (productResponse.contains(null)) {
      return ProductListResponse.withError("Error while fetching data");
    } else {
      return ProductListResponse.fromJson(productResponse);
    }
  }

  Future<void> updateCategory(
      FirebaseFirestore firebaseFirestore, List<dynamic> values) async {
    var catId =
        (values[2] as String).substring((values[2] as String).length - 1);
    var catName = values[2];
    DocumentReference documentReference =
        firebaseFirestore.collection('Products').doc(catId);

    print("$catId/$catName");
    await documentReference
        .set({"catId": catId, "catName": catName}, SetOptions(merge: true));
  }

  Future<void> updateProduct(FirebaseFirestore firebaseFirestore,
      List<dynamic> values, String imageUrl) async {
    DocumentReference documentReference = firebaseFirestore
        .collection('ProductListing')
        .doc('Products')
        .collection(values[2])
        .doc(values[1].toString());
    var catId =
        (values[2] as String).substring((values[2] as String).length - 1);
    print("$catId/${values[2]}");
    await documentReference.set({
      "id": values[1],
      "name": values[3],
      "image": imageUrl,
      "sellingPrice": values[4],
      "buyingPrice": values[5],
    }, SetOptions(merge: true));
  }

  Future<List<String>> uploadFile() async {
    List<String> imageUrl = [];

    if (kIsWeb) {
      // imageUrl = await doWebUpload();
      // imageUrl = await doNonWebUpload();
    } else {
      imageUrl = await doNonWebUpload();
    }
    return imageUrl;
  }

  Future<List<String>> doNonWebUpload() async {
    List<String> imageUrl = [];

    FilePickerResult result =
        await FilePicker.platform.pickFiles(allowMultiple: true);
    final files = result.files;

    for (int i = 0; i < files.length; i++) {
      var imagePath = files[i].path;
      final filename = files[i].name;

      if (imagePath == null) {
        imagePath = filename;
      }
      debugPrint("Image file1 $imagePath");
      debugPrint("Image name $filename");

      try {
        File file = File(imagePath);
        TaskSnapshot taskSnapshot = await FirebaseStorage.instance
            .ref('images/$filename')
            .putFile(file);
        final downloadLink = await taskSnapshot.ref.getDownloadURL();
        imageUrl.add(downloadLink);
      } on FirebaseException catch (e) {
        debugPrint("Upload Error");
      } catch (e, str) {
        debugPrint("Trace: $str");
        debugPrint("Trace: ${e}");
      }
    }
    return imageUrl;
  }

  Future<List<String>> doWebUpload() async {
    List<String> imageUrl = [];

    List<html.File> files =
        await  ImagePickerWeb.getMultiImages(outputType: ImageType.file);
    for (int i = 0; i < files.length; i++) {
      final filename = files[i].name;
      try {
        final reader = html.FileReader();
        reader.readAsArrayBuffer(files[i]);
        TaskSnapshot taskSnapshot = await FirebaseStorage.instance
            .ref('images/$filename')
            .putData(reader.result);
        final downloadLink = await taskSnapshot.ref.getDownloadURL();
        imageUrl.add(downloadLink);
        print("Uploaded: $downloadLink");
      } on Exception catch (e, str) {
        debugPrint("Error: $e");
        debugPrint("Trace:  $str");
      }
    }
    return imageUrl;
  }
}
