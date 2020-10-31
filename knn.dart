import 'dart:math';
import 'types.dart';

void classify(Flower f, int k, List<Flower> data) {
  List<DataPoint> nearest_neighbours = getNearestNeighbours(f, k, data);
  f.classification = getClassification(nearest_neighbours);
}

double getEuclideanDistance(Flower a, Flower b) {
  return sqrt((pow((a.petal_length - b.petal_length), 2)) +
      (pow((a.petal_width - b.petal_width), 2)) +
      (pow((a.sepal_length - b.sepal_length), 2)) +
      (pow((a.sepal_width - b.sepal_width), 2)));
}

List<DataPoint> getNearestNeighbours(Flower f, int k, List<Flower> data) {
  List<DataPoint> distances = data.map((e) {
    return DataPoint(e, getEuclideanDistance(f, e));
  }).toList();

  distances.sort((a, b) => Comparable.compare(a.distance, b.distance));

  return distances.sublist(0, (k - 1));
}

Species getClassification(List<DataPoint> neighbours) {
  var tally = {Species.setosa: 0, Species.versicolor: 0, Species.virginica: 0};
  neighbours.forEach((element) {
    switch (element.flower.classification) {
      case Species.setosa:
        tally[Species.setosa] += 1;
        break;
      case Species.versicolor:
        tally[Species.versicolor] += 1;
        break;
      case Species.virginica:
        tally[Species.virginica] += 1;
        break;
      default:
    }
  });

  Species verdict;
  int winner = 0;
  tally.forEach((key, value) {
    if (value > winner) {
      verdict = key;
    }
  });

  return verdict;
}
