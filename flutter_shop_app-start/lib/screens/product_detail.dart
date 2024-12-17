import 'package:flutter/material.dart'; // Flutter UI зохион байгуулахад шаардлагатай сан.
import 'package:provider/provider.dart'; // State management-д шаардлагатай сан.
import 'package:shop_app/models/product_model.dart'; // Бүтээгдэхүүний загвар.
import 'package:shop_app/provider/globalProvider.dart'; // Глобал өгөгдөл удирдах provider.

// **Product_detail ангилал**
// ignore: camel_case_types
class Product_detail extends StatelessWidget {
  // **Бүтээгдэхүүний өгөгдөл дамжуулах хувьсагч.**
  final ProductModel product;

  // **Constructor**
  const Product_detail(this.product, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // **Provider ашиглан Global_provider-оос өгөгдөл авах.**
    return Consumer<Global_provider>(
      builder: (context, provider, child) {
        // **Хэрэглэгчийн нэвтэрсэн эсэхийг шалгах.**
        bool isLoggedIn = provider.isUserLoggedIn();

        return Scaffold(
          appBar: AppBar(), // Дэлгэцийн дээд хэсгийн гарчиг.
          body: Column(
            children: [
              // **Бүтээгдэхүүний зураг.**
              Image.network(
                product.image!, // Бүтээгдэхүүний зурагны URL.
                height: 200, // Зургийн өндөр.
              ),
              // **Бүтээгдэхүүний нэр.**
              Text(
                product.title!,
                style: const TextStyle(
                  fontSize: 25, // Үсгийн хэмжээ.
                  fontWeight: FontWeight.bold, // Үсгийн жин.
                ),
              ),
              // **Бүтээгдэхүүний тайлбар.**
              Text(
                product.description!,
                style: const TextStyle(fontSize: 16), // Үсгийн хэмжээ.
              ),
              // **Бүтээгдэхүүний үнэ.**
              Text(
                'PRICE: \$${product.price}', // Үнийг доллароор харуулах.
                style: const TextStyle(
                  fontSize: 25, // Үсгийн хэмжээ.
                  fontWeight: FontWeight.bold, // Үсгийн жин.
                ),
              ),
            ],
          ),
          // **FloatingActionButton (Сагсанд нэмэх товч).**
          floatingActionButton: isLoggedIn
              ? FloatingActionButton(
                  // **Нэвтэрсэн үед сагсанд бүтээгдэхүүн нэмэх.**
                  onPressed: () {
                    provider.addCartItems(product); // Сагсанд нэмэх функц дуудах.
                  },
                  child: const Icon(Icons.shopping_cart), // Сагсны дүрс.
                )
              : FloatingActionButton.extended(
                  // **Нэвтрэх шаардлагатай үед харуулах.**
                  onPressed: () {
                    // **Нэвтрэхийг шаардах мессеж харуулах.**
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Login Required'), // Мессежийн гарчиг.
                        content: Text(
                            'You need to log in to add items to the cart.'), // Мессежийн агуулга.
                        actions: [
                          // **OK товч.**
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // Диалогыг хаах.
                            },
                            child: Text('OK'), // Товчны текст.
                          ),
                        ],
                      ),
                    );
                  },
                  icon: Icon(Icons.shopping_cart), // Сагсны дүрс.
                  label: Text('Login to Add to Cart'), // Товчны текст.
                ),
        );
      },
    );
  }
}
