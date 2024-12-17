// **Олон улсын хэл дэмжлэг (localization)**-ийн сан.
import 'package:easy_localization/easy_localization.dart';

// Flutter болон Provider сангууд.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/users.dart';

// Аппын өгөгдлийн загварууд ба Provider.
import 'package:shop_app/provider/globalProvider.dart'; // Глобал өгөгдөл удирдах provider.
import 'package:shop_app/services/auth_service.dart'; // Нэвтрэлтийн үйлчилгээ.

// Дэлгэцүүдийн импорт.
import 'bags_page.dart'; // Сагсны дэлгэц.
import 'shop_page.dart'; // Худалдааны дэлгэц.
import 'favorite_page.dart'; // Дуртай бүтээгдэхүүний дэлгэц.
import 'profile_page.dart'; // Хэрэглэгчийн профайлын дэлгэц.

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? loggedInUser; // Нэвтэрсэн хэрэглэгчийн мэдээллийг хадгалах.

  @override
  void initState() {
    super.initState();
    _loadLoggedInUser(); // Хэрэглэгчийн мэдээллийг ачаалах.
  }

  // **Нэвтэрсэн хэрэглэгчийн өгөгдлийг ачаалах.**
  Future<void> _loadLoggedInUser() async {
    final userId = await AuthService.getUserIdFromSharedPreferences(); // SharedPreferences-аас ID авах.
    if (userId != null) {
      final user = await AuthService.getUserById(userId); // ID-аар хэрэглэгчийн өгөгдлийг авах.
      setState(() {
        loggedInUser = user != null ? User.fromJson(user) : null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // **Профайл дэлгэцийг тохируулах.**
    final profilePage = loggedInUser != null
        ? ProfilePage(user: loggedInUser!) // Нэвтэрсэн хэрэглэгчийн мэдээллийг харуулах.
        : ProfilePage(); // Зочин хэрэглэгчийн профайл.

    // **Дэлгэцийн жагсаалт**
    final List<Widget> pages = [
      const ShopPage(), // Худалдааны дэлгэц.
      const BagsPage(), // Сагсны дэлгэц.
      const FavoritePage(), // Дуртай бүтээгдэхүүний дэлгэц.
      profilePage, // Профайл дэлгэц.
    ];

    // **Consumer ашиглан өгөгдөл удирдах.**
    return Consumer<Global_provider>(
      builder: (context, provider, child) {
        return Scaffold(
          // **Доод навигацийн цэсээр сонгогдсон дэлгэцийг харуулах.**
          body: pages[provider.currentIdx],

          // **Доод навигацийн цэс (BottomNavigationBar).**
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed, // Цэсний загвар.
            currentIndex: provider.currentIdx, // Одоогийн сонгогдсон индекс.

            // **Цэсний товчлуур дээр дарахад индекс өөрчлөх.**
            onTap: provider.changeCurrentIdx,

            // **Доод цэсний товчлуурууд.**
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.shop), // Дэлгүүрийн дүрс.
                label: 'Shopping'.tr(), // "Shopping" гэсэн текстийг localization ашиглан хөрвүүлэх.
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.shopping_basket), // Сагсны дүрс.
                label: 'Bag'.tr(), // "Bag" гэсэн текст.
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.favorite), // Дуртай бүтээгдэхүүний дүрс.
                label: 'Favorite'.tr(), // "Favorite" гэсэн текст.
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.person), // Хэрэглэгчийн дүрс.
                label: 'Profile'.tr(), // "Profile" гэсэн текст.
              ),
            ],
          ),
        );
      },
    );
  }
}
