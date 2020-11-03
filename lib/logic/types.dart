import 'package:flutter/material.dart';

class DataPoint {
  Datum datum;
  double distance;
  DataPoint(this.datum, this.distance);
}

class Datum {
  List<double> dimensions;
  String classification;
  Datum(this.dimensions, this.classification);
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
  List<Datum> test;
  List<Datum> train;
  TrainingSet(this.test, this.train);
}

class HeadersData {
  String name;
  int value;
  bool isNumeric;
  HeadersData(this.name,this.value){
    this.isNumeric = false;
  }
}
