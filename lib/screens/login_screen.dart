import 'package:flutter/material.dart';
import '../models/user_account.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  final Locale locale;
  final Function(Locale) onLanguageChanged;
  final Function(UserAccount) onLoginSuccess;

  const LoginScreen({
    super.key,
    required this.locale,
    required this.onLanguageChanged,
    required this.onLoginSuccess,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  String _selectedGrade = 'Lớp 12';
  bool _isLoading = false;
  bool _showSignUpFields = false;

  final List<String> _grades = ['Lớp 10', 'Lớp 11', 'Lớp 12', 'Khác'];

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _handleGuestLogin() async {
    setState(() => _isLoading = true);
    final user = await AuthService().loginAsGuest();
    if (!mounted) return;
    setState(() => _isLoading = false);
    widget.onLoginSuccess(user);
  }

  Future<void> _handleEmailLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || !email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.locale.languageCode == 'vi'
                ? 'Vui lòng nhập Email hợp lệ'
                : 'Please enter a valid Email address',
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    if (password.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.locale.languageCode == 'vi'
                ? 'Mật khẩu phải từ 4 ký tự trở lên'
                : 'Password must be at least 4 characters long',
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    final user = await AuthService().loginWithEmail(
      email: email,
      password: password,
      name: _nameController.text.trim().isNotEmpty ? _nameController.text.trim() : null,
      grade: _selectedGrade,
    );
    if (!mounted) return;
    setState(() => _isLoading = false);
    widget.onLoginSuccess(user);
  }

  @override
  Widget build(BuildContext context) {
    final isVi = widget.locale.languageCode == 'vi';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgGradient = isDark
        ? const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0F0C29), Color(0xFF302B63), Color(0xFF24243E)],
          )
        : const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF4F46E5), Color(0xFF7C3AED), Color(0xFF4338CA)],
          );

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: bgGradient),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Header Bar (Language toggle)
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton.icon(
                      onPressed: () {
                        final newLocale = isVi ? const Locale('en') : const Locale('vi');
                        widget.onLanguageChanged(newLocale);
                      },
                      icon: Text(isVi ? '🇻🇳' : '🇬🇧', style: const TextStyle(fontSize: 18)),
                      label: Text(
                        isVi ? 'Tiếng Việt' : 'English',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white.withValues(alpha: 0.15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // App Logo & Title
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withValues(alpha: 0.2),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text('🎓', style: TextStyle(fontSize: 40)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    isVi ? 'Tư Vấn Hướng Nghiệp' : 'Career Guidance AI',
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    isVi ? 'Chọn phương thức bắt đầu' : 'Choose how to get started',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Login Card
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF1E1E38).withValues(alpha: 0.9)
                          : Colors.white.withValues(alpha: 0.95),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.25),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // --- PROMINENT GUEST LOGIN BUTTON ---
                        ElevatedButton(
                          onPressed: _isLoading ? null : _handleGuestLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF10B981),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 4,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('🚀', style: TextStyle(fontSize: 20)),
                              const SizedBox(width: 8),
                              Text(
                                isVi ? 'Vào ngay bằng Tài khoản Khách' : 'Continue as Guest',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 8),
                        Text(
                          isVi
                              ? '⚡ Không cần nhập thông tin — Trải nghiệm đầy đủ 100% tính năng AI'
                              : '⚡ Zero input required — Full access to all AI features',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                            fontStyle: FontStyle.italic,
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Divider
                        Row(
                          children: [
                            Expanded(child: Divider(color: isDark ? Colors.grey[700] : Colors.grey[300])),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                isVi ? 'Hoặc đăng nhập' : 'Or log in with email',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Expanded(child: Divider(color: isDark ? Colors.grey[700] : Colors.grey[300])),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Name Field (optional)
                        if (_showSignUpFields) ...[
                          TextField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: isVi ? 'Họ và tên' : 'Full Name',
                              prefixIcon: const Icon(Icons.person_outline),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],

                        // Email Field
                        TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: isVi ? 'Email học sinh' : 'Email Address',
                            prefixIcon: const Icon(Icons.email_outlined),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Password Field
                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: isVi ? 'Mật khẩu' : 'Password',
                            prefixIcon: const Icon(Icons.lock_outline),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Grade Dropdown
                        DropdownButtonFormField<String>(
                          value: _selectedGrade,
                          decoration: InputDecoration(
                            labelText: isVi ? 'Khối lớp THPT' : 'Grade Level',
                            prefixIcon: const Icon(Icons.school_outlined),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          items: _grades.map((grade) {
                            return DropdownMenuItem(
                              value: grade,
                              child: Text(grade),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => _selectedGrade = val);
                          },
                        ),

                        const SizedBox(height: 20),

                        // Submit Button
                        ElevatedButton(
                          onPressed: _isLoading ? null : _handleEmailLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4F46E5),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                )
                              : Text(
                                  isVi ? 'Đăng Nhập / Đăng Ký' : 'Log In / Register',
                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                ),
                        ),

                        const SizedBox(height: 8),

                        TextButton(
                          onPressed: () {
                            setState(() => _showSignUpFields = !_showSignUpFields);
                          },
                          child: Text(
                            _showSignUpFields
                                ? (isVi ? 'Ẩn bớt trường thông tin' : 'Hide additional fields')
                                : (isVi ? '+ Bổ sung Tên học sinh' : '+ Add Full Name'),
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
