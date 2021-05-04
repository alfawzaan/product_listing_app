// import 'dart:html';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:product_listing_app/constants.dart';
import 'package:product_listing_app/model/category_model.dart';
import 'package:product_listing_app/repository/repository.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';

class ExcelUploadScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ExcelUploadScreenState();
  }
}

class ExcelUploadScreenState extends State<ExcelUploadScreen> {
  String lastExcelPath = "";
  List<String> imageUrl = [];
  Repository _repository = Repository();
  bool showProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Data upload"),
      ),
      body: Align(
          alignment: Alignment.center, child: fileSelectBuildComposer(context)),
    );
  }

  Widget fileSelectBuildComposer(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        InkWell(
          child: textClick(
              "Select images In their right order", Colors.green, 0.05),
          onTap: () {
            doCallUpload();
          },
        ),
        showProgress ? ScalingText('Uploading Images...') : Container(),
        imageUrl.length > 0
            ? InkWell(
                child: textClick(
                    "Click here to select the excel file", Colors.green, 0.05),
                onTap: () async {
                  FilePickerResult result =
                      await FilePicker.platform.pickFiles();

                  if (result != null) {
                    // print(result.files.single.path);
                    // File file = File(result.files.single.path);
                    await extractContent(result.files.single);
                  } else {
                    // User canceled the picker
                  }
                },
              )
            : Container(),
      ],
    );
  }

  Future<void> extractContent(PlatformFile filePath) async {
    Uint8List bytes;
    if(kIsWeb){
      debugPrint("Reading RAW file");
      // bytes = File.fromRawPath(filePath.bytes).readAsBytesSync();
      bytes = filePath.bytes;
    }else{
      debugPrint("Reading main file");
      bytes = File(filePath.path).readAsBytesSync();
    }

    try {
      var decoder = SpreadsheetDecoder.decodeBytes(bytes, update: true);
      debugPrint("Decoding Spreadsheet");

      var tables = decoder.tables;
      debugPrint("Reading Tables");
      var firebaseFirestore = FirebaseFirestore.instance;
      tables.forEach((key, value) async {
        var rows = value.rows;
        for (int i = 1; i < rows.length; i++) {
          var values = rows[i];
          debugPrint("About to Upload: $values");
          await _repository.updateCategory(firebaseFirestore, values);
          await _repository.updateProduct(firebaseFirestore, values, imageUrl[i-1]);
        }
        setState(() {
          imageUrl = [];
        });
      });
    } on Exception catch (e, str) {
      debugPrint("Exception: ${e}");
      debugPrint("Exception: ${str}");

    }
  }

  Future<void> doCallUpload() async {
    setState(() {
      showProgress = true;
    });
    _repository.uploadFile().then((value) {
      setState(() {
        imageUrl = value;
        showProgress = false;
        debugPrint("Finish Uploading");
      });
    });
  }
}
