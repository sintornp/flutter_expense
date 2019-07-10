import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';
import './transaction_item.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> _userTransactions;
  final Function _deleteTransaction;

  TransactionList(this._userTransactions, this._deleteTransaction);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return _userTransactions.isEmpty
//! Image when no transaction
        ? LayoutBuilder(
            builder: (ctx, constrain) {
              return Column(
                children: <Widget>[
                  Container(
                    height: constrain.maxHeight * 0.2,
                    child: Text(
                      'No transactions added yet',
                      style: Theme.of(context).textTheme.title,
                    ),
                  ),
                  SizedBox(
                    height: constrain.maxHeight * 0.1,
                  ),
                  Container(
                    height: constrain.maxHeight * 0.5,
                    child: Image.asset(
                      'assets/images/bill_icon.png',
                      // 'assets/images/profile-pic.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              );
            },
          )
//! Transaction List View
        : ListView.builder(
            itemBuilder: (ctx, index) {
              return new TransactionItem(
                  _userTransactions[index], _deleteTransaction);
            },
            itemCount: _userTransactions.length,
          );
  }
}
