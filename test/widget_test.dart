import 'package:fastlocation/src/modules/home/components/empty_search.dart';
import 'package:fastlocation/src/modules/initial/page/initial_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('splash exibe o nome do app', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: InitialPage()));
    await tester.pump(const Duration(seconds: 2));
    expect(find.text('FastLocation'), findsOneWidget);
    // Evita timer pendente: descarta a página.
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('componente de busca vazia', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: EmptySearch())),
    );
    expect(find.text('Nenhum endereço encontrado'), findsOneWidget);
  });
}
