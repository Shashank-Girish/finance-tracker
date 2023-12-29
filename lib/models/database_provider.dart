import 'package:expense_tracker/constants/icons.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/models/expense_category.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider with ChangeNotifier {
  Database? _database;
  List<ExpenseCategory> _categories = [];
  List<ExpenseCategory> get categories => _categories;

  // ignore: prefer_final_fields
  List<ExpenseInfo> _expenses = [];
  List<ExpenseInfo> get expenseList => _expenses;

  Future<Database> get database async {
    final dbDirectory = await getDatabasesPath();

    const dbName = 'expense_tracker.db';

    final path = join(dbDirectory, dbName);

    _database ??=
        await openDatabase(path, version: 1, onCreate: _createDatabase);

    return _database!;
  }

  static const cTable = 'categoryTable'; // Corrected the typo in table name
  static const eTable = 'expenseTable';
  Future<void> _createDatabase(Database db, int version) async {
    await db.transaction((txn) async {
      await txn.execute('''
        CREATE TABLE $cTable(
          title TEXT PRIMARY KEY,
          description TEXT,
          entries INTEGER,
          totalAmount REAL 
        )
      ''');

      await txn.execute('''
        CREATE TABLE $eTable(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT,
          description TEXT,
          amount REAL,
          date TEXT,
          category TEXT
        )
      ''');

      for (int i = 0; i < icons.length; i++) {
        await txn.insert(cTable, {
          'title': icons.keys.elementAt(i),
          'description': descriptions[icons.keys.elementAt(i)],
          'entries': 0,
          'totalAmount': 0.0
        });
      }
    });
  }

  Future<List<ExpenseCategory>> getCategories() async {
    final db = await database;

    return await db.transaction((txn) async {
      return await txn.query(cTable).then((value) {
        final converted = List<Map<String, dynamic>>.from(value);

        List<ExpenseCategory> categories = List.generate(converted.length,
            (index) => ExpenseCategory.fromMap(converted[index]));
        _categories = categories;
        return categories;
      });
    });
  }

  Future<void> updateCategory(
      String category, int numEntries, double totalAmt) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn
          .update(
        cTable,
        {
          'entries': numEntries,
          'totalAmount': totalAmt.toString(),
        },
        where: 'title == ?',
        whereArgs: [category],
      )
          .then((_) {
        var record =
            _categories.firstWhere((element) => element.title == category);
        record.entries = numEntries;
        record.total = totalAmt;

        notifyListeners();
      });
    });
  }

  Future<void> addExpense(ExpenseInfo expenseInfo) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn
          .insert(eTable, expenseInfo.toMap(),
              conflictAlgorithm: ConflictAlgorithm.replace)
          .then((genId) {
        final record = ExpenseInfo(
            id: genId,
            title: expenseInfo.title,
            description: expenseInfo.description,
            amount: expenseInfo.amount,
            date: expenseInfo.date,
            category: expenseInfo.category);

        _expenses.add(record);

        notifyListeners();

        var data = calculateEntriesAndTotal(expenseInfo.category);
        updateCategory(expenseInfo.category, data['entries'], data['totalAmt']);
      });
    });
  }

  Map<String,dynamic> calculateEntriesAndTotal(String category){
    int numEntries = 0;
    double totalAmt = 0.0;
    for (var element in _expenses) {
      if(element.category == category){
        numEntries++;
        totalAmt += element.amount;
      }
    }
    return {
      'entries': numEntries,
      'totalAmt': totalAmt
    };
  }
}
