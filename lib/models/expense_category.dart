import 'package:expense_tracker/constants/icons.dart';
import 'package:flutter/material.dart';

class ExpenseCategory {
  final String title;
  final String description;
  final IconData icon;
  int entries = 0;
  double total = 0.0;

  ExpenseCategory(
      {required this.title,
      required this.description,
      required this.icon,
      required this.entries,
      required this.total});

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'entries': entries,
      'total': total
    };
  }

  factory ExpenseCategory.fromMap(Map<String, dynamic> map) {
    return ExpenseCategory(
        title: map['title'],
        description: map['description'],
        icon: icons[map['title']] ?? Icons.more_horiz,
        entries: map['entries'] ?? 0,
        total: map['total'] ?? 0.0);
  }
}
