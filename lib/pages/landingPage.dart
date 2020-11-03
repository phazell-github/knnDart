import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'dart:typed_data';
import 'dart:async';
import 'dart:convert';
import 'package:http_parser/http_parser.dart';
import 'dart:io';
import '../logic/types.dart';
import '../logic/getdata.dart';

class LandingPage extends StatefulWidget {
  LandingPage({Key key}) : super(key: key);
  
  @override    
  _LandingPage createState() => _LandingPage();  
}

class _LandingPage extends State<LandingPage> {
  String _fileContents = 'Unknown';
 
  webFilePicker() async {
    html.InputElement uploadInput = html.FileUploadInputElement();
    uploadInput.multiple = false;
    uploadInput.draggable = true;
    uploadInput.click();

    uploadInput.onChange.listen((e) {
      var files = uploadInput.files;
      var file = files[0];
      final reader = html.FileReader();
      reader.readAsText(file);
      reader.onLoadEnd.listen((e) {
        setState(() {          
          _fileContents = reader.result.toString();
        });
       });
     });
  }


  @override  
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Center(
        child: Column(
          children: [
            Container(
              // File Uploader
              child: MaterialButton(
                child: Text("Select a file"),
                onPressed: () => webFilePicker(),
              ),
            ),
            Container(
              child: MaterialButton(
                child: Text("Select classification")
              )
            ),
          ],
        )
      ),
    );
  }
}