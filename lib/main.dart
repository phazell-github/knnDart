import 'package:flutter/material.dart';
import 'package:knn_dart/pages/landingPage.dart';
import './logic/getdata.dart';
import './logic/knn.dart';
import './logic/optimise.dart';
import './logic/types.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KNN Tool',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'K Nearest Neighbour Analysis Tool'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: LandingPage(),
    );
  }
}

class DataInput extends StatefulWidget {
  DataInput({Key key}) : super(key: key);
  @override
  _DataInput createState() => _DataInput();
}

class _DataInput extends State<DataInput> {
  final rawCsvController = TextEditingController();
  final numericsController = TextEditingController();
  final classificationController = TextEditingController();
  final predictData = TextEditingController();
  final result = TextEditingController();

  String classification = "";
  List<String> headers = [];
  List<String> data = [];

  findHeaders() {
    String raw = rawCsvController.text;
    data = splitData(raw);
    headers = getHeaders(data);
  }

  void runKnn() {
    findHeaders();

    List<String> numerics = numericsController.text.split(',');
    List<int> numColumns = [];
    int classificationColumn = headers.indexOf(classificationController.text);
    numerics.forEach((element) {
      numColumns.add(headers.indexOf(element));
    });

    List<Datum> datums = getData(data, numColumns, classificationColumn);

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
    predictData.text.split(',').forEach((element) {
      queryNums.add(double.parse(element));
    });
    Datum queryDatum = Datum(queryNums, "failed");
    classify(queryDatum, winner.k, datums);
    result.text = queryDatum.classification;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              child: TextField(
                controller: rawCsvController,
                decoration: InputDecoration(hintText: 'Paste in your CSV here'),
                keyboardType: TextInputType.multiline,
                maxLength: null,
                maxLines: 10,
              ),
              margin: const EdgeInsets.all(5.0),
            ),
            Container(
              child: TextField(
                controller: numericsController,
                decoration: InputDecoration(hintText: 'Define numeric columns as labelled in CSV'),
                maxLength: null,
                maxLines: 1,
              ),
            ),
            Container(
              child: TextField(
                controller: classificationController,
                decoration: InputDecoration(hintText: 'Define classification column'),
                maxLength: null,
                maxLines: 1,
              ),
            ),
            Container(
              child: TextField(
                controller: predictData,
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
              child: TextField(
                controller: result,
              ),
            )
          ],
        ),
      ),
    );
  }
}
