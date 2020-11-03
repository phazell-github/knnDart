 import 'package:flutter/material.dart';
 import '../logic/types.dart';
 import '../logic/getdata.dart';
 
 class DefineParameters extends StatefulWidget {
  DefineParameters(this.dataString, this.headers); 
  final String dataString;
  final List<HeadersData> headers;  

   @override
   _DefineParameters createState() => _DefineParameters();
 }

 class _DefineParameters extends State<DefineParameters> { 
   List<DropdownMenuItem<HeadersData>> _dropDownItems;
   HeadersData _selectedItem;
  
  void initState(){
    super.initState();
    _dropDownItems = buildDropDownItems();
    _selectedItem = _dropDownItems[0].value;
  }

  List<DropdownMenuItem<HeadersData>> buildDropDownItems() {
    List<DropdownMenuItem<HeadersData>> output = [];
    widget.headers.forEach((h) { 
      output.add(
        DropdownMenuItem(child: Text(h.name),value: h)
      );
    });
  }

   
   @override
   Widget build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(
         title: Text("Define the parameters to use"),
       ),
       body: Center(child:
         Column(
           children: [             
              Text(widget.headers.length.toString()),
              
           ],
         )
       )
     );
   }
 }