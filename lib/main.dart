import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';
import './models/transaction.dart';
import './widgets/chart.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      home: MyHomePage(),
      theme: ThemeData(
        primaryColor: Colors.red,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
  }

  @override
  dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  bool _showChart = false;
  final List<Transaction> _userTransactions = [
    Transaction(
      id: 't1',
      title: 'New Shoes',
      amount: 20.99,
      date: DateTime.now().subtract(Duration(days: 1)),
    ),
    Transaction(
      id: 't2',
      title: 'Weekly Groceries',
      amount: 42.50,
      date: DateTime.now().subtract(Duration(days: 2)),
    ),
    Transaction(
      id: 't3',
      title: 'Student book',
      amount: 8.22,
      date: DateTime.now().subtract(Duration(days: 3)),
    ),
    Transaction(
      id: 't4',
      title: 'Lunch with friend',
      amount: 40.50,
      date: DateTime.now(),
    ),
  ];

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addNewTransaction(String title, double amount, DateTime chosenDate) {
    final newTX = new Transaction(
      id: DateTime.now().toString(),
      title: title,
      amount: amount,
      date: chosenDate,
    );
    setState(() {
      _userTransactions.add(newTX);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          child: NewTransaction(_addNewTransaction),
          onTap: () {},
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((item) => item.id == id);
    });
  }

  List<Widget> _buildLandscapeContent(
      MediaQueryData mediaQuery, AppBar appBar, Widget txListWidget) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Show Chart',
            style: Theme.of(this.context).textTheme.title,
          ),
          Switch.adaptive(
            value: _showChart,
            onChanged: (newValue) {
              setState(() {
                _showChart = newValue;
              });
            },
          )
        ],
      ),
      _showChart
//! Chart display in Landscape mode
          ? Container(
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  0.8,
              width: double.infinity,
              child: Card(
                color: pColor,
                child: Chart(_recentTransactions),
                elevation: 5,
              ),
            )
//! Transaction display in Landscape mode
          : txListWidget,
    ];
  }

  List<Widget> _buildPortraitContent(
      MediaQueryData mediaQuery, AppBar appBar, Widget txListWidget) {
    return [
      Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.3,
        width: double.infinity,
        child: Card(
          color: pColor,
          child: Chart(_recentTransactions),
          elevation: 5,
        ),
      ),
      txListWidget
    ];
  }

  final List<Map> colors = [
    {'p': Colors.purple, 'a': Colors.orange, 'buttonColor': Colors.white},
    {'p': Colors.lightBlue, 'a': Colors.red, 'buttonColor': Colors.white},
    {'p': Colors.green, 'a': Colors.lightBlue, 'buttonColor': Colors.lightGreen}
  ];
  int currentColor = 0;
  Color pColor = Colors.purple;
  Color aColor = Colors.orange;
  Color buttonColor = Colors.white;

  void _toggleColor() {
    setState(() {
      if (currentColor < colors.length - 1) {
        currentColor += 1;
      } else {
        currentColor = 0;
      }
      pColor = colors[currentColor]['p'];
      aColor = colors[currentColor]['a'];
      buttonColor = colors[currentColor]['buttonColor'];
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

//! AppBar widget
    final PreferredSizeWidget appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            backgroundColor: pColor,
            middle: Text(
              'Personal Expense',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                GestureDetector(
                  child: Icon(
                    CupertinoIcons.paw,
                    color: Colors.white,
                  ),
                  onTap: _toggleColor,
                ),
                new Builder(
                  builder: (context) {
                    return GestureDetector(
                      child: Icon(
                        CupertinoIcons.add_circled,
                        color: Colors.white,
                      ),
                      onTap: () => _startAddNewTransaction(context),
                    );
                  },
                ),
              ],
            ),
          )
        : AppBar(
            title: Text(
              'Personal Expenses',
              style: TextStyle(fontFamily: 'OpenSans'),
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.color_lens),
                color: Colors.white,
                onPressed: _toggleColor,
              ),
              new Builder(
                builder: (context) {
                  return IconButton(
                    icon: Icon(Icons.add_circle_outline),
                    color: Colors.white,
                    onPressed: () => _startAddNewTransaction(context),
                  );
                },
              ),
            ],
          );
//! Transaction List Widget
    final txListWidget = Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.7,
        child: TransactionList(_userTransactions, _deleteTransaction));
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final bodyWidget = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
//! Switch to show chart and Transactions in Landscape mode
            if (isLandscape)
              ..._buildLandscapeContent(mediaQuery, appBar, txListWidget),
//! Chart and Transactions display in Portrait mode
            if (!isLandscape)
              ..._buildPortraitContent(mediaQuery, appBar, txListWidget),
          ],
        ),
      ),
    );
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: pColor,
        accentColor: aColor,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
              title: TextStyle(
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: pColor,
              ),
              button: TextStyle(color: buttonColor),
            ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                title: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
        ),
      ),
      home: Platform.isIOS
          ? CupertinoPageScaffold(
              child: bodyWidget,
              navigationBar: appBar,
            )
          : Scaffold(
              appBar: appBar,
              body: bodyWidget,
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              floatingActionButton: Platform.isIOS
                  ? Container()
                  : new Builder(
                      builder: (context) {
                        return new FloatingActionButton(
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 30,
                          ),
                          elevation: 5,
                          onPressed: () => _startAddNewTransaction(context),
                        );
                      },
                    ),
            ),
    );
  }
}
