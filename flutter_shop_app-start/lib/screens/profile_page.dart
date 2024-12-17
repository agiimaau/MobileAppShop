import 'package:easy_localization/easy_localization.dart'; // Олон хэлний дэмжлэг.
import 'package:flutter/material.dart'; // Flutter UI зохион байгуулахад шаардлагатай сан.
import 'package:shared_preferences/shared_preferences.dart'; // Локал өгөгдөл хадгалах.
import 'package:shop_app/global_keys.dart'; // Аппын глобал навигацийн түлхүүр.
import '/models/users.dart'; // Хэрэглэгчийн өгөгдлийн загвар.
import 'package:flutter/services.dart' show rootBundle; // Файлын өгөгдөл унших.
import 'package:shop_app/services/auth_service.dart'; // Нэвтрэлтийн үйлчилгээ.

class ProfilePage extends StatefulWidget {
  final User? user; // Add this parameter to accept user data.

  const ProfilePage({Key? key, this.user}) : super(key: key); // Update constructor to accept user.

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? currentUser; // Одоогийн хэрэглэгчийн өгөгдлийг хадгалах.
  bool isLoading = true; // Ачааллын индикатор.

  @override
  void initState() {
    super.initState();
    _loadCurrentUser(); // Одоогийн хэрэглэгчийн өгөгдлийг ачаалах.
  }

  // **SharedPreferences-с хэрэглэгчийн өгөгдлийг ачаалах.**
  Future<void> _loadCurrentUser() async {
    try {
      final userId = await AuthService.getUserIdFromSharedPreferences();
      if (userId != null) {
        // Нэвтэрсэн хэрэглэгчийн өгөгдлийг API-аас авах.
        final userData = await _fetchUserData(userId);
        setState(() {
          currentUser = userData; // Хэрэглэгчийн өгөгдлийг хадгалах.
        });
      }
    } catch (e) {
      print('Error loading current user: $e');
    } finally {
      setState(() {
        isLoading = false; // Ачаалал дууссан.
      });
    }
  }

  // **API-с хэрэглэгчийн өгөгдлийг авах функц.**
  Future<User?> _fetchUserData(int userId) async {
    try {
      final response = await AuthService.getUserById(userId); // Хэрэглэгчийн өгөгдөл авах.
      if (response != null) {
        return User.fromJson(response);
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
    return null;
  }

  // **Хэл солих функц.**
  void changeLanguage() async {
    final contxt = GlobalKeys.navigatorKey.currentContext!;
    final prefs = await SharedPreferences.getInstance();

    if (contxt.locale.languageCode == const Locale('mn', 'MN').languageCode) {
      contxt.setLocale(const Locale('en', 'US'));
      await prefs.setString('selectedLanguage', 'en');
    } else {
      contxt.setLocale(const Locale('mn', 'MN'));
      await prefs.setString('selectedLanguage', 'mn');
    }
  }

  // **Гарах функц.**
  void logout() async {
    await AuthService.logout(); // AuthService ашиглан гарах.
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'), // Дэлгэцийн гарчиг.
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(), // Ачааллын индикатор.
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: currentUser == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: changeLanguage,
                          child: const Text("Хэл солих"),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: logout,
                          child: const Text("Гарах"),
                        ),
                      ],
                    )
                  : Card(
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Name: ${currentUser?.name?.firstname ?? "Unknown"} ${currentUser?.name?.lastname ?? ""}',
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Email: ${currentUser?.email ?? "Unknown"}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Username: ${currentUser?.username ?? "Unknown"}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Phone: ${currentUser?.phone ?? "Unknown"}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Address: ${currentUser?.address?.street ?? "Unknown"}, ${currentUser?.address?.city ?? "Unknown"}, ${currentUser?.address?.zipcode ?? "Unknown"}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: changeLanguage,
                              child: const Text("Хэл солих"),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: logout,
                              child: const Text("Гарах"),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
    );
  }
}
