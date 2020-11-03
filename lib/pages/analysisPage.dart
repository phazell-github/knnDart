import 'package:flutter/material.dart';
import 'package:knn_dart/logic/types.dart';
import '../logic/knn.dart';
import '../logic/optimise.dart';
import '../logic/getdata.dart';

class AnalysisPage extends StatefulWidget {
  AnalysisPage(this.data, this.classification, this.numerics);
  final String data;
  final HeadersData classification;
  final List<HeadersData> numerics;

  @override
  _AnalysisPageState createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> {
  final _predictData = TextEditingController();
  String _result = "";

  runKnn() {
    List<int> numColumns = [];
    widget.numerics.forEach((numeric) {
      if (numeric.isNumeric) {
        numColumns.add(numeric.value);
      }
    });

    List<Datum> datums = getData(widget.data, numColumns, widget.classification.value);

    List<KAnalyzer> kValues = [];
    for (var i = 2; i < 11; i++) {
      kValues.add(KAnalyzer(i));
    }

    TrainingSet splitData = getTestData(datums);
    kValues.forEach((kValue) {
      testK(kValue, splitData);
      print("k of ${kValue.k} has pass rate of ${kValue.passRate()}, ${kValue.pass}, ${kValue.fail}");
    });

    KAnalyzer winner = getOptimumK(kValues);

    print("The optimum K is ${winner.k} with a pass rate of ${winner.passRate()}");
    List<double> queryNums = [];
    _predictData.text.split(',').forEach((element) {
      queryNums.add(double.parse(element));
    });
    Datum queryDatum = Datum(queryNums, "failed");
    classify(queryDatum, winner.k, datums);
    setState(() {
      _result = queryDatum.classification;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: Center(
      child: Column(
        children: [
          Container(
            child: TextField(
              controller: _predictData,
              decoration: InputDecoration(hintText: 'Data for test sample eg: 12.3,34.5,5.0'),
              maxLength: null,
              maxLines: 1,
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.start,
            children: [
              Text("Run KNN Algorithm"),
              RaisedButton(
                onPressed: () => runKnn(),
                child: Icon(Icons.calculate),
              )
            ],
          ),
          Container(
            child: Text("Model predicts the following classification: $_result"),
          )
        ],
      ),
    ));
  }
}
