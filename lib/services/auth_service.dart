import '../models/user_account.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  UserAccount? _currentUser;
  UserAccount? get currentUser => _currentUser;

  Future<UserAccount> loginAsGuest({String? name}) async {
    _currentUser = UserAccount.guest(name: name);
    return _currentUser!;
  }

  Future<UserAccount> loginWithEmail({
    required String email,
    required String password,
    String? name,
    String? grade,
  }) async {
    final displayName = (name != null && name.trim().isNotEmpty) ? name.trim() : email.split('@').first;
    _currentUser = UserAccount(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      name: displayName,
      email: email.trim(),
      grade: grade,
      isGuest: false,
    );
    return _currentUser!;
  }

  Future<void> logout() async {
    _currentUser = null;
  }
}
