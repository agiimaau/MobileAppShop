import 'package:flutter/material.dart'; // Flutter UI-д шаардлагатай сан.
import 'package:provider/provider.dart'; // State management-д шаардлагатай сан.
import 'package:shop_app/provider/globalProvider.dart'; // Глобал өгөгдөл удирдах provider.
import 'package:shop_app/services/auth_service.dart'; // Нэвтрэлтийн үйлчилгээ.

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // **TextEditingController** нь текстийн талбарын өгөгдлийг удирдана.
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'), // Дэлгэцийн гарчиг.
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Бүх талд зай авах.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Босоо тэнхлэгт төвлөрүүлэх.
          children: [
            // **Хэрэглэгчийн нэр оруулах талбар.**
            TextField(
              controller: _usernameController, // Өгөгдлийг удирдах controller.
              decoration: const InputDecoration(labelText: 'Username'), // Placeholder текст.
            ),
            // **Нууц үг оруулах талбар.**
            TextField(
              controller: _passwordController, // Өгөгдлийг удирдах controller.
              obscureText: true, // Нууц үг нууцлагдсан байдал.
              decoration: const InputDecoration(labelText: 'Password'), // Placeholder текст.
            ),
            const SizedBox(height: 20), // Босоо зайн хэмжээс.
            // **Нэвтрэх товч (Sign In).**
            ElevatedButton(
              onPressed: () async {
                // Текстийн талбараас өгөгдөл авах.
                final username = _usernameController.text;
                final password = _passwordController.text;

                // Хэрэв нэр эсвэл нууц үг хоосон бол анхааруулах мессеж харуулах.
                if (username.isEmpty || password.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter both username and password'),
                    ),
                  );
                  return;
                }

                // **AuthService** ашиглан нэвтрэлтийн эрхийг шалгах.
                final loginSuccessful =
                    await AuthService.login(username, password);

                if (!loginSuccessful) {
                  // Хэрэв нэвтрэлт амжилтгүй бол анхааруулах мессеж харуулах.
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Invalid username or password'),
                    ),
                  );
                } else {
                  // Хэрэв нэвтрэлт амжилттай бол "Home" дэлгэц рүү шилжих.
                  // ignore: use_build_context_synchronously
                  Navigator.pushReplacementNamed(context, '/home');
                }
              },
              child: const Text('Sign In'), // Товчны текст.
            ),
            const SizedBox(height: 10), // Босоо зайн хэмжээс.
            // **Зочин горимоор нэвтрэх товч (Guest).**
            ElevatedButton(
              onPressed: () {
                // **Global_provider** ашиглан хэрэглэгчийг зочин горимд оруулах.
                Global_provider gp =
                    Provider.of<Global_provider>(context, listen: false);
                gp.logoutUser(); // Хэрэглэгчийг зочин горимд тохируулах.

                // "Home" дэлгэц рүү шилжих.
                Navigator.pushReplacementNamed(context, '/home');
              },
              child: const Text('Guest'), // Товчны текст.
            ),
          ],
        ),
      ),
    );
  }
}
