import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:openfoodfacts/openfoodfacts.dart';
import 'package:provider/provider.dart';
import 'package:smooth_app/l10n/app_localizations.dart';
import 'package:smooth_app/pages/prices/price_amount_field.dart';
import 'package:smooth_app/pages/prices/price_amount_model.dart';
import 'package:smooth_app/pages/prices/price_meta_product.dart';
import 'package:smooth_app/pages/prices/price_model.dart';

class _TestPriceModel extends PriceModel {
  _TestPriceModel()
      : super(
          proofType: ProofType.receipt,
          currency: Currency.EUR,
          multipleProducts: false,
        );
}

void main() {
  testWidgets('PriceAmountField binds focusNode and textInputAction', (
    WidgetTester tester,
  ) async {
    final PriceAmountModel model = PriceAmountModel(
      product: PriceMetaProduct.product(Product(barcode: '12345678')),
    );
    final TextEditingController controller = TextEditingController();
    final FocusNode focusNode = FocusNode();

    await tester.pumpWidget(
      ChangeNotifierProvider<PriceModel>(
        create: (_) => _TestPriceModel(),
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: PriceAmountField(
              model: model,
              isPaidPrice: true,
              controller: controller,
              textInputAction: TextInputAction.next,
              focusNode: focusNode,
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    final TextField textField = tester.widget<TextField>(
      find.byType(TextField),
    );
    expect(textField.textInputAction, equals(TextInputAction.next));
    expect(textField.focusNode, equals(focusNode));

    // Verify typing updates model.paidPrice
    await tester.enterText(find.byType(TextField), '3.99');
    expect(model.paidPrice, equals('3.99'));

    controller.dispose();
    focusNode.dispose();
  });

  testWidgets('PriceAmountField for non-discounted price updates model', (
    WidgetTester tester,
  ) async {
    final PriceAmountModel model = PriceAmountModel(
      product: PriceMetaProduct.product(Product(barcode: '12345678')),
    );
    final TextEditingController controller = TextEditingController();
    final FocusNode focusNode = FocusNode();

    await tester.pumpWidget(
      ChangeNotifierProvider<PriceModel>(
        create: (_) => _TestPriceModel(),
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: PriceAmountField(
              model: model,
              isPaidPrice: false,
              controller: controller,
              textInputAction: TextInputAction.done,
              focusNode: focusNode,
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    final TextField textField = tester.widget<TextField>(
      find.byType(TextField),
    );
    expect(textField.textInputAction, equals(TextInputAction.done));

    await tester.enterText(find.byType(TextField), '4.50');
    expect(model.priceWithoutDiscount, equals('4.50'));

    controller.dispose();
    focusNode.dispose();
  });
}
