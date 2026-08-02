# User Login and Guest Account Authentication Design Spec

## Executive Summary
This specification defines the integration of user authentication and guest account functionality for the Career Guidance AI application. It provides a seamless onboarding experience allowing users to log in with an email/password (or profile details) or instantly join as a Guest with full access to all AI features without entering credentials.

---

## 1. User Account Model (`lib/models/user_account.dart`)

### Requirements
Define a immutable data model `UserAccount`:
- `String id`: Unique session/user ID.
- `String name`: User display name (Default: `"Học sinh Khách"` / `"Guest Student"` for guests).
- `String? email`: Email address (null for guests).
- `String? grade`: Student high school grade (`"Lớp 10"`, `"Lớp 11"`, `"Lớp 12"`, or null).
- `bool isGuest`: Boolean flag indicating if this is a Guest account.

Factory Constructor:
```dart
factory UserAccount.guest({String? name}) {
  final randomId = DateTime.now().millisecondsSinceEpoch.toString();
  return UserAccount(
    id: 'guest_$randomId',
    name: name ?? 'Học sinh Khách',
    isGuest: true,
  );
}
```

---

## 2. Authentication Service (`lib/services/auth_service.dart`)

### Requirements
Manage user authentication state and session persistence using `shared_preferences`:
- `UserAccount? currentUser`: Currently logged in user account.
- `Future<UserAccount> loginAsGuest()`: Creates a guest account, persists session flag, and returns `UserAccount`.
- `Future<UserAccount> loginWithEmail({required String email, required String password, String? name, String? grade})`: Creates or validates a registered user account and persists session.
- `Future<UserAccount?> loadSavedSession()`: Restores saved user session on app launch.
- `Future<void> logout()`: Clears active session and saved state.

---

## 3. Login Screen (`lib/screens/login_screen.dart`)

### Requirements
Create a modern, visually stunning login screen matching the app's aesthetic:
- **Gradient Background**: Responsive dark/light theme gradient matching `SplashScreen`.
- **Form Controls**:
  - Email & Password text fields with validation.
  - Grade selector dropdown (Lớp 10, Lớp 11, Lớp 12).
  - Primary button: **"Đăng Nhập / Đăng Ký"** (Log In / Register).
  - Secondary prominent button: **"🚀 Tiếp tục với tư cách Khách"** (Continue as Guest - zero input required).
- **Language Switcher**: Vi / En toggle button at the top header.

---

## 4. Main & Navigation Updates (`lib/main.dart` & `lib/screens/splash_screen.dart`)

### Requirements
- `SplashScreen` navigates to `LoginScreen` (or `ChatScreen` if a saved session exists).
- `ChatScreen` receives `UserAccount` and `AuthService`.

---

## 5. Account Header & Profile Modal (`lib/screens/chat_screen.dart`)

### Requirements
- **App Bar Chip**: Displays active user profile badge (`👤 Khách` or `✨ <User Name>`).
- **Profile Modal**: Tapping the account chip opens a modal showing:
  - Account status (Guest vs Regular User).
  - Student details (Grade level, email).
  - Action: **"Nâng cấp lên Tài khoản chính thức"** (if Guest).
  - Action: **"Đăng xuất"** (Log out to return to `LoginScreen`).

---

## 6. Verification Plan

### Automated Tests
- Create `test/auth_service_test.dart` to verify `UserAccount.guest()`, `loginAsGuest()`, and session persistence.
- Run `flutter test` across all test files.

### Manual Verification
- Test Guest Login: Click "🚀 Tiếp tục với tư cách Khách" -> Navigates to `ChatScreen`, shows `👤 Khách` badge, full AI chat functional.
- Test Account Profile Modal: Click profile chip -> Shows Guest status -> Click "Đăng xuất" -> Returns to `LoginScreen`.
- Test Email Login: Enter credentials -> Click "Đăng Nhập" -> Navigates to `ChatScreen` with registered user name.
