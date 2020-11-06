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
      _result = "The optimum K is ${winner.k} with a pass rate of ${winner.passRate()}\n\n" +
          "Model predicts the following classification: \n" +
          queryDatum.classification;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            child: TextField(
              controller: _predictData,
              decoration: InputDecoration(hintText: 'Prediction data eg: 12.3,34.5,5.0', border: const OutlineInputBorder(gapPadding: 4.0)),
              maxLength: null,
              maxLines: 1,
            ),
            margin: const EdgeInsets.fromLTRB(20, 25, 20, 15)),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            // File Uploader
            child: MaterialButton(
              color: Colors.lightBlueAccent,
              elevation: 8,
              highlightElevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              textColor: Colors.white,
              child: Text("Predict Classification"),
              onPressed: () => runKnn(),
            ),
          ),
        ),
        Container(
          child: Text(_result),
        )
      ],
    );
  }
}
