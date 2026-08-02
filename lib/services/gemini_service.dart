import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/chat_message.dart';
import 'career_bot_service.dart';

class GeminiService {
  // Read API Key from --dart-define=GEMINI_API_KEY
  static const String _apiKey = String.fromEnvironment('GEMINI_API_KEY');

  static bool get isApiKeyConfigured => _apiKey.isNotEmpty;

  static const String _systemPromptVi = '''
Bạn là một **Tư Vấn Viên Hướng Nghiệp Chuyên Nghiệp** dành riêng cho học sinh Trung học Phổ thông (THPT) tại Việt Nam.

Nhiệm vụ & Quy tắc ứng xử bắt buộc:
1. **Tương tác & Hỏi ngược lại**: Trước khi đưa ra kết luận chọn ngành, hãy hỏi lại học sinh về: lớp học hiện tại (lớp 10, 11, 12), sở thích cá nhân, các môn học thế mạnh (Toán, Văn, Anh, Lý, Hóa, Sinh...), và định hướng khối thi mục tiêu (A00, A01, B00, C00, D01, D07...).
2. **Định hướng chi tiết**: Khi gợi ý ngành học, hãy đề xuất 2-3 ngành phù hợp nhất kèm theo:
   - Lý do vì sao ngành đó phù hợp với thông tin của học sinh.
   - Khối thi xét tuyển tương ứng (ví dụ: A00, D01...).
   - Cơ hội nghề nghiệp và kỹ năng cần rèn luyện từ bậc THPT.
3. **Giới hạn phạm vi (Strict Scope)**: Bạn CHỈ trả lời các câu hỏi liên quan đến hướng nghiệp, ngành học đại học/cao đẳng, khối thi THPT, trắc nghiệm tính cách Holland/RIASEC, và phát triển kỹ năng cho học sinh. Nếu người dùng hỏi chủ đề ngoài hướng nghiệp (như giải toán hộ, thời tiết, nấu ăn, lập trình ứng dụng ngoài...), hãy từ chối một cách lịch sự và lái câu chuyện quay lại chủ đề định hướng nghề nghiệp.
4. **Tông giọng**: Thân thiện, khuyến khích, tích cực, thấu hiểu tâm lý học sinh THPT.
''';

  static const String _systemPromptEn = '''
You are a **Professional High School Career & University Guidance Counselor**.

Mandatory Conduct & Rules:
1. **Interactive Assessment**: Before making final career recommendations, ask clarifying questions back to the student about their current grade (Grade 10, 11, or 12), favorite subjects, academic strengths, and personality traits.
2. **Tailored Recommendations**: Suggest 2-3 specific university majors with:
   - Clear justification based on the student's profile.
   - Corresponding high school subject combinations / tracks.
   - Career prospects and essential soft skills to build during high school.
3. **Strict Topic Scope**: ONLY respond to topics regarding high school career guidance, university majors, subject combinations, Holland RIASEC tests, and student skill development. Politely decline any off-topic questions (e.g. general homework solving, recipes, entertainment) and gently redirect back to career orientation.
4. **Tone**: Warm, encouraging, supportive, and empathetic toward high school students.
''';

  static Future<CareerBotResult> generateResponse({
    required List<ChatMessage> chatHistory,
    required String userPrompt,
    required String localeCode,
  }) async {
    final isVi = localeCode == 'vi';

    // If GEMINI_API_KEY is not configured via --dart-define, fallback to local service
    if (!isApiKeyConfigured) {
      final fallbackResult = CareerBotService.getResponse(userPrompt, localeCode);
      return CareerBotResult(
        category: fallbackResult.category,
        text: fallbackResult.text,
        followUps: fallbackResult.followUps,
      );
    }

    try {
      final systemInstructionText = isVi ? _systemPromptVi : _systemPromptEn;

      final model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: _apiKey,
        systemInstruction: Content.system(systemInstructionText),
      );

      // Construct multi-turn conversation history for Gemini
      final List<Content> contentsHistory = [];

      for (final msg in chatHistory) {
        if (msg.isUser) {
          contentsHistory.add(Content.text(msg.text));
        } else {
          contentsHistory.add(Content.model([TextPart(msg.text)]));
        }
      }

      // Append current user query
      contentsHistory.add(Content.text(userPrompt));

      // Call Gemini API generateContent
      final response = await model.generateContent(contentsHistory);
      final responseText = response.text;

      if (responseText != null && responseText.trim().isNotEmpty) {
        // Generate contextual follow-up suggestions
        final followUps = _generateFollowUps(userPrompt, isVi);
        return CareerBotResult(
          category: 'GeminiAI',
          text: responseText.trim(),
          followUps: followUps,
        );
      } else {
        throw Exception("Empty response from Gemini API");
      }
    } catch (e) {
      // Graceful error handling: Fallback to local career service on API failure
      final fallbackResult = CareerBotService.getResponse(userPrompt, localeCode);
      final errorNotice = isVi
          ? "\n\n*(Lưu ý: Đang sử dụng chế độ tư vấn nội địa do gián đoạn kết nối Gemini API)*"
          : "\n\n*(Notice: Operating in local counselor mode due to Gemini API connection issue)*";

      return CareerBotResult(
        category: 'LocalFallback',
        text: "${fallbackResult.text}$errorNotice",
        followUps: fallbackResult.followUps,
      );
    }
  }

  static List<String> _generateFollowUps(String userPrompt, bool isVi) {
    final lower = userPrompt.toLowerCase();
    if (lower.contains('stem') || lower.contains('công nghệ') || lower.contains('tech')) {
      return isVi
          ? ["Trường đại học đào tạo CNTT uy tín?", "Học CNTT cần điểm khối thi nào?", "Cơ hội việc làm ngành AI?"]
          : ["Top Computer Science Universities?", "Which subject combos for IT?", "AI Career prospects?"];
    }
    if (lower.contains('holland') || lower.contains('riasec') || lower.contains('tính cách')) {
      return isVi
          ? ["Nhóm tính cách Social (S) làm nghề gì?", "Cách làm bài test Holland chuẩn?", "Chọn ngành theo tính cách"]
          : ["Careers for Social (S) type?", "How to take full Holland test?", "Pick major by personality"];
    }
    return isVi
        ? ["Tôi muốn tư vấn chọn khối thi THPT", "Trắc nghiệm tính cách chọn ngành", "Khối ngành Kinh tế & Marketing"]
        : ["Help me pick subject combinations", "Personality tests for majors", "Business & Marketing tracks"];
  }
}
