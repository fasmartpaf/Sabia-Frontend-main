import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sabia_app/components/book/book_image_widget.dart';

void main() {
  testWidgets("Test BookImageWidget alt", (WidgetTester tester) async {
    await _createWidget(
        tester,
        BookImageWidget(
          alt: "Teste Livro",
        ));

    expect(find.text("Teste Livro"), findsOneWidget);
  });

  testWidgets("Test BookImageWidget imageUrl", (WidgetTester tester) async {
    await _createWidget(
        tester,
        BookImageWidget(
          alt: "Teste Livro",
          imageUrl:
              "https://firebasestorage.googleapis.com/v0/b/sabia-dev.appspot.com/o/books%2F-M7dbSk2Ts5xTe3IVTNY%2F5b94b7ee-82f1-43f6-b2da-c90b8c540808_0_900x1200.jpg?alt=media&token=fefddbcb-d799-4a9e-86a7-bb95daaec2fc",
        ));

    expect(find.text("Teste Livro"), findsNothing);
  });
}

Future<void> _createWidget(WidgetTester tester, Widget child) async {
  await tester.pumpWidget(
    MaterialApp(
      title: "Sabiá",
      theme: ThemeData.light(),
      home: child,
    ),
  );

  await tester.pump();
}
