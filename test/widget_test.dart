import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_chatbot/features/chat/presentation/widgets/suggested_questions.dart';

void main() {
  testWidgets('renders full suggested question text', (
    WidgetTester tester,
  ) async {
    const question =
        'How should I design API and repository layers in Flutter?';

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SuggestedQuestions(questions: const [question], onTap: (_) {}),
        ),
      ),
    );

    expect(find.text(question), findsOneWidget);
  });
}
