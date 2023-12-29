import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense_category.dart';

// ignore: must_be_immutable
class CategoryCard extends StatelessWidget {
  ExpenseCategory category;
  CategoryCard({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(category.icon),
      title: Text(category.title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(category.description),
          Text(
            "Entries: ${category.entries.toString()}",
            style: const TextStyle(
              fontSize: 15.0,
            ),
          ),
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "₹ ${category.total.toStringAsFixed(2)}",
            style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.blue),
          ),
        ],
      ),
    );
  }
}
