import 'package:flutter_test/flutter_test.dart';

import 'package:culturelocal/main.dart';

void main() {
  testWidgets('renders firebase setup fallback when config is missing', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const CultureLocalApp());
    await tester.pumpAndSettle();

    expect(find.text('Firebase pendente'), findsOneWidget);
  });
}
