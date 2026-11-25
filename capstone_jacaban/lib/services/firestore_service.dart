import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/book.dart';
import '../models/borrow_record.dart';

class FirestoreService {
  final _books = FirebaseFirestore.instance.collection('books');
  final _records = FirebaseFirestore.instance.collection('borrow_records');

  // ---------- BOOKS ----------

  // CREATE
  Future<void> addBook(Book book) =>
      _books.doc(book.id.toString()).set(book.toMap());

  // READ (live updates)
  Stream<List<Book>> watchBooks() => _books.orderBy('id').snapshots().map(
      (snap) => snap.docs.map((d) => Book.fromMap(d.data())).toList());

  // UPDATE
  Future<void> updateBook(Book book) =>
      _books.doc(book.id.toString()).update(book.toMap());

  // DELETE
  Future<void> deleteBook(int id) => _books.doc(id.toString()).delete();

    // Seed the 10 starter books once, when the collection is empty
  Future<void> seedBooksIfEmpty(List<Book> seed) async {
    final existing = await _books.limit(1).get();
    if (existing.docs.isNotEmpty) return;
    final batch = FirebaseFirestore.instance.batch();
    for (final b in seed) {
      batch.set(_books.doc(b.id.toString()), b.toMap());
    }
    await batch.commit();
  }

  // ---------- BORROW RECORDS ----------

  // CREATE (returns the new document id)
  Future<String> addRecord(BorrowRecord record) async {
    final ref = await _records.add(record.toMap());
    return ref.id;
  }

  // READ
  Stream<List<BorrowRecord>> watchRecords() => _records
      .orderBy('borrowedOn', descending: true)
      .snapshots()
      .map((snap) =>
          snap.docs.map((d) => BorrowRecord.fromMap(d.id, d.data())).toList());

  // UPDATE (mark as returned)
  Future<void> updateRecord(BorrowRecord record) =>
      _records.doc(record.docId).update(record.toMap());
}