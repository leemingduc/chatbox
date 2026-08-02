import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/conversation.dart';

class ConversationStorage {
  static const _storageKey = 'conversation_history_v1';

  Future<List<Conversation>> load() async {
    final preferences = await SharedPreferences.getInstance();
    final raw = preferences.getString(_storageKey);
    if (raw == null || raw.isEmpty) return [];

    try {
      final data = jsonDecode(raw) as List<dynamic>;
      return data
          .map((item) => Conversation.fromJson(item as Map<String, dynamic>))
          .toList()
        ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    } catch (_) {
      return [];
    }
  }

  Future<void> save(List<Conversation> conversations) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(
      _storageKey,
      jsonEncode(
        conversations.map((conversation) => conversation.toJson()).toList(),
      ),
    );
  }
}
