import 'package:course_ledger/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('app boots to the shell with the positioning line',
      (tester) async {
    await tester.pumpWidget(const CourseLedgerApp());

    expect(find.text('Course Ledger'), findsOneWidget);
    expect(
      find.text('The book of everywhere you’ve played.'),
      findsOneWidget,
    );
  });
}
