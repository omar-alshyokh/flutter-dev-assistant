class FaqItem {
  final String id;
  final String question;
  final String answer;
  final List<String> keywords;

  const FaqItem({
    required this.id,
    required this.question,
    required this.answer,
    required this.keywords,
  });
}