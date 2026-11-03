import 'expense.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel {
  final String? id;
  final String userId;
  final String type;
  final double amount;
  final String currency;
  final String category;
  final String title;
  final DateTime date;
  final String? merchant;
  final String? paymentMethod;

  const TransactionModel({
    this.id,
    required this.userId,
    required this.type,
    required this.amount,
    required this.currency,
    required this.category,
    required this.title,
    required this.date,
    this.merchant,
    this.paymentMethod,
  });

  Map<String, dynamic> toFirestore() => {
    'userId': userId,
    'type': type,
    'amount': amount,
    'currency': currency,
    'category': category,
    'title': title,
    'date': date,
    'merchant': merchant,
    'paymentMethod': paymentMethod,
    'createdAt': DateTime.now(),
  };

  factory TransactionModel.fromFirestore(String id, Map<String, dynamic> data) {
    final type = '${data['type']}'.toLowerCase();
    final amount = (data['amount'] as num?)?.toDouble();
    final rawDate = data['date'];
    final date = rawDate is Timestamp ? rawDate.toDate() : rawDate;
    if (!validTransactionTypes.contains(type) ||
        amount == null ||
        amount <= 0 ||
        !isValidCategory('${data['category']}') ||
        date is! DateTime) {
      throw const FormatException('Invalid Firestore transaction.');
    }
    return TransactionModel(
      id: id,
      userId: '${data['userId']}',
      type: type,
      amount: amount,
      currency: '${data['currency']}',
      category: '${data['category']}',
      title: '${data['title']}',
      date: date,
      merchant: data['merchant'] as String?,
      paymentMethod: data['paymentMethod'] as String?,
    );
  }
}
