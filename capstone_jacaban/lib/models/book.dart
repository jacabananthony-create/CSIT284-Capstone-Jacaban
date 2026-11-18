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
}

/// Formats a date as dd/mm/yyyy without needing the intl package.
String formatDate(DateTime d) {
  final day = d.day.toString().padLeft(2, '0');
  final month = d.month.toString().padLeft(2, '0');
  return '$day/$month/${d.year}';
}