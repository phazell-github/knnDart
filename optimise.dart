import 'types.dart';
import 'knn.dart';

TrainingSet getTestData(List<Flower> rawData) {
  rawData.shuffle();
  int splitAt = ((rawData.length) / 10).floor().toInt();

  List<Flower> test = rawData.getRange(0, splitAt).toList();
  rawData.removeRange(0, splitAt);

  return TrainingSet(test, rawData);
}

void testK(KAnalyzer kAnalyzer, TrainingSet trainingSet) {
  trainingSet.test.forEach((flower) {
    Species real = flower.classification;
    flower.classification = Species.undefined;

    classify(flower, kAnalyzer.k, trainingSet.train);

    if (flower.classification == real) {
      kAnalyzer.addPass();
    } else {
      kAnalyzer.addFail();
    }
  });
}

KAnalyzer getOptimumK(List<KAnalyzer> candidates) {
  return candidates.fold(candidates[0], (previousValue, element) {
    if (previousValue.passRate() > element.passRate()) {
      return previousValue;
    } else {
      return element;
    }
  });
}
