import 'package:flutter_test/flutter_test.dart';
import 'package:chatbox/models/user_account.dart';
import 'package:chatbox/services/auth_service.dart';

void main() {
  test('UserAccount.guest creates guest profile with default values', () {
    final guest = UserAccount.guest();
    expect(guest.isGuest, isTrue);
    expect(guest.name, equals('Học sinh Khách'));
  });

  test('AuthService loginAsGuest sets currentUser', () async {
    final authService = AuthService();
    final user = await authService.loginAsGuest();
    expect(authService.currentUser, equals(user));
    expect(user.isGuest, isTrue);
  });

  test('AuthService loginWithEmail sets registered user profile', () async {
    final authService = AuthService();
    final user = await authService.loginWithEmail(
      email: 'student@example.com',
      password: 'password123',
      name: 'Nguyễn Văn A',
      grade: 'Lớp 12',
    );
    expect(user.isGuest, isFalse);
    expect(user.name, equals('Nguyễn Văn A'));
    expect(user.grade, equals('Lớp 12'));
  });
}
