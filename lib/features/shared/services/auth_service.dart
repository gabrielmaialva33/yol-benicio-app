class AuthService {
  Future<void> logout() async {
    // Implementação do logout
    // Por enquanto apenas simula o processo
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<bool> isLoggedIn() async {
    // Simula verificação de login
    return true;
  }

  Future<void> login(String email, String password) async {
    // Implementação do login
    await Future.delayed(const Duration(seconds: 1));
  }
}
