class ChatMessage {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final String? category;
  final List<String>? followUps;
  bool? isLiked;

  ChatMessage({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.category,
    this.followUps,
    this.isLiked,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'text': text,
    'isUser': isUser,
    'timestamp': timestamp.toIso8601String(),
    'category': category,
    'followUps': followUps,
    'isLiked': isLiked,
  };

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
    id: json['id'] as String,
    text: json['text'] as String,
    isUser: json['isUser'] as bool,
    timestamp: DateTime.parse(json['timestamp'] as String),
    category: json['category'] as String?,
    followUps: (json['followUps'] as List<dynamic>?)?.cast<String>(),
    isLiked: json['isLiked'] as bool?,
  );
}
