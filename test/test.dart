import '../main/knn.dart';
import '../main/types.dart';
import 'package:test/test.dart';

void main() {
  test("Correct Euclid test", () {
    Datum a = Datum([6.0, 1.0, 1.4, 1.2], "Iris-setosa");
    Datum b = Datum([1.0, 4.0, 2.4, 0.2], "bumhole");
    expect(getEuclideanDistance(a, b), 6.0);
  });

  test("Nearest Neighbours test", () {
    List<Datum> flowers = [];
    flowers.add(Datum([9.9, 9.9, 9.9, 9.9], "a"));
    flowers.add(Datum([9.9, 9.9, 9.9, 9.9], "b"));
    flowers.add(Datum([9.9, 9.9, 9.9, 9.9], "c"));
    flowers.add(Datum([9.9, 9.9, 9.9, 9.9], "d"));
    flowers.add(Datum([1.1, 1.2, 1.3, 1.4], "correct"));
    Datum target = Datum([1.0, 1.0, 1.0, 1.0], "test");
    var check = getNearestNeighbours(target, 2, flowers);
    expect(check[0].datum.dimensions[0], 1.1);
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
