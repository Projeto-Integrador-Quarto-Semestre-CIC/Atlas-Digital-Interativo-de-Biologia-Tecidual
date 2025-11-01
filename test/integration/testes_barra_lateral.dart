import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:app_pii/pages/tecido.dart';
import 'package:app_pii/components/barra_lateral.dart';
import 'package:app_pii/components/viewer.dart';

void main() {
  Viewer.modoTeste = true;
  
  group('Responsividade da Barra Lateral', () {
    testWidgets('Exibe BarraLateral em telas grandes (>= 900px)',
        (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 800));

      await tester.pumpWidget(const MaterialApp(
        home: PaginaTecido(
          nome: 'Tecido X',
          descricao: 'Descrição',
          referenciasBibliograficas: 'Referência 1\n Referência 2',
          tileSource: "http://localhost:8000/002_dzi/002.dzi"
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(BarraLateral), findsOneWidget);

      expect(find.byType(BarraLateralDrawer), findsNothing);
      expect(find.byIcon(Icons.menu), findsNothing);
    });

    testWidgets('Exibe menu hamburger e abre Drawer em telas pequenas (< 900px)',
        (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 800));

      await tester.pumpWidget(const MaterialApp(
        home: PaginaTecido(
          nome: 'Tecido X',
          descricao: 'Descrição',
          referenciasBibliograficas: 'Referência 1\n Referência 2',
          tileSource: "http://localhost:8000/002_dzi/002.dzi"
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.byType(BarraLateral), findsNothing);

      expect(find.byIcon(Icons.menu), findsOneWidget);

      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      expect(find.byType(BarraLateralDrawer), findsOneWidget);

      expect(find.text('LOGIN PARA EDITORES'), findsOneWidget);
      expect(find.text('EXPLORAR'), findsOneWidget);
      expect(find.text('CONTATO'), findsOneWidget);
    });
  });
}
