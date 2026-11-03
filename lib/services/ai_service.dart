import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import '../models/ai_models.dart';
import '../models/expense.dart';

abstract interface class AIService {
  Future<AICategoryResult> categorize({
    required String title,
    required String type,
    double? amount,
  });

  Future<AITransactionResult> parseTransaction(String input);

  Future<ReceiptModel> scanReceipt(Uint8List imageBytes, String filename);

  Future<String> generateSummary(Map<String, dynamic> calculatedSummary);
}

class HttpAIService implements AIService {
  final Uri endpoint;
  final http.Client client;

  HttpAIService({required this.endpoint, http.Client? client})
    : client = client ?? http.Client();

  Future<Map<String, dynamic>> _postJson(
    String path,
    Map<String, dynamic> payload,
  ) async {
    final response = await client.post(
      endpoint.resolve(path),
      headers: {'content-type': 'application/json'},
      body: jsonEncode(payload),
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('AI service returned HTTP ${response.statusCode}.');
    }
    return decodeObject(response.body);
  }

  @override
  Future<AICategoryResult> categorize({
    required String title,
    required String type,
    double? amount,
  }) async {
    return AICategoryResult.fromJson(
      await _postJson('/categorize', {
        'title': title,
        'type': type,
        'amount': amount,
        'allowed_categories': categories.map((item) => item['name']).toList(),
      }),
    );
  }

  @override
  Future<AITransactionResult> parseTransaction(String input) async {
    return AITransactionResult.fromJson(
      await _postJson('/parse-transaction', {
        'input': input,
        'allowed_categories': categories.map((item) => item['name']).toList(),
      }),
    );
  }

  @override
  Future<ReceiptModel> scanReceipt(
    Uint8List imageBytes,
    String filename,
  ) async {
    final request = http.MultipartRequest('POST', endpoint.resolve('/receipt'))
      ..files.add(
        http.MultipartFile.fromBytes('receipt', imageBytes, filename: filename),
      );
    final response = await client.send(request);
    final body = await response.stream.bytesToString();
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Receipt service returned HTTP ${response.statusCode}.');
    }
    return ReceiptModel.fromJson(decodeObject(body));
  }

  @override
  Future<String> generateSummary(Map<String, dynamic> calculatedSummary) async {
    final result = await _postJson('/monthly-summary', calculatedSummary);
    final text = result['summary'];
    if (text is! String || text.trim().isEmpty) {
      throw const AIValidationException('The AI returned an empty summary.');
    }
    return text.trim();
  }
}

class RuleBasedAIService implements AIService {
  const RuleBasedAIService();

  @override
  Future<AICategoryResult> categorize({
    required String title,
    required String type,
    double? amount,
  }) async {
    final text = title.toLowerCase();
    final category = type == 'income'
        ? (text.contains('salary') ? 'Salary' : 'Freelance')
        : text.contains('kfc') ||
              text.contains('food') ||
              text.contains('dinner')
        ? 'Food'
        : text.contains('careem') || text.contains('uber')
        ? 'Transport'
        : text.contains('netflix') || text.contains('movie')
        ? 'Subscription'
        : text.contains('daraz') || text.contains('shop')
        ? 'Shopping'
        : text.contains('bill') || text.contains('electricity')
        ? 'Bills'
        : 'Other';
    return AICategoryResult(category: category, confidence: 0.55);
  }

  @override
  Future<AITransactionResult> parseTransaction(String input) =>
      throw Exception('Natural-language AI is not configured.');

  @override
  Future<ReceiptModel> scanReceipt(Uint8List imageBytes, String filename) =>
      throw Exception('Receipt AI is not configured.');

  @override
  Future<String> generateSummary(Map<String, dynamic> calculatedSummary) =>
      throw Exception('Summary AI is not configured.');
}
