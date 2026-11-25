import 'package:cloud_firestore/cloud_firestore.dart';

class Book {
  final int id;
  final String title;
  final String author;
  final String genre;
  bool isBorrowed;
  DateTime? dueDate;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.genre,
    this.isBorrowed = false,
    this.dueDate,
  });

  bool get isOverdue =>
      isBorrowed && dueDate != null && dueDate!.isBefore(DateTime.now());

  /// Book -> Firestore document
  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'author': author,
        'genre': genre,
        'isBorrowed': isBorrowed,
        'dueDate': dueDate == null ? null : Timestamp.fromDate(dueDate!),
      };

  /// Firestore document -> Book
  factory Book.fromMap(Map<String, dynamic> map) => Book(
        id: map['id'] as int,
        title: map['title'] ?? '',
        author: map['author'] ?? '',
        genre: map['genre'] ?? '',
        isBorrowed: map['isBorrowed'] ?? false,
        dueDate: (map['dueDate'] as Timestamp?)?.toDate(),
      );
}

/// Formats a date as dd/mm/yyyy without needing the intl package.
String formatDate(DateTime d) {
  final day = d.day.toString().padLeft(2, '0');
  final month = d.month.toString().padLeft(2, '0');
  return '$day/$month/${d.year}';
}