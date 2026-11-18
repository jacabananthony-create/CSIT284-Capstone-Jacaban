import 'package:flutter/material.dart';

import '../models/library.dart';
import '../widgets/book_card.dart';
import 'detail_screen.dart';
import 'history_screen.dart';

class HomeScreen extends StatelessWidget {
  final Library library;

  const HomeScreen({super.key, required this.library});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Borrowing Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'Borrowing history',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => HistoryScreen(library: library),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              onChanged: library.setQuery,
              decoration: const InputDecoration(
                hintText: 'Search by title or author',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListenableBuilder(
              listenable: library,
              builder: (context, _) {
                final books = library.filteredBooks;
                if (books.isEmpty) {
                  return const Center(child: Text('No books found.'));
                }
                return ListView.builder(
                  itemCount: books.length,
                  itemBuilder: (context, i) => BookCard(
                    book: books[i],
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailScreen(
                          library: library,
                          book: books[i],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}