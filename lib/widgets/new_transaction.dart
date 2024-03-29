import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

class NewTransaction extends StatefulWidget {
  final Function _addNewTransaction;
  NewTransaction(this._addNewTransaction);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate;

  void _submitData() {
    if (_amountController.text.isEmpty) {
      return;
    }
    final _enteredTitle = _titleController.text;
    final _enteredAmount = double.parse(_amountController.text);

    if (_enteredTitle.isEmpty || _enteredAmount <= 0 || _selectedDate == null) {
      return;
    }

    widget._addNewTransaction(_titleController.text,
        double.parse(_amountController.text), _selectedDate);

    Navigator.of(context).pop();
  }

  void _presentCupertinoDatePicker() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return CupertinoDatePicker(
            onDateTimeChanged: (DateTime pickedDate) {
              if (pickedDate == null) {
                return;
              }
              setState(() {
                _selectedDate = pickedDate;
              });
            },
            initialDateTime: DateTime.now(),
            mode: CupertinoDatePickerMode.date,
            minimumDate: DateTime(2019),
            maximumDate: DateTime.now(),
            minimumYear: 2019,
            maximumYear: 2019,
          );
        });
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            // bottom: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Platform.isIOS
                  ? CupertinoTextField(
                      placeholder: 'Title',
                      controller: _titleController,
                      onSubmitted: (_) => _submitData(),
                    )
                  : TextField(
                      decoration: InputDecoration(
                        labelText: 'Title',
                      ),
                      controller: _titleController,
                      onSubmitted: (_) => _submitData(),
                    ),
              Platform.isIOS
                  ? CupertinoTextField(
                      placeholder: 'Amount',
                      controller: _amountController,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      onSubmitted: (_) => _submitData(),
                    )
                  : TextField(
                      decoration: InputDecoration(
                        labelText: 'Amount',
                      ),
                      controller: _amountController,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      onSubmitted: (_) => _submitData(),
                    ),
              Container(
                height: 50,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(_selectedDate == null
                          ? 'No Date Chosen!'
                          : 'Picked Date: ${DateFormat('MMM,dd yyyy').format(_selectedDate)}'),
                    ),
                    Platform.isIOS
                        ? CupertinoButton(
                            child: Text(
                              'Choose date',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            onPressed: _presentDatePicker,
//                            onPressed: _presentCupertinoDatePicker,
                          )
                        : FlatButton(
                            textColor: Theme.of(context).primaryColor,
                            child: Text(
                              'Choose date',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            onPressed: _presentDatePicker,
                          )
                  ],
                ),
              ),
              RaisedButton(
                child: Text('Add Transaction'),
                color: Theme.of(context).primaryColor,
                textColor: Theme.of(context).textTheme.button.color,
                onPressed: _submitData,
              )
            ],
          ),
        ),
      ),
    );
  }
}
