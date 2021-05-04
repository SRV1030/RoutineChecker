import 'package:flutter/material.dart';

import 'dart:math';

import 'package:intl/intl.dart';
import '../models/transaction.dart';

class Transaction_Item extends StatefulWidget {
  const Transaction_Item({
    Key key,
    @required this.transaction,
    @required this.deleteTransactions,
  }) : super(key: key);//super(key:key) it allows us to add keys from transactoion_item

  final Transaction transaction;
  final Function deleteTransactions;

  @override
  _Transaction_ItemState createState() => _Transaction_ItemState();
}

class _Transaction_ItemState extends State<Transaction_Item> {
  
  Color  _bgColor;
  @override
  void initState() {
    // TODO: implement initState    
    const avilablecolors=[Colors.black,Colors.purple,Colors.amber];
    _bgColor =avilablecolors[Random().nextInt(3)];//next int random generates random numbers with max value 3
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 8),
      elevation: 6,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _bgColor,
          radius: 30,
          child: Padding(
            padding: EdgeInsets.all(6),
            child: FittedBox(
                child: Text(
                    "\$${widget.transaction.amount.toStringAsFixed(2)}")),
          ),
        ),
        title: Text(widget.transaction.title,
            style: Theme.of(context).textTheme.title),
        subtitle: Text(
          DateFormat.yMMMd().format(widget.transaction.date),
        ),
        trailing: MediaQuery.of(context).size.width > 460
            ? FlatButton.icon(
                onPressed: () =>
                    widget.deleteTransactions(widget.transaction.id),
                icon: Icon(Icons.delete),
                label: const Text("Delete"),//if we use conct infront of the widgets which wont change then performance is improved
                textColor: Theme.of(context).errorColor,
                )
            : IconButton(
                icon: Icon(Icons.delete),
                color: Theme.of(context).errorColor,
                onPressed: () =>
                    widget.deleteTransactions(widget.transaction.id),
              ),
      ),
    );
  }
}