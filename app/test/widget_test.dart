import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cadence/main.dart';

void main() {
  testWidgets('App does not throw on initial mount', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: CadenceApp()));
    await tester.pump();
    // The full onboarding flow depends on real platform channels (database,
    // notifications) that `flutter test` can't provide — that path is
    // covered by manual device verification instead. This just guards
    // against a crash on first frame.
    expect(tester.takeException(), isNull);
  });
}
