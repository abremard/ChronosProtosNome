import 'package:flutter_test/flutter_test.dart';

import 'package:metronome/main.dart';

void main() {
  testWidgets('Metronome smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the metronome starts at 100 BPM.
    expect(find.text('100'), findsOneWidget);
    expect(find.text('BPM*'), findsOneWidget);
  });
}
