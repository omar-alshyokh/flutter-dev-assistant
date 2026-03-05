import '../models/faq_item.dart';

class FaqDataSource {
  const FaqDataSource();

  List<FaqItem> getAll() => const [
    FaqItem(
      id: "state_mgmt_start",
      question: "Which state management should I start with in Flutter?",
      answer:
          "Start with setState for tiny screens, then move to Provider or Riverpod for scalable apps. For event-heavy flows, BLoC/Cubit works well.",
      keywords: [
        "state management",
        "provider",
        "riverpod",
        "bloc",
        "cubit",
        "setstate",
      ],
    ),
    FaqItem(
      id: "folder_structure",
      question: "What is a clean folder structure for medium Flutter apps?",
      answer:
          "Use feature-first structure: features/<feature>/{data,domain,presentation}. Keep shared code in core/ for theme, network, routing, and utils.",
      keywords: [
        "folder",
        "structure",
        "clean architecture",
        "feature first",
        "core",
        "layers",
      ],
    ),
    FaqItem(
      id: "const_widgets",
      question: "Why should I use const widgets often?",
      answer:
          "const reduces rebuild cost by reusing widget instances when inputs do not change. This improves UI performance, especially in long widget trees.",
      keywords: ["const", "rebuild", "performance", "optimize", "widget tree"],
    ),
    FaqItem(
      id: "async_init",
      question: "Where should I initialize services before runApp?",
      answer:
          "Initialize async services in main() after WidgetsFlutterBinding.ensureInitialized(), then call runApp once setup is complete.",
      keywords: ["main", "runapp", "initialize", "services", "startup"],
    ),
    FaqItem(
      id: "navigation_choice",
      question: "Should I use go_router or Navigator 2.0 directly?",
      answer:
          "Use go_router for most production apps because it simplifies deep linking and route guards. Use raw Navigator 2.0 only when you need full low-level control.",
      keywords: ["go_router", "navigator", "routing", "deep link", "guards"],
    ),
    FaqItem(
      id: "api_layer",
      question: "How should I design API and repository layers in Flutter?",
      answer:
          "Keep API calls in data sources, map DTOs to domain entities, and expose use-case friendly methods from repositories. This keeps presentation code clean and testable.",
      keywords: ["api", "repository", "datasource", "dto", "entity", "domain"],
    ),
    FaqItem(
      id: "error_handling_ui",
      question: "How do I handle API errors in Flutter UI cleanly?",
      answer:
          "Model UI states (loading/success/error) in Cubit or BLoC, map network errors to friendly messages, and show retriable actions instead of raw stack traces.",
      keywords: ["error", "api", "network", "bloc", "cubit", "retry"],
    ),
    FaqItem(
      id: "testing_start",
      question: "What Flutter tests should I write first?",
      answer:
          "Start with widget tests for critical screens and unit tests for business logic (Cubit/use-cases). Add integration tests only for key user journeys.",
      keywords: ["test", "widget test", "unit test", "integration", "quality"],
    ),
    FaqItem(
      id: "app_perf",
      question: "How can I improve Flutter app performance quickly?",
      answer:
          "Profile with Flutter DevTools, avoid unnecessary rebuilds, use const widgets, and move heavy work off the UI thread with isolates when needed.",
      keywords: ["performance", "devtools", "rebuild", "isolate", "optimize"],
    ),
    FaqItem(
      id: "cross_platform_ui",
      question: "How do I keep UI good on Android, iOS, and web?",
      answer:
          "Use responsive layouts (LayoutBuilder/MediaQuery), avoid fixed sizes, test on multiple screen classes, and adapt interactions for touch and pointer devices.",
      keywords: [
        "responsive",
        "android",
        "ios",
        "web",
        "crossplatform",
        "layout",
      ],
    ),
  ];
}
