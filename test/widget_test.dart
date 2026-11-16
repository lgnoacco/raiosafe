// Teste básico de smoke test do RaioSafe:
// garante que o app sobe e mostra a tela de login.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:raiosafe/main.dart';

void main() {
  testWidgets('RaioSafe abre na tela de login', (WidgetTester tester) async {
    await tester.pumpWidget(const RaioSafeApp());
    await tester.pumpAndSettle();

    expect(find.text('RaioSafe'), findsOneWidget);
    expect(find.text('Entrar'), findsOneWidget);
  });
}
