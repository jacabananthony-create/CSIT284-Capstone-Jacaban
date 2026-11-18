import 'package:flutter/material.dart';

import '../models/book.dart';
import '../models/library.dart';

class HistoryScreen extends StatelessWidget {
  final Library library;

  const HistoryScreen({super.key, required this.library});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Borrowing History')),
      body: ListenableBuilder(
        listenable: library,
        builder: (context, _) {
          final records = library.history;
          if (records.isEmpty) {
            return const Center(child: Text('No borrowing history yet.'));
          }
          return ListView.builder(
            itemCount: records.length,
            itemBuilder: (context, i) {
              final r = records[i];
              return ListTile(
                leading: Icon(
                  r.isReturned ? Icons.check_circle : Icons.schedule,
                  color: r.isReturned ? Colors.green : Colors.orange,
                ),
                title: Text(r.bookTitle),
                subtitle: Text(
                  'Borrowed ${formatDate(r.borrowedOn)}'
                  '${r.isReturned ? ' - Returned ${formatDate(r.returnedOn!)}' : ' - Not yet returned'}',
                ),
              );
            },
          );
        },
      ),
    );
  }
}