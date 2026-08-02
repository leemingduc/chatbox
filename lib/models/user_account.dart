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
