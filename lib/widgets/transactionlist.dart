import 'package:flutter/material.dart';

import './transaction_items.dart';
import '../models/transaction.dart'; //.. lets us look in to one up folder

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTransactions;

  TransactionList(this.transactions, this.deleteTransactions);
  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? LayoutBuilder(
            builder: (ctx, constraints) {
              return Column(
                children: <Widget>[
                  Text(
                    "No entries yet!!",
                    style: Theme.of(context).textTheme.title,
                  ),
                  SizedBox(
                    height: 20,
                  ), //it is like br tag. it gives space.
                  Container(
                    height: constraints.maxHeight * 0.6,
                    child: Image.asset(
                      'assets/images/waiting.png',
                      fit: BoxFit.cover,
                    ), //fit fits the image and .cover makes it respect the boundary of the container
                  ),
                ],
              );
            },
          )
        : ListView(
            children: transactions
                .map(
                  (tx) => Transaction_Item(
                      key: ValueKey(tx.id),//UniqueKey(),
                      transaction: tx, deleteTransactions: deleteTransactions),
                ).toList(),
          );
  }
}
///////////////////////////////////
/// ListView.builder(
//   itemBuilder: (ctx, index) {
//     return Transaction_Item(transaction: transactions[index], deleteTransactions: deleteTransactions);
//   },
//   itemCount: transactions.length,
// );

///////////////////////////////////////////formerlist///////
//it returns the indexvalue of each widgit ctx is used bu flutter
// return Card(
//   elevation: 7,
//   child: Row(
//     children: <Widget>[
//       Container(
//         padding: EdgeInsets.all(10),
//         margin:
//             EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//         decoration: BoxDecoration(
//             border: Border.all(
//                 color: Theme.of(context)
//                     .primaryColorDark, //will allow us to directly get the themed color
//                 width: 2)),
//         child: Text(
//           // tx.amount.toString(),
//           "\$ ${transactions[index].amount.toStringAsFixed(2)}", //here string interpolation $(tx.amouny) makes the double value to string value
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 20,
//             color: Theme.of(context).primaryColor,
//           ),
//         ),
//       ),
//       Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Text(transactions[index].title,
//                 style: Theme.of(context).textTheme.title),
//             Text(
//               DateFormat.yMMMd()
//                   .format(transactions[index].date),
//               style: TextStyle(
//                 color: Colors.black,
//               ),
//             )
//           ])
//     ],
//   ),
// );
