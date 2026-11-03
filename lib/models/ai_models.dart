import 'dart:convert';

import 'expense.dart';

class AIValidationException implements Exception {
  final String message;

  const AIValidationException(this.message);

  @override
  String toString() => message;
}

double _readAmount(Object? value) {
  final amount = value is num ? value.toDouble() : double.tryParse('$value');
  if (amount == null || !amount.isFinite || amount <= 0) {
    throw const AIValidationException('The AI returned an invalid amount.');
  }
  return amount;
}

DateTime _readDate(Object? value) {
  final date = DateTime.tryParse('$value');
  if (date == null) {
    throw const AIValidationException('The AI returned an invalid date.');
  }
  return date;
}

String _readCategory(Object? value) {
  final category = '$value';
  if (!isValidCategory(category)) {
    throw AIValidationException('Unsupported category: $category');
  }
  return category;
}

class AICategoryResult {
  final String category;
  final double confidence;

  const AICategoryResult({required this.category, required this.confidence});

  factory AICategoryResult.fromJson(Map<String, dynamic> json) {
    final confidence = json['confidence'] is num
        ? (json['confidence'] as num).toDouble()
        : double.tryParse('${json['confidence']}');
    if (confidence == null || confidence < 0 || confidence > 1) {
      throw const AIValidationException(
        'The AI returned an invalid confidence.',
      );
    }
    return AICategoryResult(
      category: _readCategory(json['category']),
      confidence: confidence,
    );
  }
}

class AITransactionResult {
  final String type;
  final double amount;
  final String currency;
  final String category;
  final String merchant;
  final String description;
  final DateTime date;
  final String? paymentMethod;

  const AITransactionResult({
    required this.type,
    required this.amount,
    required this.currency,
    required this.category,
    required this.merchant,
    required this.description,
    required this.date,
    this.paymentMethod,
  });

  factory AITransactionResult.fromJson(Map<String, dynamic> json) {
    final type = '${json['type']}'.toLowerCase();
    if (!validTransactionTypes.contains(type)) {
      throw AIValidationException('Unsupported transaction type: $type');
    }
    final currency = '${json['currency']}'.trim().toUpperCase();
    if (currency.length != 3) {
      throw const AIValidationException('The AI returned an invalid currency.');
    }
    return AITransactionResult(
      type: type,
      amount: _readAmount(json['amount']),
      currency: currency,
      category: _readCategory(json['category']),
      merchant: '${json['merchant'] ?? 'Unknown'}'.trim(),
      description: '${json['description'] ?? ''}'.trim(),
      date: _readDate(json['date']),
      paymentMethod: json['payment_method'] == null
          ? null
          : '${json['payment_method']}'.trim(),
    );
  }
}

class ReceiptItem {
  final String name;
  final double amount;

  const ReceiptItem({required this.name, required this.amount});

  factory ReceiptItem.fromJson(Map<String, dynamic> json) => ReceiptItem(
    name: '${json['name']}'.trim(),
    amount: _readAmount(json['amount']),
  );
}

class ReceiptModel {
  final String merchant;
  final double totalAmount;
  final String currency;
  final DateTime? date;
  final String category;
  final String? paymentMethod;
  final List<ReceiptItem> items;
  final Set<String> uncertainFields;

  const ReceiptModel({
    required this.merchant,
    required this.totalAmount,
    required this.currency,
    required this.date,
    required this.category,
    required this.paymentMethod,
    required this.items,
    required this.uncertainFields,
  });

  factory ReceiptModel.fromJson(Map<String, dynamic> json) {
    final currency = '${json['currency']}'.trim().toUpperCase();
    if (currency.length != 3) {
      throw const AIValidationException('The receipt currency is invalid.');
    }
    final rawItems = json['items'];
    return ReceiptModel(
      merchant: '${json['merchant'] ?? 'Unknown'}'.trim(),
      totalAmount: _readAmount(json['total_amount']),
      currency: currency,
      date: json['date'] == null ? null : _readDate(json['date']),
      category: _readCategory(json['category']),
      paymentMethod: json['payment_method'] == null
          ? null
          : '${json['payment_method']}'.trim(),
      items: rawItems is List
          ? rawItems
                .whereType<Map>()
                .map(
                  (item) =>
                      ReceiptItem.fromJson(Map<String, dynamic>.from(item)),
                )
                .toList()
          : const [],
      uncertainFields: (json['uncertain_fields'] as List? ?? const [])
          .map((field) => '$field')
          .toSet(),
    );
  }
}

Map<String, dynamic> decodeObject(String body) {
  final decoded = jsonDecode(body);
  if (decoded is! Map) {
    throw const AIValidationException('The AI response was not a JSON object.');
  }
  return Map<String, dynamic>.from(decoded);
}
