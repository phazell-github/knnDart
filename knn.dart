import 'dart:ffi';
import 'dart:io';
import 'dart:async';
import 'dart:convert';

enum Species {setosa, versicolor, virginica}

class Flower {
  double sepal_length;
  double sepal_width;
  double petal_length;
  double petal_width;
  Species classification;

  Flower(this.sepal_length,this.sepal_width,this.petal_length,this.petal_width,String species) {
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

      data.add(Flower(sl,sw,pl,pw,type));      
    });
  }); 

  return data;
}

void main(){
  Flower a = Flower(5.1,3.5,1.4,0.2,"Iris-setosa");
  Flower b = Flower(4.9,3,1.4,0.2,"bumhole");
  a.describe();
  b.describe();

  Future<List<Flower>> flowers = GetData();
  flowers.then((value) => value[97].describe());
}