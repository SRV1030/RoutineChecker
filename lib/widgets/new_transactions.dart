import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';



class NewTransaction extends StatefulWidget {
  final Function transactionAdder;
  NewTransaction(this.transactionAdder){
    print("Constructor of new_transationState");
  }

  @override
  _NewTransactionState createState() {
    print("NewTransction CeateState");
    return _NewTransactionState();
  } 
}

class _NewTransactionState extends State<NewTransaction> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  _NewTransactionState(){
    print("New Transaction State");
  }  
  DateTime _selectedDate;

  @override
  void initState() {
    // TODO: implement initState
    print("InitState");//fetching the data that wont change
    super.initState();
  }
  @override
  void didUpdateWidget(covariant NewTransaction oldWidget) {
    // TODO: implement didUpdateWidget
    print("DidUpdate State");//to use former data or widgit
    super.didUpdateWidget(oldWidget);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    print("Dispose");//to clean up data such as listeners
    super.dispose();
  }
  void _presentDatePicker(){
    showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2020), lastDate: DateTime.now(),
    ).then((pickedDate){
        if(pickedDate==null) return;
        setState(() {
          _selectedDate=pickedDate;
        });      

    });//showDate pickeer has an inbuilt method called Future that holds the value when eneterd in future, when we get a value .then implements the function inside it
    print('...');
  }

  void _submitData() {
    if (amountController.text.isEmpty) return;
    final enteredtitle = titleController.text;
    final enteredAmount = double.parse(amountController.text);
    if (enteredtitle.isEmpty || enteredAmount <=0 || _selectedDate==null) {
      return;
    }
    widget.transactionAdder(enteredtitle,enteredAmount,_selectedDate,); //widget. allows us to use the property of statefulwidget
    Navigator.of(context)
        .pop(); //it pops off the transaction adder screen of(context) makes sure that it is of current context
  }

  

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
          child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
            left:10,
            right:10,
            top:10,
            bottom: MediaQuery.of(context).viewInsets.bottom+10,//to make the softkeyboard of differentsize
          ),
           child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                //CupertinoTextField(plaxholder:Text(""))for ios
                TextField(
                  decoration: InputDecoration(labelText: "Title"),
                  // onChanged: (val) {//onChanged always takes a strinmg as an argument and updates after every keu Stroke
                  //   titleInput = val;
                  //},
                  controller: titleController,
                  onSubmitted: (_) =>
                      _submitData(), //OnSubmitted takes stringbut as we don't ned that paramete we use _ that means we get a data but we don't use it
                ),
                TextField(
                  decoration: InputDecoration(labelText: "Amount"),
                  keyboardType: TextInputType.number,
                  // onChanged: (val) => amountInput = val,
                  controller: amountController,
                  onSubmitted: (_) => _submitData(),
                ),
                Container(
                  height: 70,
                  child: Row(
                    children: <Widget>[
                      Expanded(child: Text("Picked Date: ${_selectedDate==null?'No date Chosen!':DateFormat.yMd().format(_selectedDate)}"),),
                      Platform.isIOS? CupertinoButton(child:Text(
                          'Choose Date',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onPressed:_presentDatePicker)
                      :
                       FlatButton(
                        onPressed: _presentDatePicker,
                        child: Text(
                          'Choose Date',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        textColor: Theme.of(context).primaryColor,
                      )
                    ],
                  ),
                ),
                RaisedButton(
                   color: Theme.of(context).primaryColor,
                    onPressed: _submitData,
                    child: Text("Add Transaction"),
                    textColor: Theme.of(context).textTheme.button.color,
                ),
              ],
            ),
          ),
        ),      
    );
  }
}
