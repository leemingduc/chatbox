import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/chat_message.dart';
import 'career_bot_service.dart';

class GeminiService {
  // Default API key for high school career guidance AI
  static const String _defaultApiKey = '';
  static const String _envApiKey = String.fromEnvironment('GEMINI_API_KEY');
  static String get _apiKey => _envApiKey.isNotEmpty ? _envApiKey : _defaultApiKey;
  static bool get isApiKeyConfigured => _apiKey.isNotEmpty;

  // Gemini REST API endpoint (compatible with Flutter Web / CORS)
  static String get _endpoint =>
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-3.1-flash-lite:generateContent?key=$_apiKey';

  static const String _systemPromptVi = '''
Bạn là một Chuyên Gia Tư Vấn Hướng Nghiệp & Tuyển Sinh Đại Học cho học sinh Trung học Phổ thông (THPT) tại Việt Nam.

QUY TẮC ĐỊNH DẠNG & ỨNG XỬ BẮT BUỘC:
- KHÔNG BAO GIỜ sử dụng ký tự định dạng Markdown như dấu sao (*, **), hoặc dấu thăng (#) trong câu trả lời.
- Sử dụng phong phú các biểu tượng emoji (như 📊, 📚, 🏫, 🚀, 💡, 📍, 🌟, 🎯, ❓) để trình bày nội dung sinh động, gần gũi, thân thiện và tránh cảm giác máy móc.

CẤU TRÚC PHẢN HỒI THEO BỐI CẢNH:
1. Khi tư vấn LẦN ĐẦU: Đảm bảo đủ 5 mục (1. 📊 Đánh giá Mức độ Phù hợp Match Rating %, 2. 📚 Tổ hợp môn & Khối thi THPT, 3. 🏫 Gợi ý Ngành & Top Trường Đại học tại Việt Nam, 4. 🚀 Lời khuyên & Lộ trình chuẩn bị, 5. ❓ Tương tác gợi mở).
2. Khi HỌC SINH HỎI VẶN / PHẢN BIỆN / BỔ SUNG ĐIỀU KIỆN MỚI: Trả lời trực diện, đi thẳng vào thắc mắc chính, KHÔNG cần lặp lại rập khuôn cả 5 mục.

QUY TẮC TIẾP NHẬN & PHẢN BIỆN (RẤT QUAN TRỌNG):
- LẮNG NGHE & CẦU THỊ: Khi học sinh đưa ra ý kiến vặn lại (như yếu môn Lý, không thích miền Bắc, điểm chuẩn thay đổi...), hãy công nhận và thấu hiểu góc nhìn của học sinh. Tuyệt đối KHÔNG khư khư bảo vệ quan điểm cũ.
- CHẮT LỌC & ĐIỀU CHỈNH: Phân tích ngay thông tin mới, lọc lại tiêu chí và đề xuất giải pháp/tổ hợp môn/trường đại học thay thế phù hợp hơn.
- XIN CẬP NHẬT THÔNG TIN: Nếu thông tin chưa rõ hoặc có mâu thuẫn, hãy lịch sự hỏi lại để học sinh cung cấp thêm chi tiết trước khi kết luận.
''';

  static const String _systemPromptEn = '''
You are a Senior High School Career & University Admissions Counselor in Vietnam.

STRICT FORMATTING & BEHAVIOR RULES:
- NEVER use Markdown symbols like asterisks (*, **) or hashes (#) in your response.
- Use engaging emojis (such as 📊, 📚, 🏫, 🚀, 💡, 📍, 🌟, 🎯, ❓) to keep the text friendly, natural, and expressive.

CONTEXT-AWARE RESPONSE STRUCTURE:
1. INITIAL INQUIRY: Provide a comprehensive 5-part response (1. 📊 Suitability Match Rating %, 2. 📚 Subject Combinations & Exam Tracks, 3. 🏫 Majors & Top Universities in Vietnam, 4. 🚀 Actionable Roadmap, 5. ❓ Interactive Guidance).
2. PUSHBACK / FOLLOW-UP INQUIRY: Address the user's specific challenge directly and concisely without forcing the full 5-part format.

ACTIVE LISTENING & ADAPTABILITY RULES (CRITICAL):
- RECEPTIVE & HUMBLE: When a student challenges a recommendation or introduces new constraints (e.g., weak in Physics, location preference, changed scores), acknowledge their feedback warmly. NEVER stubbornly defend previous advice.
- FILTER & PIVOT: Instantly analyze new inputs, refine criteria, and present optimal alternative options (e.g., alternative subject tracks, regional universities, related majors).
- REQUEST INFORMATION UPDATES: If details are ambiguous or conflicting, politely ask the student for updated details before finalizing advice.
''';

