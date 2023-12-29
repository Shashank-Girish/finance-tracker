import 'package:expense_tracker/constants/icons.dart';
import 'package:expense_tracker/models/database_provider.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpenseForm extends StatefulWidget {
  const ExpenseForm({super.key});

  @override
  State<ExpenseForm> createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _amount = TextEditingController();
  DateTime? _date;
  String _categoryNow = 'Other';

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DatabaseProvider>(context, listen: false);
    return Container(
      height: MediaQuery.of(context).size.height * 0.749,
      padding: const EdgeInsets.all(20.0),

      // The form
      child: SingleChildScrollView(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 7.0),
            child: TextField(
              controller: _title,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 7.0),
            child: TextField(
              controller: _description,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 7.0),
            child: TextField(
              controller: _amount,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Amount',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 7.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () async {
                      final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now());
                      setState(() {
                        _date = date;
                      });
                    },
                    child: const Text('Date'),
                  ),
                ),
                Text(_date == null
                    ? 'No date chosen'
                    : '${_date!.day}/${_date!.month}/${_date!.year}'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 7.0),
            child: Row(
              children: [
                const Expanded(child: Text('Category')),
                Expanded(
                  child: DropdownButton(
                    items: icons.keys
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ),
                        )
                        .toList(),
                    value: _categoryNow,
                    onChanged: (newValue) {
                      setState(() {
                        _categoryNow = newValue!;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 7.0),
            child: ElevatedButton(
              onPressed: () async {
                if (_title.text.isNotEmpty &&
                    _description.text.isNotEmpty &&
                    _amount.text.isNotEmpty) {
                  await provider.addExpense(ExpenseInfo(
                    id: 0,
                    title: _title.text,
                    description: _description.text,
                    amount: double.parse(_amount.text),
                    date: _date!,
                    category: _categoryNow,
                  ));
                  provider.updateCategory(
                      _categoryNow, 1, double.parse(_amount.text));
                  Navigator.of(context).pop();
                } else {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill in all fields'),
                    ),
                  );
                }
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add),
                  SizedBox(width: 10.0),
                  Text('Add Expense'),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
