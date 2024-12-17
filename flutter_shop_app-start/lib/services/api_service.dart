import 'dart:convert'; // JSON өгөгдөлтэй ажиллахад ашиглана.
import 'package:http/http.dart' as http; // HTTP хүсэлт хийхэд ашиглана.

class ApiService {
  static const String baseUrl = 'https://fakestoreapi.com'; // Fake Store API-ын үндсэн URL.
  // ---------------------
  // **Хэрэглэгчийн мэдээллийг ID-аар авах**
  static Future<Map<String, dynamic>?> getUserById(int userId) async {
    try {
      final url = Uri.parse('$baseUrl/users/$userId'); // Хэрэглэгчийн ID ашиглах.
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return json.decode(response.body); // JSON хөрвүүлэлт.
      } else {
        print('Failed to fetch user by ID. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching user by ID: $e');
      return null;
    }
  }


  // --------------------
  // **Хэрэглэгчийн нэвтрэх функц**
  static Future<Map<String, dynamic>> loginUser(String username, String password) async {
  try {
    final url = Uri.parse('$baseUrl/auth/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        "username": username,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['token'] == null) {
        print('Error: Missing token in API response');
        return {'error': 'Invalid response'};
      }
      return data; // Returns token only.
    } else {
      print('Login failed with status code: ${response.statusCode}');
      return {'error': 'Invalid credentials'};
    }
  } catch (e) {
    print('Error during API call: $e');
    return {'error': 'Failed to login'};
  }
}

static Future<Map<String, dynamic>?> getUserByUsername(String username) async {
  try {
    final url = Uri.parse('$baseUrl/users');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final users = json.decode(response.body) as List<dynamic>;
      final user = users.firstWhere(
        (u) => u['username'] == username,
        orElse: () => null,
      );
      return user;
    } else {
      print('Failed to fetch user by username. Status code: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Error fetching user by username: $e');
    return null;
  }
}




  // --------------------
  // **Хэрэглэгчийн сагсны өгөгдлийг авах функц**
  static Future<List<dynamic>> getUserCart(int userId) async {
    try {
      final url = Uri.parse('$baseUrl/carts/user/$userId'); // Хэрэглэгчийн ID ашиглах.
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return json.decode(response.body); // JSON хөрвүүлэлт.
      } else {
        throw Exception('Failed to fetch cart items');
      }
    } catch (e) {
      print('Error fetching cart: $e');
      return [];
    }
  }

  // --------------------
  // **Сагсанд бараа нэмэх функц**
  static Future<void> addToCart(int userId, int productId, int quantity) async {
    try {
      final url = Uri.parse('$baseUrl/carts');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "userId": userId,
          "products": [
            {"productId": productId, "quantity": quantity}
          ]
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to add item to cart');
      }
    } catch (e) {
      print('Error adding to cart: $e');
    }
  }

  // --------------------
  // **Сагснаас бараа хасах функц**
  static Future<void> removeFromCart(int cartId, int productId) async {
    try {
      final url = Uri.parse('$baseUrl/carts/$cartId'); // Сагсны ID ашиглах.
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "products": [
            {"productId": productId, "quantity": 0}
          ]
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to remove item from cart');
      }
    } catch (e) {
      print('Error removing from cart: $e');
    }
  }
}
