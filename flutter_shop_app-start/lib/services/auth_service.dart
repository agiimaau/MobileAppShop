import 'package:shared_preferences/shared_preferences.dart'; // Локал өгөгдөл хадгалах сан.
import 'package:shop_app/services/api_service.dart'; // API-тай харьцах классыг импортлох.

class AuthService {
  static const String tokenKey = 'userToken'; // SharedPreferences-д токены түлхүүр.
  static const String userIdKey = 'userId'; // SharedPreferences-д хэрэглэгчийн ID хадгалах түлхүүр.

  // ---------------------
  // **Нэвтрэх функц**
 static Future<bool> login(String username, String password) async {
  try {
    // Step 1: Log in and get token.
    final loginResponse = await ApiService.loginUser(username, password);

    if (loginResponse.containsKey('error')) {
      print('Login failed: ${loginResponse['error']}');
      return false;
    }

    final token = loginResponse['token'];
    if (token == null || token.isEmpty) {
      print('Error: Missing token');
      return false;
    }

    // Step 2: Fetch user details.
    final userDetails = await ApiService.getUserByUsername(username);
    if (userDetails == null) {
      print('Error: Failed to fetch user details');
      return false;
    }

    final userId = userDetails['id'];
    if (userId == null) {
      print('Error: Missing user ID');
      return false;
    }

    // Step 3: Save token and user ID to SharedPreferences.
    await saveUserIdToSharedPreferences(userId);
    await saveTokenToSharedPreferences(token);

    return true;
  } catch (e) {
    print('Error during login: $e');
    return false;
  }
}



  // ---------------------
  // **Хэрэглэгчийн ID-г SharedPreferences-д хадгалах**
  static Future<void> saveUserIdToSharedPreferences(int userId) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setInt(userIdKey, userId); // Ensure userId is not null.
}


  // ---------------------
  // **Токеныг SharedPreferences-д хадгалах**
  static Future<void> saveTokenToSharedPreferences(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(tokenKey, token); // Токеныг хадгалах.
  }

  // ---------------------
  // **Хэрэглэгчийн ID-г SharedPreferences-с авах**
  static Future<int?> getUserIdFromSharedPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(userIdKey); // Хэрэглэгчийн ID-г буцаах.
    } catch (e) {
      print('Error accessing SharedPreferences: $e');
      return null;
    }
  }

  // ---------------------
  // **Токеныг SharedPreferences-с авах**
  static Future<String?> getTokenFromSharedPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(tokenKey); // Токеныг буцаах.
    } catch (e) {
      print('Error accessing SharedPreferences: $e');
      return null;
    }
  }

  // ---------------------
  // **Хэрэглэгчийн мэдээллийг ID-аар авах**
  static Future<Map<String, dynamic>?> getUserById(int userId) async {
    try {
      return await ApiService.getUserById(userId); // API-с өгөгдөл авах.
    } catch (e) {
      print('Error fetching user by ID: $e');
      return null;
    }
  }

  // ---------------------
  // **Нэвтэрсэн эсэхийг шалгах функц**
  static Future<bool> isLoggedIn() async {
    final userId = await getUserIdFromSharedPreferences();
    return userId != null; // Хэрэв хэрэглэгчийн ID байгаа бол нэвтэрсэн гэж тооцно.
  }

  // ---------------------
  // **Гарах функц**
  static Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(tokenKey); // Токеныг устгах.
      await prefs.remove(userIdKey); // Хэрэглэгчийн ID-г устгах.
    } catch (e) {
      print('Error during logout: $e');
    }
  }
}
