class ChatMessage {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final String? category;
  final List<String>? followUps;
  bool? isLiked; // true = thumbs up, false = thumbs down, null = no rating

  ChatMessage({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.category,
    this.followUps,
    this.isLiked,
  });
}
