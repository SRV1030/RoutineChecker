import 'dart:io';

import 'package:RoutineCheckonVisitor/widgets/new_transactions.dart';
import 'package:RoutineCheckonVisitor/widgets/transactionlist.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

// import 'package:flutter/services.dart';//for SystemChrome to enable only portait mode

import './widgets/new_transactions.dart';
import './models/transaction.dart';
import './widgets/chart.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized(); //for only protrait mode
  // SystemChrome.setPreferredOrientations([ DeviceOrientation.portraitUp, DeviceOrientation.portraitDown,]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SAATH Transactions',
      theme: ThemeData(
          primarySwatch: Colors.purple, //main color
          accentColor: Colors.amber, //supportingcolors
          errorColor: Colors.grey, //default its red
          fontFamily: 'Quicksand',
          textTheme: ThemeData.light().textTheme.copyWith(
                title: TextStyle(
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                button: TextStyle(color: Colors.white),
              ),
          appBarTheme: AppBarTheme(
            textTheme: ThemeData.light().textTheme.copyWith(
                  title: TextStyle(
                    //only changes the texts with title key
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
          )),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  //<Transaction creates a data tpe of transaction class created in transactions.dart and List makes a list of such transactions>
  // String titleInput;
  // String amountInput;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver{
  final List<Transaction> _userTransactions = [
    // Transaction(id: 't1', amount: 99.91, title: 'Shoes', date: DateTime.now()),
    // Transaction(id: 't2', amount: 89.92, title: 'Watch', date: DateTime.now()),
  ];
  bool _showChart = false;
  
  @override
  void initState() {
    // TODO: implement initState
   WidgetsBinding.instance.addObserver(this);//adds this i.e state observer
    super.initState();
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state){//it is a listener and is triggered when apps lifecucle changes
    print(state);
  }

  @override
  dispose(){
    WidgetsBinding.instance.removeObserver(this);//it removes the observer, here this i.e state
    super.dispose();//clears the listener
  }

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  } //where returns a iterable that satisfies the inbuilt function. isAfter gives true if the date is with in 7 days. i.e  if tx.date is 7 days after the current date

  void _addNewTransaction(String txTitle, double txAmount, DateTime txDate) {
    final newTx = Transaction(
        title: txTitle,
        amount: txAmount,
        date: txDate,
        id: DateTime.now().toString());
    setState(
      () {
        _userTransactions.add(newTx);
      },
    );
  }

  void _deleteTransactions(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
  }

  void _startAtNewTransactions(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: NewTransaction(_addNewTransaction),
          behavior: HitTestBehavior
              .opaque, //makes sure that wiidget is not closed when tapped on screeni.e it identifies tap event abd avoids to let to do anything not desired
        );
      },
    ); //we need to pass a widget in the builder od ModalSheet and context is got ffrom BuildContext
  }
  Widget _buildLandscapeContent() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Show Chart",
            style: Theme.of(context).textTheme.title,
          ),
          Switch.adaptive(
            value: _showChart,
            onChanged: (val) {
              //switch.adaptive makes the looks adapt the os say android or ios
              setState(() {
                _showChart = val;
              });
            },
          ),
        ],
      );
    }

    List<Widget> _buildPortraitMode(MediaQueryData mediaQuery, AppBar appBar,Widget txListWidgit ) {
      return [Container(
          height: (MediaQuery.of(context).size.height -
                  appBar.preferredSize.height /*for appBar*/ -
                  MediaQuery.of(context).padding.top /*for status bar*/) *
              0.3,
          child: Chart(_recentTransactions),
          ),
          txListWidgit,          
          ];
    }

  Widget _buildCupertinoNavigationBar(){
    return CupertinoNavigationBar(
            middle: Text("SAATH Transactions"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  child: Icon(CupertinoIcons.add),
                  onTap: () => _startAtNewTransactions(context),
                )
              ],
            ), //same as action in scaffold
          );
  }
  Widget _buildAppBar(){
    return AppBar(
            //we store in a variable so that we can calculate the size
            title: Text('SAATH Transactions'),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () => _startAtNewTransactions(context),
              )
            ], //set of widgetsin appbar
          );
  }
  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final mediaQuery = MediaQuery.of(context);

    final PreferredSizeWidget appBar = Platform.isIOS
        ? _buildCupertinoNavigationBar()
        : _buildAppBar();
    final txListWidgit = Container(
        height: (MediaQuery.of(context).size.height -
                appBar.preferredSize.height -
                MediaQuery.of(context).padding.top) *
            0.7,
        child: TransactionList(_userTransactions, _deleteTransactions));

    

    final body = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (isLandscape) _buildLandscapeContent(),
            if (!isLandscape) ..._buildPortraitMode(mediaQuery, appBar ,txListWidgit),//_buildPorttaitmode returns a list of widget and we can use each data item by spread operator ... that flaens the list
            if (isLandscape)
              _showChart
                  ? Container(
                      height: (mediaQuery.size.height -
                              appBar.preferredSize.height /*for appBar*/ -
                              MediaQuery.of(context)
                                  .padding
                                  .top /*for status bar*/) *
                          0.7,
                      child: Chart(_recentTransactions))
                  : txListWidgit
          ],
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            //for ios
            child: body,
            navigationBar: appBar,
          )
        : Scaffold(
            appBar: appBar,
            body: body,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => _startAtNewTransactions(context),
                  ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }
}
