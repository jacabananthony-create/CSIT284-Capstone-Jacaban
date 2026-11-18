import 'package:flutter_test/flutter_test.dart';

import 'package:capstone_jacaban/main.dart';

void main() {
  testWidgets('Home screen shows the book list', (tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Book Borrowing Tracker'), findsOneWidget);
    expect(find.text('Clean Code'), findsOneWidget);
  });
}