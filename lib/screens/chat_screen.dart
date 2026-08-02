import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../l10n/app_localizations.dart';
import '../models/chat_message.dart';
import '../services/gemini_service.dart';
import '../services/sound_service.dart';

class ChatScreen extends StatefulWidget {
  final Locale currentLocale;
  final Function(Locale) onLanguageChanged;

  const ChatScreen({
    super.key,
    required this.currentLocale,
    required this.onLanguageChanged,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final List<ChatMessage> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;
  late AnimationController _loadingAnimController;

  @override
  void initState() {
    super.initState();
    _loadingAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    _controller.addListener(() {
      setState(() {});
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _addInitialGreeting();
    });
  }

  @override
  void dispose() {
    _loadingAnimController.dispose();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _addInitialGreeting() {
    final l10n = AppLocalizations.of(context)!;
    if (_messages.isEmpty) {
      setState(() {
        _messages.add(
          ChatMessage(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            text: l10n.botGreeting,
            isUser: false,
            timestamp: DateTime.now(),
            followUps: widget.currentLocale.languageCode == 'vi'
                ? [
                    "🔬 Tư vấn khối ngành STEM & Công nghệ",
                    "🧩 Làm trắc nghiệm Holland RIASEC",
                    "📚 Tư vấn chọn khối thi (A00, D01...)"
                  ]
                : [
                    "🔬 STEM & Computer Science Majors",
                    "🧩 Holland RIASEC Personality Test",
                    "📚 Subject Combinations (A00, D01...)"
                  ],
          ),
        );
      });
    }
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty || _isTyping) return;

    final userMsg = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text.trim(),
      isUser: true,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(userMsg);
      _isTyping = true;
    });

    // Play send sound effect
    SoundService.playSend();

    _controller.clear();
    _scrollToBottom();

    // Call Gemini API with multi-turn conversation history
    final localeCode = widget.currentLocale.languageCode;
    final historyForAi = List<ChatMessage>.from(_messages);

    GeminiService.generateResponse(
      chatHistory: historyForAi,
      userPrompt: text,
      localeCode: localeCode,
    ).then((botResult) {
      if (!mounted) return;
      setState(() {
        _messages.add(
          ChatMessage(
            id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
            text: botResult.text,
            isUser: false,
            timestamp: DateTime.now(),
            category: botResult.category,
            followUps: botResult.followUps,
          ),
        );
        _isTyping = false;
      });
      // Play receive sound effect
      SoundService.playReceive();
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  void _clearChat() {
    setState(() {
      _messages.clear();
      _addInitialGreeting();
    });
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(l10n.copiedToClipboard),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showSubjectComboSheet() {
    final l10n = AppLocalizations.of(context)!;
    final isVi = widget.currentLocale.languageCode == 'vi';

    final combos = isVi
        ? [
            {"code": "A00", "subjects": "Toán, Lý, Hóa", "major": "IT, Bách Khoa, Kỹ thuật"},
            {"code": "A01", "subjects": "Toán, Lý, Tiếng Anh", "major": "Tự động hóa, QTKD, Kinh tế"},
            {"code": "B00", "subjects": "Toán, Hóa, Sinh", "major": "Y Đa khoa, Dược học, Biotech"},
            {"code": "C00", "subjects": "Văn, Sử, Địa", "major": "Luật, Báo chí, Báo chí, Tâm lý"},
            {"code": "D01", "subjects": "Toán, Văn, Tiếng Anh", "major": "Marketing, Ngôn ngữ, Du lịch"},
            {"code": "D07", "subjects": "Toán, Hóa, Tiếng Anh", "major": "Hóa dược, Ngân hàng, QTKD"},
          ]
        : [
            {"code": "A00", "subjects": "Math, Physics, Chemistry", "major": "IT, Engineering, Tech"},
            {"code": "A01", "subjects": "Math, Physics, English", "major": "Automation, Business, Econ"},
            {"code": "B00", "subjects": "Math, Chemistry, Biology", "major": "Medicine, Pharmacy, Biotech"},
            {"code": "C00", "subjects": "Lit, History, Geo", "major": "Law, Journalism, Psychology"},
            {"code": "D01", "subjects": "Math, Lit, English", "major": "Marketing, Languages, Tourism"},
            {"code": "D07", "subjects": "Math, Chem, English", "major": "Fintech, Pharmacy, Business"},
          ];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.subjectComboModalTitle,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(),
              Expanded(
                child: ListView.separated(
                  itemCount: combos.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final item = combos[index];
                    return Card(
                      elevation: 0,
                      color: const Color(0xFF4F46E5).withValues(alpha: 0.06),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: const Color(0xFF4F46E5),
                          child: Text(
                            item["code"]!,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ),
                        title: Text(item["subjects"]!, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(item["major"]!),
                        trailing: const Icon(Icons.chevron_right_rounded),
                        onTap: () {
                          Navigator.pop(context);
                          _sendMessage("Tell me about subject combo ${item["code"]}");
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isSendEnabled = _controller.text.trim().isNotEmpty && !_isTyping;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFF4F46E5),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.school_rounded, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.appTitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: GeminiService.isApiKeyConfigured ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        GeminiService.isApiKeyConfigured ? "Gemini 3.1 Flash Lite • Active" : l10n.onlineStatus,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          // Subject Combo Quick Modal Button
          IconButton(
            icon: const Icon(Icons.menu_book_rounded, color: Colors.white),
            tooltip: l10n.exploreSubjectCombos,
            onPressed: _showSubjectComboSheet,
          ),

          // Language Switcher
          PopupMenuButton<String>(
            icon: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Text(
                    widget.currentLocale.languageCode == 'en' ? '🇺🇸 EN' : '🇻🇳 VI',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const Icon(Icons.arrow_drop_down, color: Colors.white, size: 16),
                ],
              ),
            ),
            onSelected: (String langCode) {
              widget.onLanguageChanged(Locale(langCode));
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'vi',
                child: Row(
                  children: [
                    Text('🇻🇳  Tiếng Việt'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'en',
                child: Row(
                  children: [
                    Text('🇺🇸  English'),
                  ],
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, color: Colors.white),
            tooltip: l10n.clearChat,
            onPressed: _clearChat,
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
        ),
        child: Column(
          children: [
            // Holland RIASEC Quick Assessment Bar
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFEEF2FF),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildTopicChip(l10n.topicStem, () => _sendMessage("STEM & Tech majors")),
                    _buildTopicChip(l10n.topicHolland, () => _sendMessage("Holland RIASEC test")),
                    _buildTopicChip(l10n.topicSubjectCombo, () => _sendMessage("Subject combinations A00 D01 B00")),
                    _buildTopicChip(l10n.topicBusiness, () => _sendMessage("Business and Marketing careers")),
                    _buildTopicChip(l10n.topicArts, () => _sendMessage("Arts Design and Media majors")),
                  ],
                ),
              ),
            ),

            // Message List (ListView.builder)
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length + (_isTyping ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _messages.length && _isTyping) {
                    return _buildLoadingBubble(isDark, l10n);
                  }
                  final msg = _messages[index];
                  return _buildMessageBubble(msg, isDark, l10n);
                },
              ),
            ),

            // Input Bar + Send Button
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (val) {
                          if (isSendEnabled) _sendMessage(val);
                        },
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                        decoration: InputDecoration(
                          hintText: l10n.typeMessageHint,
                          hintStyle: TextStyle(
                            color: isDark ? Colors.grey.shade400 : Colors.grey.shade500,
                            fontSize: 14,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          filled: true,
                          fillColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Lock send button when empty or typing
                    Material(
                      color: isSendEnabled
                          ? const Color(0xFF4F46E5)
                          : isDark
                              ? const Color(0xFF334155)
                              : Colors.grey.shade300,
                      shape: const CircleBorder(),
                      elevation: isSendEnabled ? 2 : 0,
                      child: IconButton(
                        icon: Icon(
                          Icons.send_rounded,
                          color: isSendEnabled
                              ? Colors.white
                              : isDark
                                  ? Colors.grey.shade600
                                  : Colors.grey.shade500,
                          size: 20,
                        ),
                        onPressed: isSendEnabled ? () => _sendMessage(_controller.text) : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopicChip(String label, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ActionChip(
        label: Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        side: BorderSide(color: const Color(0xFF4F46E5).withValues(alpha: 0.3)),
        onPressed: onTap,
      ),
    );
  }

  Widget _buildLoadingBubble(bool isDark, AppLocalizations l10n) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF334155) : Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
            bottomLeft: Radius.circular(4),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              l10n.aiThinking,
              style: TextStyle(
                fontSize: 13,
                fontStyle: FontStyle.italic,
                color: isDark ? Colors.grey.shade300 : Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage msg, bool isDark, AppLocalizations l10n) {
    final isUser = msg.isUser;
    final bubbleColor = isUser
        ? const Color(0xFF4F46E5)
        : isDark
            ? const Color(0xFF1E293B)
            : Colors.white;

    final textColor = isUser
        ? Colors.white
        : isDark
            ? Colors.white
            : const Color(0xFF1E293B);

    final timeStr = "${msg.timestamp.hour.toString().padLeft(2, '0')}:${msg.timestamp.minute.toString().padLeft(2, '0')}";

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isUser) ...[
                CircleAvatar(
                  radius: 16,
                  backgroundColor: const Color(0xFF4F46E5),
                  child: const Icon(Icons.smart_toy_rounded, size: 18, color: Colors.white),
                ),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: bubbleColor,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(isUser ? 16 : 4),
                      bottomRight: Radius.circular(isUser ? 4 : 16),
                    ),
                    boxShadow: [
                      if (!isUser)
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!isUser) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              l10n.counselorName,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF6366F1),
                              ),
                            ),
                            Text(
                              timeStr,
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                      ],
                      SelectableText(
                        msg.text,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 14,
                          height: 1.45,
                        ),
                      ),
                      if (isUser) ...[
                        const SizedBox(height: 4),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            timeStr,
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.white.withValues(alpha: 0.7),
                            ),
                          ),
                        ),
                      ],

