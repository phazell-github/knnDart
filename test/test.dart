import '../knn.dart';
import '../types.dart';
import 'package:test/test.dart';

void main() {
  test("Correct Euclid test", () {
    Flower a = Flower(6.0, 1.0, 1.4, 1.2, "Iris-setosa");
    Flower b = Flower(1.0, 4.0, 2.4, 0.2, "bumhole");
    expect(getEuclideanDistance(a, b), 6.0);
  });

  test("Nearest Neighbours test", () {
    List<Flower> flowers = [];
    flowers.add(Flower(9.9, 9.9, 9.9, 9.9, "a"));
    flowers.add(Flower(9.9, 9.9, 9.9, 9.9, "b"));
    flowers.add(Flower(9.9, 9.9, 9.9, 9.9, "c"));
    flowers.add(Flower(9.9, 9.9, 9.9, 9.9, "d"));
    flowers.add(Flower(1.1, 1.2, 1.3, 1.4, "correct"));
    Flower target = Flower(1.0, 1.0, 1.0, 1.0, "test");
    var check = getNearestNeighbours(target, 2, flowers);
    expect(check[0].flower.sepal_length, 1.1);
  });

  test("Pass rate check", () {
    var check = KAnalyzer(3);
    check.addPass();
    check.addPass();
    check.addPass();
    check.addFail();
    expect(check.passRate(), 75.0);
  });
}