  static Future<CareerBotResult> generateResponse({
    required List<ChatMessage> chatHistory,
    required String userPrompt,
    required String localeCode,
  }) async {
    final isVi = localeCode == 'vi';

    // Fallback immediately if no API key
    if (!isApiKeyConfigured) {
      return _localFallback(userPrompt, localeCode, isVi, showNotice: false);
    }

    try {
      final systemText = isVi ? _systemPromptVi : _systemPromptEn;

      // Build multi-turn conversation history array (roles: user / model)
      final List<Map<String, dynamic>> contents = [];

      for (final msg in chatHistory) {
        contents.add({
          'role': msg.isUser ? 'user' : 'model',
          'parts': [
            {'text': msg.text}
          ],
        });
      }

      // Add current user message to conversation history
      contents.add({
        'role': 'user',
        'parts': [
          {'text': userPrompt}
        ],
      });

      // Build generateContent request body with systemInstruction
      final body = jsonEncode({
        'systemInstruction': {
          'parts': [
            {'text': systemText}
          ]
        },
        'contents': contents,
        'generationConfig': {
          'temperature': 0.7,
          'maxOutputTokens': 1024,
        },
      });

      final response = await http
          .post(
            Uri.parse(_endpoint),
            headers: {'Content-Type': 'application/json'},
            body: body,
          )
          .timeout(const Duration(seconds: 20));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final rawText = data['candidates']?[0]?['content']?['parts']?[0]?['text'] as String?;

        if (rawText != null && rawText.trim().isNotEmpty) {
          // Strip out any asterisks or hashes to strictly fulfill non-robotic formatting request
          final cleanedText = rawText.replaceAll('*', '').replaceAll('#', '').trim();
          return CareerBotResult(
            category: 'GeminiAI',
            text: cleanedText,
            followUps: _generateFollowUps(userPrompt, isVi),
          );
        } else {
          throw Exception('Empty Gemini response');
        }
      } else {
        // Parse API error message
        final errData = jsonDecode(response.body);
        final errMsg = errData['error']?['message'] ?? 'HTTP ${response.statusCode}';
        throw Exception('Gemini API Error: $errMsg');
      }
    } catch (e) {
      return _localFallback(userPrompt, localeCode, isVi, showNotice: true);
    }
  }

  static CareerBotResult _localFallback(
    String userPrompt,
    String localeCode,
    bool isVi, {
    required bool showNotice,
  }) {
    final fallback = CareerBotService.getResponse(userPrompt, localeCode);
    final notice = showNotice
        ? isVi
            ? '\n\n*(Lưu ý: Đang sử dụng chế độ tư vấn nội địa do gián đoạn kết nối Gemini API)*'
            : '\n\n*(Notice: Using local counselor mode — Gemini API connection unavailable)*'
        : '';

    return CareerBotResult(
      category: showNotice ? 'LocalFallback' : fallback.category,
      text: '${fallback.text}$notice',
      followUps: fallback.followUps,
    );
  }

  static List<String> _generateFollowUps(String userPrompt, bool isVi) {
    final lower = userPrompt.toLowerCase();
    if (lower.contains('stem') || lower.contains('công nghệ') || lower.contains('tech') || lower.contains('it')) {
      return isVi
          ? ['Trường đại học đào tạo CNTT uy tín?', 'Học CNTT cần điểm khối thi nào?', 'Cơ hội việc làm ngành AI?']
          : ['Top Computer Science Universities?', 'Which subject combos for IT?', 'AI Career prospects?'];
    }
    if (lower.contains('holland') || lower.contains('riasec') || lower.contains('tính cách')) {
      return isVi
          ? ['Nhóm Social (S) làm nghề gì?', 'Cách làm bài test Holland chuẩn?', 'Chọn ngành theo tính cách']
          : ['Careers for Social (S) type?', 'How to take full Holland test?', 'Pick major by personality'];
    }
    if (lower.contains('khối') || lower.contains('a00') || lower.contains('d01') || lower.contains('b00')) {
      return isVi
          ? ['Điểm chuẩn khối A00 năm nay?', 'Khối D01 phù hợp ngành gì?', 'Chọn khối thi theo sở thích']
          : ['Cut-off scores for A00?', 'Best majors for D01?', 'How to choose subjects by interest'];
    }
    return isVi
        ? ['Tôi muốn tư vấn chọn khối thi THPT', 'Trắc nghiệm tính cách chọn ngành', 'Khối ngành Kinh tế & Marketing']
        : ['Help me pick subject combinations', 'Personality tests for majors', 'Business & Marketing tracks'];
  }
}
