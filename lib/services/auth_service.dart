import '../models/models.dart';

class AuthService {
  static const String _validUsername = 'leonel';
  static const String _validPassword = '1234';
  
  static User? _currentUser;
  
  static User? get currentUser => _currentUser;
  
  static bool login(String username, String password) {
    if (username == _validUsername && password == _validPassword) {
      _currentUser = const User(
        username: _validUsername,
        name: 'Leonel',
        balance: 2847.50,
      );
      return true;
    }
    return false;
  }
  
  static void logout() {
    _currentUser = null;
  }
  
  static bool get isLoggedIn => _currentUser != null;
}