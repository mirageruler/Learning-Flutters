import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import '../widgets/chart_bar.dart';
import '../models/transaction.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  /// Just to receive transactions from the last 7 weekdays from where an object of this class is instantiated.
  Chart(this.recentTransactions) {
    print('Constructor Chart');
  }

  /// A getter to generate 7 bars dynamically base on the last 7 weekdays count from the current day.
  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      /// Simply find out which weekday I'm currently generating for the last 7 days up to the current day.
      /// So I decide to subtract the current day to index (0 up to 6 and treated as days),
      /// then I will have a list of 7 items/bars with the [weekDay] value exactly from the current day all the way up to one week ago.
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );
      double totalSum = 0.0;

      /// Simply a For loop to sum up all the amount of a specific/given week day (For accuracy, I also compare the month and year).
      for (var i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == weekDay.day &&
            recentTransactions[i].date.month == weekDay.month &&
            recentTransactions[i].date.year == weekDay.year) {
          totalSum += recentTransactions[i].amount;
        }
      }
      return {
        'day': DateFormat.E().format(weekDay),
        'amount': totalSum,
      };
    }).reversed.toList();
  }

  double get totalSpending {
    return groupedTransactionValues.fold(0.0, (sum, item) {
      return sum + item['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    print('build() Chart');
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Container(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactionValues.map((data) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                  data['day'],
                  data['amount'],
                  totalSpending == 0.0
                      ? 0.0
                      : (data['amount'] as double) / totalSpending),
            );
          }).toList(),
        ),
      ),
    );
  }
}
