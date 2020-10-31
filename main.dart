import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'types.dart';
import 'knn.dart';
import 'optimise.dart';

Future<List<Flower>> GetData() async {
  var file = File("./IRIS.csv");
  List<Flower> data = [];

  final raw = file.readAsString();
  await raw.then((contents) {
    LineSplitter ls = new LineSplitter();
    List<String> lines = ls.convert(contents);
    lines.removeAt(0);
    lines.forEach((element) {
      List row = element.split(',');
      double sl = double.parse(row[0]);
      double sw = double.parse(row[1]);
      double pl = double.parse(row[2]);
      double pw = double.parse(row[3]);
      String type = row[4];

      data.add(Flower(sl, sw, pl, pw, type));
    });
  });

  return data;
}

void main() {
  Flower testFlower = Flower(5, 8, 5, 5, "???");
  Future<List<Flower>> flowers = GetData();
  List<KAnalyzer> kValues = [];
  for (var i = 2; i < 11; i++) {
    kValues.add(KAnalyzer(i));
  }

  flowers.then((data) {
    TrainingSet splitData = getTestData(data);

    kValues.forEach((kValue) {
      testK(kValue, splitData);
      print(
          "k of ${kValue.k} has pass rate of ${kValue.passRate()}, ${kValue.pass}, ${kValue.fail}");
    });

    KAnalyzer winner = getOptimumK(kValues);

    print(
        "The optimum K is ${winner.k} with a pass rate of ${winner.passRate()}");

    classify(testFlower, winner.k, data);
  }).then((value) => testFlower.describe());
}
