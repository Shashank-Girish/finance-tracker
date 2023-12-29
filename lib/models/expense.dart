class ExpenseInfo{
  final int id;
  final String title;
  final String description;
  final double amount;
  final DateTime date;
  final String category;

  ExpenseInfo({
    required this.id,
    required this.title,
    required this.description,
    required this.amount,
    required this.date,
    required this.category
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'amount': amount,
      'date': date.toIso8601String(),
      'category': category
    };
  }

  factory ExpenseInfo.fromMap(Map<String, dynamic> map) {
    return ExpenseInfo(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      amount: map['amount'],
      date: DateTime.parse(map['date']),
      category: map['category']
    );
  }
}