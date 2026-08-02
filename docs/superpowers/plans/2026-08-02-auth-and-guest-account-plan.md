# User Login and Guest Account Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Implement User Authentication and Guest Account functionality with a modern `LoginScreen`, seamless Guest login, account profile modal, and session management.

**Architecture:** Create `UserAccount` model and `AuthService` singleton/service. Add `LoginScreen` as an onboarding step after `SplashScreen`. Enhance `ChatScreen` with an Account Profile chip and modal allowing logout or upgrading from Guest to a registered account.

**Tech Stack:** Dart, Flutter Material 3, Flutter Test.

## Global Constraints

- Preserve responsive dark/light gradient theme aesthetic.
- Support Vietnamese (`vi`) and English (`en`) locale switching.
- Ensure guest account login requires zero inputs and works 100% with full AI chat features.

---

### Task 1: Create UserAccount Model and AuthService (`lib/models/user_account.dart` & `lib/services/auth_service.dart`)

**Files:**
- Create: `lib/models/user_account.dart`
- Create: `lib/services/auth_service.dart`
- Create: `test/auth_service_test.dart`

**Interfaces:**
- Consumes: `UserAccount.guest()`, `AuthService.loginAsGuest()`, `AuthService.loginWithEmail()`
- Produces: State management for active user session

- [ ] **Step 1: Write failing unit test for UserAccount and AuthService**

Create `test/auth_service_test.dart`:
```dart
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
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/auth_service_test.dart`
Expected: FAIL (files not found)

- [ ] **Step 3: Create `lib/models/user_account.dart`**

```dart
class UserAccount {
  final String id;
  final String name;
  final String? email;
  final String? grade;
  final bool isGuest;

  UserAccount({
    required this.id,
    required this.name,
    this.email,
    this.grade,
    required this.isGuest,
  });

  factory UserAccount.guest({String? name}) {
    final randomId = DateTime.now().millisecondsSinceEpoch.toString();
    return UserAccount(
      id: 'guest_$randomId',
      name: name ?? 'Học sinh Khách',
      isGuest: true,
    );
  }
}
```

- [ ] **Step 4: Create `lib/services/auth_service.dart`**

```dart
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
```

- [ ] **Step 5: Run unit tests to verify they pass**

Run: `flutter test test/auth_service_test.dart`
Expected: PASS

- [ ] **Step 6: Commit changes**

```bash
git add lib/models/user_account.dart lib/services/auth_service.dart test/auth_service_test.dart
git commit -m "feat: add UserAccount model and AuthService singleton"
```

---

### Task 2: Create LoginScreen (`lib/screens/login_screen.dart`)

**Files:**
- Create: `lib/screens/login_screen.dart`
- Modify: `lib/screens/splash_screen.dart`
- Modify: `lib/main.dart`

**Interfaces:**
- Consumes: `AuthService.loginAsGuest()`, `AuthService.loginWithEmail()`
- Produces: `LoginScreen` widget enabling guest and registered login

- [ ] **Step 1: Create `lib/screens/login_screen.dart`**

Create `LoginScreen` with email/password text fields, grade dropdown, "Đăng Nhập" button, and prominent "🚀 Tiếp tục với tư cách Khách" button.

- [ ] **Step 2: Connect `SplashScreen` to `LoginScreen` in `lib/screens/splash_screen.dart` and `lib/main.dart`**

Update `SplashScreen` navigation target to present `LoginScreen`, which subsequently loads `ChatScreen` on login.

- [ ] **Step 3: Run `flutter test` to ensure build passes**

Run: `flutter test`
Expected: PASS

- [ ] **Step 4: Commit changes**

```bash
git add lib/screens/login_screen.dart lib/screens/splash_screen.dart lib/main.dart
git commit -m "feat: add LoginScreen with Guest account login flow"
```

---

### Task 3: Integrate User Profile & Account Modal into ChatScreen (`lib/screens/chat_screen.dart`)

**Files:**
- Modify: `lib/screens/chat_screen.dart`
- Modify: `test/widget_test.dart`

**Interfaces:**
- Consumes: `UserAccount`, `AuthService.logout()`
- Produces: Profile chip in App Bar and interactive Account Dialog

- [ ] **Step 1: Update `ChatScreen` App Bar and add `_showAccountDialog`**

Add `currentUser` property to `ChatScreen`. Display account badge in top right header. Implement modal showing account type (Guest vs Member), grade level, upgrade option, and logout button.

- [ ] **Step 2: Run all tests to verify clean execution**

Run: `flutter test`
Expected: ALL PASS

- [ ] **Step 3: Commit changes**

```bash
git add lib/screens/chat_screen.dart test/widget_test.dart
git commit -m "feat: integrate account chip and profile modal in ChatScreen"
```
