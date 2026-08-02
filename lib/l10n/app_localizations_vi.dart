// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'Tư Vấn Hướng Nghiệp';

  @override
  String get appSubtitle => 'Tư vấn ngành học & định hướng cho học sinh THPT';

  @override
  String get welcomeTitle => 'Chào mừng bạn đến với Chatbox Hướng Nghiệp! 👋';

  @override
  String get welcomeSubtitle =>
      'Tôi là trợ lý AI sẵn sàng hỗ trợ học sinh THPT chọn ngành đại học, định hướng nghề nghiệp, chọn khối thi (A00, B00, C00, D01...) và khám phá bản thân.';

  @override
  String get typeMessageHint =>
      'Nhập câu hỏi về ngành học, trường ĐH, khối thi...';

  @override
  String get send => 'Gửi';

  @override
  String get suggestedTopicsTitle => 'Chủ đề gợi ý phổ biến:';

  @override
  String get topicStem => '🔬 Ngành STEM & Công nghệ';

  @override
  String get topicArts => '🎨 Thiết kế & Truyền thông';

  @override
  String get topicBusiness => '💼 Kinh tế & Marketing';

  @override
  String get topicHolland => '🧩 Trắc nghiệm Holland (RIASEC)';

  @override
  String get topicSubjectCombo => '📚 Chọn khối thi & môn học THPT';

  @override
  String get disclaimer =>
      'Trợ lý hướng nghiệp dành cho học sinh THPT • Thông tin mang tính tham khảo';

  @override
  String get languageSwitch => '🇺🇸 English';

  @override
  String get counselorName => 'Tư Vấn Viên EduPath';

  @override
  String get onlineStatus => 'Trực tuyến • Sẵn sàng hỗ trợ';

  @override
  String get clearChat => 'Xóa cuộc trò chuyện';

  @override
  String get botGreeting =>
      'Xin chào! Bạn đang là học sinh lớp mấy (10, 11 hay 12)? Bạn yêu thích môn học hoặc lĩnh vực nào nhất?';
}
