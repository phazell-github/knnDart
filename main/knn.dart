import 'dart:math';
import 'types.dart';

void classify(Datum datum, int k, List<Datum> data) {
  List<DataPoint> nearest_neighbours = getNearestNeighbours(datum, k, data);
  datum.classification = getClassification(nearest_neighbours);
}

double getEuclideanDistance(Datum a, Datum b) {
  int nDimensions = a.dimensions.length;
  List<double> distances = [];
  for (var i = 0; i < nDimensions; i++) {
    distances.add(pow((a.dimensions[i] - b.dimensions[i]), 2));
  }
  return sqrt(
      (distances.fold(0, (previousValue, element) => previousValue + element)));
}

List<DataPoint> getNearestNeighbours(Datum f, int k, List<Datum> data) {
  List<DataPoint> distances = data.map((e) {
    return DataPoint(e, getEuclideanDistance(f, e));
  }).toList();

  distances.sort((a, b) => Comparable.compare(a.distance, b.distance));

  return distances.sublist(0, (k - 1));
}

String getClassification(List<DataPoint> neighbours) {
  var tally = {};
  neighbours.forEach((element) {
    if (tally.containsKey(element.datum.classification)) {
      tally[element.datum.classification] += 1;
    } else {
      tally[element.datum.classification] = 1;
    }
  });

  String verdict;
  int winner = 0;
  tally.forEach((key, value) {
    if (value > winner) {
      verdict = key;
    }
  });

  return verdict;
}
