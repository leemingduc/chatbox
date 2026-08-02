// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'EduPath Guidance';

  @override
  String get appSubtitle => 'High School Career & Major Counseling';

  @override
  String get welcomeTitle => 'Welcome to EduPath Career Assistant! 👋';

  @override
  String get welcomeSubtitle =>
      'I\'m here to help high school students explore university majors, career opportunities, Subject Combinations (A00, B00, D01...), and personal interests.';

  @override
  String get typeMessageHint => 'Ask about majors, universities, or careers...';

  @override
  String get send => 'Send';

  @override
  String get suggestedTopicsTitle => 'Popular Guidance Topics:';

  @override
  String get topicStem => '🔬 STEM & Tech Majors';

  @override
  String get topicArts => '🎨 Design & Media Careers';

  @override
  String get topicBusiness => '💼 Business & Marketing';

  @override
  String get topicHolland => '🧩 Holland RIASEC Personality Test';

  @override
  String get topicSubjectCombo => '📚 High School Subject Selection';

  @override
  String get disclaimer =>
      'Career Assistant for High School Students • Educational Reference';

  @override
  String get languageSwitch => '🇻🇳 Tiếng Việt';

  @override
  String get counselorName => 'EduPath Guidance AI';

  @override
  String get onlineStatus => 'Online • Ready to help';

  @override
  String get clearChat => 'Clear Conversation';

  @override
  String get botGreeting =>
      'Hello! What grade are you in (10, 11, or 12)? What subjects or fields interest you the most?';
}
