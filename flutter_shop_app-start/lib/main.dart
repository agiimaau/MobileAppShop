import 'package:easy_localization/easy_localization.dart'; // Олон хэлний дэмжлэг.
import 'package:flutter/material.dart'; // Flutter UI зохион байгуулахад шаардлагатай сан.
import 'package:provider/provider.dart'; // State management хийхэд шаардлагатай сан.
import 'package:shop_app/global_keys.dart'; // Глобал навигацийн түлхүүр.
import 'package:shop_app/provider/globalProvider.dart'; // Глобал өгөгдөл удирдах provider.
import 'package:shop_app/screens/login_page.dart'; // Нэвтрэх дэлгэц.
import 'package:shop_app/screens/home_page.dart'; // Үндсэн дэлгэц.

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Програмын хувьд шаардлагатай инициализ хийх.
  await EasyLocalization.ensureInitialized(); // Easy Localization-ийн тохиргоог инициализ хийх.
  
  // **runApp** функцээр програм эхлүүлэх.
  runApp(
    ChangeNotifierProvider(
      create: (context) => Global_provider(), // **Provider**-ийг аппд нэвтрүүлэх.
      child: EasyLocalization(
        supportedLocales: [Locale('en', 'US'), Locale('mn', 'MN')], // Дэмжигдэх хэлүүд.
        path: 'assets/translations', // Орчуулгын файлын зам.
        fallbackLocale: Locale('en', 'US'), // Анхдагч хэл.
        child: MyApp(), // Програмын үндсэн widget.
      ),
    ),
  );
}

// **MyApp ангилал**
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // **Easy Localization тохиргоо**
      localizationsDelegates: context.localizationDelegates, // Орчуулгын делегатууд.
      supportedLocales: context.supportedLocales, // Дэмжигдэх хэлүүд.
      locale: context.locale, // Одоогийн хэл.

      // **Global Navigator Key**
      navigatorKey: GlobalKeys.navigatorKey, // Глобал навигацийн түлхүүр.

      // **Сэдэв**
      theme: ThemeData(
        useMaterial3: false, // Material3-ийг идэвхгүй болгох.
      ),

      // **Эх дэлгэц**
      initialRoute: '/login', // Эхлүүлэх маршрут.

      // **Маршрутууд**
      routes: {
        '/login': (context) => LoginPage(), // Нэвтрэх дэлгэц.
        '/home': (context) => HomePage(), // Үндсэн дэлгэц.
      },
    );
  }
}
