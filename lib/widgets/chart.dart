import 'package:RoutineCheckonVisitor/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import './chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> resentTransactions;

  Chart(this.resentTransactions);

  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7,(index) {
        final weekday = DateTime.now().subtract(
          Duration(days: index),
        ); //subtract deducts the amount of time, here it is index whic means day value
        double totalSum = 0.0;
        for (var i = 0; i < resentTransactions.length; i++) {
          if (resentTransactions[i].date.day == weekday.day &&
              resentTransactions[i].date.month == weekday.month &&
              resentTransactions[i].date.year == weekday.year) {
            totalSum += resentTransactions[i].amount;
          }
        }
        // print(DateFormat.E().format(weekday));
        // print(totalSum);
        return {
          'day': DateFormat.E().format(weekday).substring(0, 1),
          'amount': totalSum,
        }; //DateFormat is in intl package and .E gives T for tuesday etc
      },
    ).reversed.toList(); // .generate generates a new list of length here 7 following generator fuction. index is the index of the list
  }

  double get totalmaxSpending {
    return groupedTransactionValues.fold(0.0, (sum, item) {
      return sum + item['amount'];
    });
  } //fold help us to convert a list to other value as per our function

  @override
  Widget build(BuildContext context) {
    // print(groupedTransactionValues);
    return Card(
      elevation: 10,
      margin: EdgeInsets.all(20),
      child: Container(
        height: MediaQuery.of(context).size.height *0.4,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: groupedTransactionValues.map((data) {
              return Flexible(
                //flex: ,
                fit: FlexFit
                    .tight, //it makes sure that data doesn't overflow and chart is alligned
                child: ChartBar(
                  data['day'],
                  data['amount'],
                  totalmaxSpending == 0
                      ? totalmaxSpending
                      : (data['amount'] as double) / totalmaxSpending,
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
