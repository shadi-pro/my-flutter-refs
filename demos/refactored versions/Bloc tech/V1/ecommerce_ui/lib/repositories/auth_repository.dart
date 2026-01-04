import 'dart:async';

abstract class AuthRepository {
  Future<bool> login(String email, String password);
  Future<bool> register(String email, String password, String name);
  Future<void> logout();
  bool isLoggedIn();
  String? getCurrentUserEmail();
}

class MockAuthRepository implements AuthRepository {
  bool _isLoggedIn = false;
  String? _currentUserEmail;

  @override
  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate API call

    // Mock login - always succeeds for demo
    _isLoggedIn = true;
    _currentUserEmail = email;

    return true;
  }

  @override
  Future<bool> register(String email, String password, String name) async {
    await Future.delayed(const Duration(seconds: 1));

    // Mock registration - always succeeds
    _isLoggedIn = true;
    _currentUserEmail = email;

    return true;
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _isLoggedIn = false;
    _currentUserEmail = null;
  }

  @override
  bool isLoggedIn() => _isLoggedIn;

  @override
  String? getCurrentUserEmail() => _currentUserEmail;
}
