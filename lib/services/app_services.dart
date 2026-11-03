import 'ai_service.dart';

class AppServices {
  static final AIService ai = _createAIService();

  static AIService _createAIService() {
    const endpoint = String.fromEnvironment('AI_BACKEND_URL');
    if (endpoint.isEmpty) return const RuleBasedAIService();
    return HttpAIService(endpoint: Uri.parse(endpoint));
  }
}
