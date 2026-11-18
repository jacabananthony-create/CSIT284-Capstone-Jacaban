class BorrowRecord {
  final String bookTitle;
  final DateTime borrowedOn;
  DateTime? returnedOn;

  BorrowRecord({
    required this.bookTitle,
    required this.borrowedOn,
    this.returnedOn,
  });

  bool get isReturned => returnedOn != null;
}