import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/transaction_model.dart';

abstract interface class TransactionRepository {
  Future<String> add(TransactionModel transaction);
  Stream<List<TransactionModel>> watchCurrentUser();
}

class FirestoreTransactionRepository implements TransactionRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  FirestoreTransactionRepository({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
  }) : firestore = firestore ?? FirebaseFirestore.instance,
       auth = auth ?? FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> get _transactions =>
      firestore.collection('transactions');

  String get _userId =>
      auth.currentUser?.uid ?? (throw StateError('User is not signed in.'));

  @override
  Future<String> add(TransactionModel transaction) async {
    if (transaction.userId != _userId)
      throw StateError('Transaction user mismatch.');
    final document = await _transactions.add(transaction.toFirestore());
    return document.id;
  }

  @override
  Stream<List<TransactionModel>> watchCurrentUser() {
    return _transactions
        .where('userId', isEqualTo: _userId)
        .orderBy('date', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => TransactionModel.fromFirestore(doc.id, doc.data()))
              .toList(),
        );
  }
}
