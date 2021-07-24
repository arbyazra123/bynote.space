import 'package:flutter_test/flutter_test.dart';

void main() {
  test("PROFIT 1", () {
    var saving = 250;
    var currentValue = [175, 133, 109, 210, 97, 2, 1];
    var futureValue = [200, 125, 128, 228, 133, 110, 100];
    calculate(currentValue, futureValue, saving);
  });
}

void calculate(List<int> a, List<int> b, int saving) {
  var highests = [];

  //menghitung list harga saham dibawah harga saving
  for (var i = 0; i < a.length; i++) {
    for (var x = i + 1; x < a.length; x++) {
      int next = a[x] + a[i];
      if (next <= saving) {
        if (b[i] > a[i]) highests.add([next, i, x]);
      }
    }
  }
  print("List harga saham dibawah saving : " + highests.toString());

  //Menghitung profit tertinggi
  var buyAt = 0;
  var result = [0, 0, 0];
  for (var i = 0; i < highests.length; i++) {
    var endYearSold = b[highests[i][1]] + b[highests[i][2]];
    var currentBuyAt = a[highests[i][1]] + a[highests[i][2]];
    var totalProfit = endYearSold - currentBuyAt;
    if (totalProfit > result[0]) {
      var nextBuyAt = buyAt + currentBuyAt;
      if (nextBuyAt <= saving) {
        buyAt = nextBuyAt;
      }
      result = [totalProfit, highests[i][1], highests[i][2]];
    }
  }
  print("current buy stock at : ${a[result[1]]} + ${a[result[2]]} = $buyAt");
  var endYearSold = b[result[1]] + b[result[2]];
  print(
      "future profit : ${b[result[1]]} + ${b[result[2]]} = $endYearSold ,so total profit is $endYearSold - ${buyAt} = ${result[0]}");
}
