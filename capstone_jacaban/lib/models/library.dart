import 'package:flutter/foundation.dart';

import 'book.dart';
import 'borrow_record.dart';

/// Holds all app state: the hardcoded book list, search query and history.
class Library extends ChangeNotifier {
  static const int loanDays = 14;

  final List<Book> books = [
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

  final List<BorrowRecord> history = [];

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

  void borrow(Book book) {
    if (book.isBorrowed) return;
    final now = DateTime.now();
    book.isBorrowed = true;
    book.dueDate = now.add(const Duration(days: loanDays));
    history.insert(0, BorrowRecord(bookTitle: book.title, borrowedOn: now));
    notifyListeners();
  }

  void returnBook(Book book) {
    if (!book.isBorrowed) return;
    book.isBorrowed = false;
    book.dueDate = null;
    for (final record in history) {
      if (record.bookTitle == book.title && !record.isReturned) {
        record.returnedOn = DateTime.now();
        break;
      }
    }
    notifyListeners();
  }
}