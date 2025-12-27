class Expense {
  final int? id;
  final String title;
  final double amount;
  final DateTime date;
  final String category;

  Expense({
    this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
      'category': category,
    };
  }

  static Expense fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      title: map['title'],
      amount: map['amount'],
      date: DateTime.parse(map['date']),
      category: map['category'],
    );
  }
}

// Categories with icons
final List<Map<String, dynamic>> categories = [
  {'name': 'Food', 'icon': '🍔'},
  {'name': 'Transport', 'icon': '🚗'},
  {'name': 'Shopping', 'icon': '🛍️'},
  {'name': 'Entertainment', 'icon': '🎬'},
  {'name': 'Bills', 'icon': '💡'},
  {'name': 'Health', 'icon': '🏥'},
  {'name': 'Other', 'icon': '📦'},
];
