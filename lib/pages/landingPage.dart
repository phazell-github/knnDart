import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'dart:typed_data';
import 'dart:async';
import 'dart:convert';
import 'package:http_parser/http_parser.dart';
import 'package:knn_dart/pages/defineParameters.dart';
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
  List<HeadersData> _headers =[];
  List<DropdownMenuItem<HeadersData>> _dropDownItems = [];
  HeadersData _classificationColumn = HeadersData("Init", 0);
  List<CheckboxListTile> _numericColumns = [];
 
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

  moveToRunTest() {    
    Navigator.push(
      context, MaterialPageRoute(
      builder: (context) => DefineParameters(this._fileContents,getHeadersData()),
    ));    
  }

  getParameters(){
    setState(() {
      _headers = getHeadersData();
      buildDropDownItems();  
    });
    
    //buildCheckBoxes();
  }

  

  buildDropDownItems() {       
      _headers.forEach((h) { 
      _dropDownItems.add(
        DropdownMenuItem(child: Text(h.name),value: h)
        );
      });
      _classificationColumn = _dropDownItems[0].value;     
  }


  List<HeadersData> getHeadersData(){
    List<HeadersData> output = [];
    List<String> headers = getHeaders(this._fileContents);
    for (var i = 0; i < headers.length; i++) {
      output.add(
        HeadersData(headers[i], i)
      );
    }
    return output;
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
                color: Colors.lightBlueAccent,
                elevation: 8,
                highlightElevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),                  
                ),
                textColor: Colors.white,
                child: Text("Select a file"),
                onPressed: () => webFilePicker(),
              ),
            ),
            Container(
              child: MaterialButton(
                color: Colors.lightBlueAccent,
                elevation: 8,
                highlightElevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),                  
                ),
                textColor: Colors.white,
                child: Text("Get Parameters"),
                onPressed: () => getParameters(),
              )
            ),
            Row(
              children: [
                Text("Select Classification Column"),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.cyan,
                    border: Border.all()
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<HeadersData>(                
                      value: _classificationColumn,
                      items: _dropDownItems,
                      onChanged: (value) {
                        setState(() {
                          _classificationColumn = value;
                        });
                      },
                    ),
                  ),
                ),                
              ],
            ),
            Column(
              children: [
                Text("Select Numeric parameters;"),

              ],
            )
          ],
        )
      ),
    );
  }
}