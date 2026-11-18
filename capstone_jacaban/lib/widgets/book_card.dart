import 'package:flutter/material.dart';

import '../models/book.dart';

class BookCard extends StatelessWidget {
  final Book book;
  final VoidCallback onTap;

  const BookCard({super.key, required this.book, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final String status;
    final Color color;
    if (!book.isBorrowed) {
      status = 'Available';
      color = Colors.green;
    } else if (book.isOverdue) {
      status = 'Overdue - due ${formatDate(book.dueDate!)}';
      color = Colors.red;
    } else {
      status = 'Due ${formatDate(book.dueDate!)}';
      color = Colors.orange;
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.15),
          child: Icon(Icons.menu_book, color: color),
        ),
        title: Text(book.title),
        subtitle: Text('${book.author}\n$status'),
        isThreeLine: true,
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}