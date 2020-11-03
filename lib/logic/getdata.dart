import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'types.dart';
import 'knn.dart';
import 'optimise.dart';

Future<List<Datum>> GetDataFromFile() async {
  var file = File("../data/IRIS.csv");
  List<Datum> data = [];

  final raw = file.readAsString();
  await raw.then((contents) {
    LineSplitter ls = new LineSplitter();
    List<String> lines = ls.convert(contents);
    lines.removeAt(0);
    lines.forEach((element) {
      List row = element.split(',');

      // *** Specific to csv ***
      double sl = double.parse(row[0]);
      double sw = double.parse(row[1]);
      double pl = double.parse(row[2]);
      double pw = double.parse(row[3]);
      String type = row[4];

      data.add(Datum([sl, sw, pl, pw], type));
      // ************************
    });
  });

  return data;
}

List<String> splitData(String input) {
  LineSplitter ls = new LineSplitter();
  return ls.convert(input);
}

List<String> getHeaders(String input) {
  String headers = splitData(input)[0];
  return headers.split(',');
}

List<Datum> getData(String data, List<int> numerics, int classification) {
  List<String> input = splitData(data);
  List<Datum> output = [];
  input.removeAt(0);
  input.forEach((element) {
    List<String> row = element.split(',');
    List<double> dNumerics = [];

    numerics.forEach((n) {
      try {
        dNumerics.add(double.parse(row[n]));
      } catch (e) {
        dNumerics.add(0.0);
      }
    });

    output.add(Datum(dNumerics, row[classification]));
  });

  return output;
}

void oldmain() {
  Datum testSubject = Datum([5, 8, 5, 5], "???");

  Future<List<Datum>> data = GetDataFromFile();
  List<KAnalyzer> kValues = [];
  for (var i = 2; i < 11; i++) {
    kValues.add(KAnalyzer(i));
  }

  data.then((d) {
    TrainingSet splitData = getTestData(d);

    kValues.forEach((kValue) {
      testK(kValue, splitData);
      print("k of ${kValue.k} has pass rate of ${kValue.passRate()}, ${kValue.pass}, ${kValue.fail}");
    });

    KAnalyzer winner = getOptimumK(kValues);

    print("The optimum K is ${winner.k} with a pass rate of ${winner.passRate()}");

    classify(testSubject, winner.k, d);
  }).then((value) => print(testSubject.classification));
}
