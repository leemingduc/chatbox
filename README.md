# 🎓 Chatbox Tư Vấn Hướng Nghiệp Cho Học Sinh THPT (Career Guidance Chatbox)

Một ứng dụng Flutter hiện đại hỗ trợ tư vấn hướng nghiệp và lựa chọn ngành học đại học dành cho học sinh Trung học Phổ thông (THPT) với hỗ trợ **Song Ngữ (Tiếng Việt & Tiếng Anh)**.

---

## 🌟 Tính Năng Nổi Bật (Features)

- 🇻🇳 🇺🇸 **Hỗ Trợ Song Ngữ (Bilingual Support)**: Chuyển đổi ngôn ngữ tức thì giữa Tiếng Việt và Tiếng Anh (English & Vietnamese).
- 🧩 **Tư Vấn Trắc Nghiệm Holland (RIASEC)**: Hướng dẫn học sinh khám phá nhóm tính cách phù hợp (Realistic, Investigative, Artistic, Social, Enterprising, Conventional).
- 📚 **Định Hướng Khối Thi THPT**: Tư vấn các khối thi phổ biến (A00, A01, B00, C00, D01...) và ngành học tương ứng.
- 🔬 **Gợi Ý Ngành Hot**: Cung cấp thông tin nhóm ngành STEM, Công nghệ thông tin, Thiết kế đa phương tiện, Kinh tế & Marketing.
- 💬 **Giao Diện Trò Chuyện Thân Thiện**: Thiết kế tinh tế, trực quan với các gợi ý chủ đề nhanh (Topic Quick Chips).

---

## 🚀 Khởi Tạo Project & Đẩy Lên GitHub CLI

Dự án được khởi tạo chuẩn Flutter và đẩy lên GitHub tự động thông qua **GitHub CLI (`gh`)**:

```bash
# 1. Khai báo & đăng nhập GitHub CLI
gh auth login

# 2. Tạo Flutter Project
flutter create --org com.career .

# 3. Commit code ban đầu
git init -b main
git add .
git commit -m "feat: initialize Flutter high school career guidance chatbox project with EN/VI bilingual support"

# 4. Tạo repo công khai trên GitHub & push code
gh repo create chatbox --public --source=. --push
```

---

## 💻 Hướng Dẫn Chạy Ứng Dụng (Getting Started)

### Yêu cầu tiên quyết
- Flutter SDK (>= 3.10.8)
- Dart SDK

### Lệnh thực thi

1. Cài đặt các thư viện phụ thuộc:
   ```bash
   flutter pub get
   ```

2. Sinh file ngôn ngữ tự động (nếu cần):
   ```bash
   flutter gen-l10n
   ```

3. Chạy ứng dụng trên thiết bị/trình duyệt:
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
│   │   └── chat_message.dart    # Data model tin nhắn
│   ├── screens/
│   │   └── chat_screen.dart     # Giao diện chatbox hướng nghiệp
│   ├── services/
│   │   └── career_bot_service.dart # Xử lý phản hồi tư vấn
│   └── main.dart                # Main entry point & Cấu hình Locale
├── l10n.yaml                    # Cấu hình Flutter Localization
├── pubspec.yaml                 # Dependencies & package configuration
├── .gitignore                   # Standard Flutter gitignore
└── README.md                    # Tài liệu dự án
```

---

## 📄 Giấy Phép (License)

Dự án phát triển vì mục đích giáo dục & định hướng nghề nghiệp cho cộng đồng học sinh THPT.