                      // Bot Action Bar (Copy & Thumbs Rating)
                      if (!isUser) ...[
                        const SizedBox(height: 8),
                        Divider(height: 1, color: isDark ? Colors.grey.shade800 : Colors.grey.shade200),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      msg.isLiked = true;
                                    });
                                  },
                                  child: Icon(
                                    Icons.thumb_up_alt_outlined,
                                    size: 16,
                                    color: msg.isLiked == true ? Colors.green : Colors.grey.shade400,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      msg.isLiked = false;
                                    });
                                  },
                                  child: Icon(
                                    Icons.thumb_down_alt_outlined,
                                    size: 16,
                                    color: msg.isLiked == false ? Colors.red : Colors.grey.shade400,
                                  ),
                                ),
                              ],
                            ),
                            InkWell(
                              onTap: () => _copyToClipboard(msg.text),
                              child: Row(
                                children: [
                                  Icon(Icons.copy_rounded, size: 14, color: Colors.grey.shade500),
                                  const SizedBox(width: 4),
                                  Text(
                                    "Copy",
                                    style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              if (isUser) ...[
                const SizedBox(width: 8),
                CircleAvatar(
                  radius: 16,
                  backgroundColor: const Color(0xFF6366F1),
                  child: const Icon(Icons.person_rounded, size: 18, color: Colors.white),
                ),
              ],
            ],
          ),

          // Follow-up suggestion chips rendered below Bot message
          if (!isUser && msg.followUps != null && msg.followUps!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.followUpPrompt,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: msg.followUps!.map((prompt) {
                      return ActionChip(
                        padding: EdgeInsets.zero,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        label: Text(
                          prompt,
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark ? const Color(0xFFA5B4FC) : const Color(0xFF4F46E5),
                          ),
                        ),
                        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                        side: BorderSide(
                          color: const Color(0xFF6366F1).withValues(alpha: 0.3),
                        ),
                        onPressed: () => _sendMessage(prompt),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
