class ApiConstants {
  // GANTI IP INI:
  // Jika pakai Emulator Android: 'http://10.0.2.2:8000/api'
  // Jika pakai HP Fisik: 'http://192.168.x.x:8000/api' (Cek IP laptop)
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  static const String login = '$baseUrl/login';
  static const String register = '$baseUrl/register';
  static const String logout = '$baseUrl/logout';
  static const String products = '$baseUrl/products';
}
