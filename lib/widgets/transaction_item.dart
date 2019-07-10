import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem(
    this._transaction,
    this._deleteTransaction,
  );
  final Transaction _transaction;
  final Function _deleteTransaction;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 5,
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: FittedBox(
              child: Text('B${_transaction.amount.toStringAsFixed(2)}'),
            ),
          ),
        ),
        title: Text(
          '${_transaction.title}',
          style: Theme.of(context).textTheme.title,
        ),
        subtitle: Text(
          DateFormat('MMM, dd yyyy').format(_transaction.date),
        ),
        trailing: mediaQuery.size.width > 460
            ? FlatButton.icon(
                label: const Text('Delete'),
                icon: const Icon(Icons.delete_forever),
                textColor: Colors.red,
                onPressed: () => _deleteTransaction(_transaction.id),
              )
            : IconButton(
                icon: Icon(Icons.delete_forever),
                color: Colors.red,
                onPressed: () => _deleteTransaction(_transaction.id),
              ),
      ),
    );
  }
}
