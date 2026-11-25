import 'package:flutter/material.dart';

import '../models/book.dart';
import '../models/library.dart';

class BookFormScreen extends StatefulWidget {
  final Library library;
  final Book? book; // null = add, not null = edit

  const BookFormScreen({super.key, required this.library, this.book});

  @override
  State<BookFormScreen> createState() => _BookFormScreenState();
}

class _BookFormScreenState extends State<BookFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _author;
  late final TextEditingController _genre;

  bool get _isEditing => widget.book != null;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text: widget.book?.title ?? '');
    _author = TextEditingController(text: widget.book?.author ?? '');
    _genre = TextEditingController(text: widget.book?.genre ?? '');
  }

  @override
  void dispose() {
    _title.dispose();
    _author.dispose();
    _genre.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final title = _title.text.trim();
    final author = _author.text.trim();
    final genre = _genre.text.trim();

    if (_isEditing) {
      final b = widget.book!;
      widget.library.updateBook(Book(
        id: b.id,
        title: title,
        author: author,
        genre: genre,
        isBorrowed: b.isBorrowed,
        dueDate: b.dueDate,
      ));
    } else {
      widget.library.addBook(title, author, genre);
    }
    Navigator.pop(context);
  }

  String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Required' : null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? 'Edit Book' : 'Add Book')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _title,
                decoration: const InputDecoration(
                    labelText: 'Title', border: OutlineInputBorder()),
                validator: _required,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _author,
                decoration: const InputDecoration(
                    labelText: 'Author', border: OutlineInputBorder()),
                validator: _required,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _genre,
                decoration: const InputDecoration(
                    labelText: 'Genre', border: OutlineInputBorder()),
                validator: _required,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _save,
                  child: Text(_isEditing ? 'Save Changes' : 'Add Book'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}