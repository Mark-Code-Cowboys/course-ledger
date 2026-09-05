import 'package:flutter_test/flutter_test.dart';

import 'helpers.dart';

void main() {
  testWidgets('app boots to an empty ledger with the positioning line',
      (tester) async {
    final db = makeTestDb();
    addTearDown(db.close);

    await tester.pumpWidget(testApp(db: db));
    await tester.pumpAndSettle();

    expect(find.text('Course Ledger'), findsOneWidget);
    expect(
      find.text('The book of everywhere you’ve played.'),
      findsOneWidget,
    );
    await disposeApp(tester);
  });
}
