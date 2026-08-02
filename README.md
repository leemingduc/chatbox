# 🎓 Chatbox Tư Vấn Hướng Nghiệp Cho Học Sinh THPT (Career Guidance Chatbox)

Một ứng dụng Flutter hiện đại hỗ trợ tư vấn hướng nghiệp và lựa chọn ngành học đại học dành cho học sinh Trung học Phổ thông (THPT) với hỗ trợ **Song Ngữ (Tiếng Việt & Tiếng Anh)** và tích hợp **Google Gemini Chatbot AI**.

---

## 🌟 Tính Năng Nổi Bật (Features)

- 🤖 **Google Gemini 1.5 Flash AI Chatbot**: Tích hợp SDK chính thức `google_generative_ai` với **System Prompt** đóng vai trò Tư vấn viên hướng nghiệp THPT.
- 💬 **Lịch Sử Trò Chuyện Đa Lượt (Multi-turn History)**: AI nhớ ngữ cảnh cuộc trò chuyện (`user` và `model`), chủ động **hỏi ngược lại** về sở thích, môn thế mạnh và tính cách trước khi tư vấn ngành.
- 🎯 **Gợi Ý Ngành & Khối Thi**: Đề xuất 2-3 ngành học phù hợp kèm lý do chi tiết và khối thi THPT tương ứng (A00, A01, B00, C00, D01, D07...).
- 🔒 **Bảo Mật API Key & Xử Lý Lỗi**: Truyền API Key qua `--dart-define=GEMINI_API_KEY=...` không commit key; tự động fallback sang bộ tư vấn nội địa nếu mất kết nối hoặc hết quota, đảm bảo không crash ứng dụng.
- 🇻🇳 🇺🇸 **Hỗ Trợ Song Ngữ (Bilingual Support)**: Chuyển đổi ngôn ngữ tức thì giữa Tiếng Việt và Tiếng Anh (English & Vietnamese).
- 🧩 **Tư Vấn Trắc Nghiệm Holland (RIASEC)**: Hướng dẫn học sinh khám phá 6 nhóm tính cách (Realistic, Investigative, Artistic, Social, Enterprising, Conventional).
- 📚 **Tra Cứu Khối Thi THPT**: Modal bottom sheet tra cứu nhanh các khối A00, A01, B00, C00, D01, D07...

---

## 🚀 Khởi Tạo Project & Đẩy Lên GitHub CLI

Dự án được khởi tạo chuẩn Flutter và đẩy lên GitHub tự động thông qua **GitHub CLI (`gh`)**:

```bash
# 1. Đăng nhập GitHub CLI
gh auth login

# 2. Tạo Flutter Project
flutter create --org com.career .

# 3. Commit & đẩy lên GitHub
git init -b main
git add .
git commit -m "feat: integrate Gemini API with high school career guidance system prompt"
gh repo create chatbox --public --source=. --push
```

---

## 💻 Hướng Dẫn Chạy Ứng Dụng Với Gemini API Key

### Lệnh thực thi với `--dart-define`:

1. Cài đặt gói thư viện:
   ```bash
   flutter pub get
   ```

2. **Chạy ứng dụng với Gemini API Key** (Khuyên dùng):
   ```bash
   flutter run --dart-define=GEMINI_API_KEY=your_actual_gemini_api_key
   ```

3. **Chạy ở Chế Độ Nội Địa (Fallback Mode)** (Nếu không truyền API Key, ứng dụng vẫn hoạt động bình thường mà không crash):
   ```bash
   flutter run
   ```

---

## 📁 Cấu Trúc Thư Mục (Project Structure)

```text
chatbox/
├── lib/
│   ├── l10n/
│   │   ├── app_en.arb           # Từ điển Tiếng Anh
│   │   └── app_vi.arb           # Từ điển Tiếng Việt
│   ├── models/
│   │   └── chat_message.dart    # Data model tin nhắn & rating
│   ├── screens/
│   │   └── chat_screen.dart     # Giao diện chatbox hướng nghiệp
│   ├── services/
│   │   ├── career_bot_service.dart # Bộ tư vấn nội địa (Local Fallback)
│   │   └── gemini_service.dart     # Tích hợp Google Gemini AI + System Prompt
│   └── main.dart                # Main entry point & Cấu hình Locale
├── l10n.yaml                    # Cấu hình Flutter Localization
├── pubspec.yaml                 # Dependencies (google_generative_ai)
├── .gitignore                   # Standard Flutter gitignore
└── README.md                    # Tài liệu hướng dẫn dự án
```
