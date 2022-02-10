class AuthRepository {
  Future<void> login() async {
    print('Intentando logear');
    await Future.delayed(const Duration(seconds: 3));
    print('Logeo con éxito');

    throw Exception('failed log in');
  }
}
