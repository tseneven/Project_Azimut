import 'dart:convert';

import 'package:azimut_web/Components/LeftBar.dart';
import 'package:azimut_web/Constants/AppSection.dart';
import 'package:azimut_web/Helpers/CookieHelpers.dart';
import 'package:azimut_web/material_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> openApp(WidgetTester tester, Size size) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const MaterialAppFrame());
    await tester.pumpAndSettle();
  }

  testWidgets('Landing CTA opens matching and the brand returns home', (
    tester,
  ) async {
    await openApp(tester, const Size(390, 844));
    final cta = find.text('Подобрать по баллам');
    await tester.tap(cta);
    await tester.pumpAndSettle();
    expect(find.text(AppSection.matching.description), findsOneWidget);

    await tester.tap(find.text('Azimut'));
    await tester.pumpAndSettle();
    expect(cta, findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Desktop sidebar contains only public tools', (tester) async {
    await openApp(tester, const Size(1280, 900));
    final sidebar = find.byType(LeftBar);
    expect(sidebar, findsOneWidget);
    Finder inSidebar(String title) =>
        find.descendant(of: sidebar, matching: find.text(title));
    expect(inSidebar('Избранное'), findsNothing);
    expect(inSidebar('Сравнение программ'), findsNothing);
    expect(inSidebar('Моё поступление'), findsNothing);
    await tester.tap(inSidebar('К сравнению →'));
    await tester.pumpAndSettle();
    expect(find.text(AppSection.comparison.description), findsOneWidget);
    await tester.tap(inSidebar('Вузы'));
    await tester.pumpAndSettle();
    expect(find.text(AppSection.universities.description), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('All personal sections open from desktop account menu', (
    tester,
  ) async {
    await openApp(tester, const Size(1280, 900));
    for (final section in [
      AppSection.favorites,
      AppSection.comparison,
      AppSection.admissions,
    ]) {
      await tester.tap(find.byTooltip('Аккаунт'));
      await tester.pumpAndSettle();
      await tester.tap(
        find.byWidgetPredicate(
          (widget) =>
              widget is PopupMenuItem<AppSection> && widget.value == section,
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text(section.description), findsOneWidget);
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('Mobile drawer closes after choosing a public tool', (
    tester,
  ) async {
    await openApp(tester, const Size(390, 844));
    await tester.tap(find.byTooltip('Открыть меню'));
    await tester.pumpAndSettle();
    expect(find.text('Избранное'), findsNothing);
    await tester.tap(find.text('Калькулятор баллов'));
    await tester.pumpAndSettle();
    expect(find.text(AppSection.calculator.description), findsOneWidget);
    final scaffold = tester.state<ScaffoldState>(find.byType(Scaffold).first);
    expect(scaffold.isDrawerOpen, isFalse);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Account menu works on a narrow mobile screen', (tester) async {
    await openApp(tester, const Size(320, 740));
    await tester.tap(find.byTooltip('Аккаунт'));
    await tester.pumpAndSettle();
    await tester.tap(
      find.widgetWithText(PopupMenuItem<AppSection>, 'Моё поступление'),
    );
    await tester.pumpAndSettle();
    expect(find.text(AppSection.admissions.description), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'Account menu opens both auth screens and they link to each other',
    (tester) async {
      await openApp(tester, const Size(390, 844));
      await tester.tap(find.byTooltip('Аккаунт'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(PopupMenuItem<AppSection>, 'Войти'));
      await tester.pumpAndSettle();
      expect(find.text('Вход в Azimut'), findsOneWidget);

      await tester.tap(find.byTooltip('Показать пароль'));
      await tester.pumpAndSettle();
      expect(find.byTooltip('Скрыть пароль'), findsOneWidget);
      await tester.tap(find.widgetWithText(TextButton, 'Зарегистрироваться'));
      await tester.pumpAndSettle();
      expect(find.text('Создайте аккаунт'), findsOneWidget);
      await tester.ensureVisible(
        find.widgetWithText(FilledButton, 'Зарегистрироваться'),
      );
      await tester.tap(find.widgetWithText(FilledButton, 'Зарегистрироваться'));
      await tester.pumpAndSettle();
      expect(find.text('Введите имя.'), findsOneWidget);

      await tester.tap(find.text('Azimut'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Аккаунт'));
      await tester.pumpAndSettle();
      await tester.tap(
        find.widgetWithText(PopupMenuItem<AppSection>, 'Зарегистрироваться'),
      );
      await tester.pumpAndSettle();
      expect(find.text('Создайте аккаунт'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('Account menu clears the signed-in session on logout', (
    tester,
  ) async {
    final expiry = DateTime.now().add(const Duration(minutes: 10));
    final payload = base64Url.encode(
      utf8.encode(jsonEncode({'exp': expiry.millisecondsSinceEpoch ~/ 1000})),
    );
    CookieHelpers.SetToken('header.$payload.signature');
    addTearDown(CookieHelpers.RemoveToken);

    await openApp(tester, const Size(390, 844));
    await tester.tap(find.byTooltip('Аккаунт'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(PopupMenuItem<AppSection>, 'Выйти'));
    await tester.pumpAndSettle();
    expect(CookieHelpers.HasToken(), isFalse);
    await tester.tap(find.byTooltip('Аккаунт'));
    await tester.pumpAndSettle();
    expect(
      find.widgetWithText(PopupMenuItem<AppSection>, 'Войти'),
      findsOneWidget,
    );
  });
}
