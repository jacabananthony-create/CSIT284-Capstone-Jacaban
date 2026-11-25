import 'package:cloud_firestore/cloud_firestore.dart';

class BorrowRecord {
  String? docId; // Firestore document id, set after saving
  final String bookTitle;
  final DateTime borrowedOn;
  DateTime? returnedOn;

  BorrowRecord({
    this.docId,
    required this.bookTitle,
    required this.borrowedOn,
    this.returnedOn,
  });

  bool get isReturned => returnedOn != null;

  Map<String, dynamic> toMap() => {
        'bookTitle': bookTitle,
        'borrowedOn': Timestamp.fromDate(borrowedOn),
        'returnedOn':
            returnedOn == null ? null : Timestamp.fromDate(returnedOn!),
      };

  factory BorrowRecord.fromMap(String docId, Map<String, dynamic> map) =>
      BorrowRecord(
        docId: docId,
        bookTitle: map['bookTitle'] ?? '',
        borrowedOn: (map['borrowedOn'] as Timestamp).toDate(),
        returnedOn: (map['returnedOn'] as Timestamp?)?.toDate(),
      );
}