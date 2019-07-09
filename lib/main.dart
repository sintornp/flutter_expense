import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';
import './models/transaction.dart';
import './widgets/chart.dart';

void main() => runApp(MyApp());

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

class _MyHomePageState extends State<MyHomePage> {
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
    Transaction(
      id: 't5',
      title: 'Candy',
      amount: 3.50,
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
      home: Scaffold(
        appBar: AppBar(
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
            IconButton(
              icon: Icon(Icons.add_circle_outline),
              color: Colors.white,
              onPressed: () => _startAddNewTransaction(context),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                width: double.infinity,
                child: Card(
                  color: pColor,
                  child: Chart(_recentTransactions),
                  elevation: 5,
                ),
              ),
              // NewTransaction(_addNewTransaction),
              TransactionList(_userTransactions, _deleteTransaction),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: new Builder(
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
