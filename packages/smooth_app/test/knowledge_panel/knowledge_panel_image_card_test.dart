import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:smooth_app/knowledge_panel/knowledge_panels/knowledge_panel_image_card.dart';

void main() {
  group('KnowledgePanelImageCard', () {
    testWidgets('renders Image.network without inkwell when linkUrl is null', (
      WidgetTester tester,
    ) async {
      const KnowledgePanelImageElement element = KnowledgePanelImageElement(
        url: 'https://images.openfoodfacts.org/images/misc/test.png',
        width: 120,
        height: 80,
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: KnowledgePanelImageCard(imageElement: element),
          ),
        ),
      );

      expect(find.byType(Image), findsOneWidget);
      expect(find.byType(InkWell), findsNothing);

      final Image imageWidget = tester.widget<Image>(find.byType(Image));
      expect(imageWidget.width, equals(120.0));
      expect(imageWidget.height, equals(80.0));
      expect(imageWidget.loadingBuilder, isNotNull);
      expect(imageWidget.errorBuilder, isNotNull);
    });

    testWidgets('renders InkWell wrapper when linkUrl is provided', (
      WidgetTester tester,
    ) async {
      const KnowledgePanelImageElement element = KnowledgePanelImageElement(
        url: 'https://images.openfoodfacts.org/images/misc/test.png',
        width: 200,
        height: 100,
        linkUrl: 'https://openfoodfacts.org',
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: KnowledgePanelImageCard(imageElement: element),
          ),
        ),
      );

      expect(find.byType(Image), findsOneWidget);
      expect(find.byType(InkWell), findsOneWidget);
    });
  });
}
