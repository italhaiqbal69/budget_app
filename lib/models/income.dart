// Reuse categories from expense.dart where needed elsewhere

class Income {
  final int? id;
  final String title;
  final double amount;
  final DateTime date;
  final String category;

  Income({
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

  static Income fromMap(Map<String, dynamic> map) {
    return Income(
      id: map['id'],
      title: map['title'],
      amount: map['amount'],
      date: DateTime.parse(map['date']),
      category: map['category'],
    );
  }
}

// Use same categories as expenses for simplicity
// You can add income-specific ones like 'Salary', 'Freelance' if needed
