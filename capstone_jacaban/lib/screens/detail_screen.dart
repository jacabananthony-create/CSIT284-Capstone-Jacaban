import 'package:flutter/material.dart';

import '../models/book.dart';
import '../models/library.dart';

class DetailScreen extends StatelessWidget {
  final Library library;
  final Book book;

  const DetailScreen({super.key, required this.library, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(book.title)),
      body: ListenableBuilder(
        listenable: library,
        builder: (context, _) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(child: Icon(Icons.menu_book, size: 96)),
                const SizedBox(height: 24),
                Text(book.title,
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 8),
                Text('by ${book.author}'),
                Text('Genre: ${book.genre}'),
                const SizedBox(height: 16),
                if (!book.isBorrowed)
                  const Text('Status: Available',
                      style: TextStyle(color: Colors.green))
                else
                  Text(
                    book.isOverdue
                        ? 'Status: OVERDUE (was due ${formatDate(book.dueDate!)})'
                        : 'Status: Borrowed - due ${formatDate(book.dueDate!)}',
                    style: TextStyle(
                      color: book.isOverdue ? Colors.red : Colors.orange,
                    ),
                  ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    icon: Icon(book.isBorrowed ? Icons.undo : Icons.add),
                    label: Text(book.isBorrowed ? 'Return Book' : 'Borrow Book'),
                    onPressed: () {
                      if (book.isBorrowed) {
                        library.returnBook(book);
                      } else {
                        library.borrow(book);
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}