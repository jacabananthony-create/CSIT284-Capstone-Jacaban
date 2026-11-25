import 'package:flutter/material.dart';

import '../models/book.dart';
import '../models/library.dart';
import 'book_form_screen.dart';

class DetailScreen extends StatelessWidget {
  final Library library;
  final Book book;

  const DetailScreen({super.key, required this.library, required this.book});

  Future<void> _confirmDelete(BuildContext context, Book current) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete book?'),
        content: Text('"${current.title}" will be removed.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Delete')),
        ],
      ),
    );
    if (ok == true) {
      library.deleteBook(current.id);
      if (context.mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: library,
      builder: (context, _) {
        // latest version of this book from Firestore
        final current =
            library.books.firstWhere((b) => b.id == book.id, orElse: () => book);

        return Scaffold(
          appBar: AppBar(
            title: Text(current.title),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                tooltip: 'Edit',
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        BookFormScreen(library: library, book: current),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                tooltip: 'Delete',
                onPressed: () => _confirmDelete(context, current),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(child: Icon(Icons.menu_book, size: 96)),
                const SizedBox(height: 24),
                Text(current.title,
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 8),
                Text('by ${current.author}'),
                Text('Genre: ${current.genre}'),
                const SizedBox(height: 16),
                if (!current.isBorrowed)
                  const Text('Status: Available',
                      style: TextStyle(color: Colors.green))
                else
                  Text(
                    current.isOverdue
                        ? 'Status: OVERDUE (was due ${formatDate(current.dueDate!)})'
                        : 'Status: Borrowed - due ${formatDate(current.dueDate!)}',
                    style: TextStyle(
                      color: current.isOverdue ? Colors.red : Colors.orange,
                    ),
                  ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    icon: Icon(current.isBorrowed ? Icons.undo : Icons.add),
                    label: Text(
                        current.isBorrowed ? 'Return Book' : 'Borrow Book'),
                    onPressed: () {
                      if (current.isBorrowed) {
                        library.returnBook(current);
                      } else {
                        library.borrow(current);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}