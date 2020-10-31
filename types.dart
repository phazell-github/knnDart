enum Species { setosa, versicolor, virginica, undefined }

class Flower {
  double sepal_length;
  double sepal_width;
  double petal_length;
  double petal_width;
  Species classification;

  Flower(this.sepal_length, this.sepal_width, this.petal_length,
      this.petal_width, String species) {
    switch (species) {
      case "Iris-setosa":
        this.classification = Species.setosa;
        break;
      case "Iris-versicolor":
        this.classification = Species.versicolor;
        break;
      case "Iris-virginica":
        this.classification = Species.virginica;
        break;
      default:
    }
  }

  void describe() {
    print(this.classification ?? "undefined");
  }
}

class DataPoint {
  Flower flower;
  double distance;
  DataPoint(this.flower, this.distance);
}

class KAnalyzer {
  int k;
  int pass;
  int fail;

  KAnalyzer(this.k) {
    this.pass = 0;
    this.fail = 0;
  }

  void addPass() {
    this.pass += 1;
  }

  void addFail() {
    this.fail += 1;
  }

  double passRate() {
    return (this.pass / (this.pass + this.fail)) * 100.0;
  }
}

class TrainingSet {
  List<Flower> test;
  List<Flower> train;
  TrainingSet(this.test, this.train);
}
