import 'package:azimut_web/Components/UniversityBanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Photo banner advances automatically and can be paused', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: UniversityBanner())),
    );
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 6));
    await tester.pumpAndSettle();
    const secondSlide = 'Санкт-Петербургский государственный университет';
    expect(find.text(secondSlide), findsOneWidget);

    await tester.tap(find.byTooltip('Приостановить автопрокрутку'));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 12));
    await tester.pumpAndSettle();
    expect(find.text(secondSlide), findsOneWidget);
  });

  testWidgets('Photo banner switches slides and wraps', (tester) async {
    tester.view.physicalSize = const Size(320, 740);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Padding(padding: EdgeInsets.all(24), child: UniversityBanner()),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('МГУ имени М. В. Ломоносова'), findsOneWidget);
    for (final caption in [
      'Санкт-Петербургский государственный университет',
      'Уральский федеральный университет',
      'МГУ имени М. В. Ломоносова',
    ]) {
      await tester.tap(find.byTooltip('Следующий слайд'));
      await tester.pumpAndSettle();
      expect(find.text(caption), findsOneWidget);
    }
    await tester.drag(find.byType(PageView), const Offset(-240, 0));
    await tester.pumpAndSettle();
    expect(
      find.text('Санкт-Петербургский государственный университет'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });
}
