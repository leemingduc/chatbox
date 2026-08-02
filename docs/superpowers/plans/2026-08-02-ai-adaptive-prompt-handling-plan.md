# AI Adaptive & Receptive Prompt Handling Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Update `GeminiService` system prompts and `CareerBotService` local fallback logic so that when users challenge AI recommendations or supply new constraints (e.g., subject weakness, location preference), the AI responds adaptively with active listening, pivots options, and requests missing information without stubbornly holding its initial stance.

**Architecture:** Update `_systemPromptVi` and `_systemPromptEn` in `GeminiService` to explicitly guide multi-turn challenge handling, active listening, and adaptive option filtering. Update `CareerBotService` offline keywords/fallback logic to handle subject weaknesses (like physics) and location constraints gracefully. Add test cases in `test/gemini_service_test.dart`.

**Tech Stack:** Dart, Flutter Test, Gemini REST API (`generativelanguage.googleapis.com`).

## Global Constraints

- Never use markdown asterisks (`*`, `**`) or hashes (`#`) in system prompt output directives.
- Keep rich emoji usage (`📊`, `📚`, `🏫`, `🚀`, `💡`, `📍`, `🌟`, `🎯`, `❓`).
- Preserve backward compatibility with existing `generateResponse` method signature.

---

### Task 1: Update GeminiService System Prompts (`lib/services/gemini_service.dart`)

**Files:**
- Modify: `lib/services/gemini_service.dart:17-45`
- Create: `test/gemini_service_test.dart`

**Interfaces:**
- Consumes: `GeminiService._systemPromptVi`, `GeminiService._systemPromptEn`
- Produces: Enhanced System Prompts with rules for handling user challenges/pushback

- [ ] **Step 1: Write unit test for GeminiService prompt directives**

Create `test/gemini_service_test.dart`:
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:chatbox/services/gemini_service.dart';

void main() {
  test('GeminiService isApiKeyConfigured evaluates to true with default key', () {
    expect(GeminiService.isApiKeyConfigured, isTrue);
  });
}
```

- [ ] **Step 2: Run test to verify initial setup**

Run: `flutter test test/gemini_service_test.dart`
Expected: PASS

- [ ] **Step 3: Update `_systemPromptVi` and `_systemPromptEn` in `lib/services/gemini_service.dart`**

Update `_systemPromptVi` and `_systemPromptEn` to incorporate context-aware response structure, active listening, adaptive option filtering, and information update requests.

```dart
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
```

- [ ] **Step 4: Run flutter test to ensure all tests pass**

Run: `flutter test`
Expected: PASS

- [ ] **Step 5: Commit changes**

```bash
git add lib/services/gemini_service.dart test/gemini_service_test.dart
git commit -m "feat: enhance AI system prompts for receptive and adaptive challenge handling"
```

---

### Task 2: Enhance Offline Fallback Rule Engine (`lib/services/career_bot_service.dart`)

**Files:**
- Modify: `lib/services/career_bot_service.dart`
- Create: `test/career_bot_service_test.dart`

**Interfaces:**
- Consumes: `CareerBotService.getResponse(String prompt, String localeCode)`
- Produces: Enhanced fallback responses handling user constraints (weak subject, location)

- [ ] **Step 1: Write failing/new unit test in `test/career_bot_service_test.dart`**

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:chatbox/services/career_bot_service.dart';

void main() {
  test('CareerBotService handles subject weakness challenge (yếu lý)', () {
    final result = CareerBotService.getResponse('mình rất yếu môn lý thì học ngành gì', 'vi');
    expect(result.text, contains('tổ hợp môn khác'));
  });
}
```

- [ ] **Step 2: Run test to verify current output**

Run: `flutter test test/career_bot_service_test.dart`
Expected: Check output

- [ ] **Step 3: Update `CareerBotService` fallback keyword detection**

Update `lib/services/career_bot_service.dart` to include keyword matching for subject weaknesses ("yếu lý", "yếu hóa", "kém môn") and geographical preferences ("miền nam", "tphcm", "miền bắc") returning tailored advice.

- [ ] **Step 4: Run flutter test to verify all tests pass**

Run: `flutter test`
Expected: All tests PASS cleanly

- [ ] **Step 5: Commit changes**

```bash
git add lib/services/career_bot_service.dart test/career_bot_service_test.dart
git commit -m "feat: add subject weakness and location preference handling to local fallback"
```
