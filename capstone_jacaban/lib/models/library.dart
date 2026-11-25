import 'dart:async';

import 'package:flutter/foundation.dart';

import '../services/firestore_service.dart';
import 'book.dart';
import 'borrow_record.dart';

/// App state, now backed by Firebase Firestore.
class Library extends ChangeNotifier {
  static const int loanDays = 14;

  final FirestoreService _service = FirestoreService();

  List<Book> books = [];
  List<BorrowRecord> history = [];
  bool isLoading = true;
  String? error;

  StreamSubscription<List<Book>>? _bookSub;
  StreamSubscription<List<BorrowRecord>>? _recordSub;

  Library() {
    _start();
  }

  Future<void> _start() async {
    try {
      await _service.seedBooksIfEmpty(_seedBooks());
    } catch (e) {
      _setError(e);
    }
    _bookSub = _service.watchBooks().listen((data) {
      books = data;
      isLoading = false;
      error = null;
      notifyListeners();
    }, onError: (e) => _setError(e));
    _recordSub = _service.watchRecords().listen((data) {
      history = data;
      notifyListeners();
    }, onError: (e) => _setError(e));
  }

  void _setError(Object e) {
    error = e.toString();
    isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _bookSub?.cancel();
    _recordSub?.cancel();
    super.dispose();
  }

  List<Book> _seedBooks() => [
        Book(id: 1, title: 'Clean Code', author: 'Robert C. Martin', genre: 'Programming'),
        Book(id: 2, title: 'The Pragmatic Programmer', author: 'Andrew Hunt', genre: 'Programming'),
        Book(id: 3, title: 'Dune', author: 'Frank Herbert', genre: 'Sci-Fi'),
        Book(id: 4, title: '1984', author: 'George Orwell', genre: 'Dystopian'),
        Book(id: 5, title: 'The Hobbit', author: 'J.R.R. Tolkien', genre: 'Fantasy'),
        Book(id: 6, title: 'Noli Me Tangere', author: 'Jose Rizal', genre: 'Classic'),
        Book(id: 7, title: 'To Kill a Mockingbird', author: 'Harper Lee', genre: 'Classic'),
        Book(id: 8, title: 'Atomic Habits', author: 'James Clear', genre: 'Self-Help'),
        Book(id: 9, title: 'Sapiens', author: 'Yuval Noah Harari', genre: 'History'),
        Book(id: 10, title: 'The Alchemist', author: 'Paulo Coelho', genre: 'Fiction'),
      ];

  // ---------- search ----------
  String _query = '';
  String get query => _query;

  void setQuery(String value) {
    _query = value;
    notifyListeners();
  }

  List<Book> get filteredBooks {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return books;
    return books
        .where((b) =>
            b.title.toLowerCase().contains(q) ||
            b.author.toLowerCase().contains(q))
        .toList();
  }

  // ---------- CRUD on books ----------

  // CREATE
  Future<void> addBook(String title, String author, String genre) async {
    final nextId = books.isEmpty
        ? 1
        : books.map((b) => b.id).reduce((a, b) => a > b ? a : b) + 1;
    try {
      await _service.addBook(
          Book(id: nextId, title: title, author: author, genre: genre));
    } catch (e) {
      _setError(e);
    }
  }

  // UPDATE
  Future<void> updateBook(Book book) async {
    try {
      await _service.updateBook(book);
    } catch (e) {
      _setError(e);
    }
  }

  // DELETE
  Future<void> deleteBook(int id) async {
    try {
      await _service.deleteBook(id);
    } catch (e) {
      _setError(e);
    }
  }

  // ---------- borrow / return (saved to Firestore) ----------

  Future<void> borrow(Book book) async {
    if (book.isBorrowed) return;
    final now = DateTime.now();
    book.isBorrowed = true;
    book.dueDate = now.add(const Duration(days: loanDays));
    try {
      await _service.updateBook(book);
      await _service
          .addRecord(BorrowRecord(bookTitle: book.title, borrowedOn: now));
    } catch (e) {
      _setError(e);
    }
  }

  Future<void> returnBook(Book book) async {
    if (!book.isBorrowed) return;
    book.isBorrowed = false;
    book.dueDate = null;
    try {
      await _service.updateBook(book);
      for (final record in history) {
        if (record.bookTitle == book.title && !record.isReturned) {
          record.returnedOn = DateTime.now();
          await _service.updateRecord(record);
          break;
        }
      }
    } catch (e) {
      _setError(e);
    }
  }
}