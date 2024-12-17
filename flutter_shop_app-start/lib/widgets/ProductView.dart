import 'package:flutter/material.dart'; // Flutter UI зохион байгуулахад шаардлагатай сан.
import 'package:provider/provider.dart'; // State management хийхэд шаардлагатай сан.
import 'package:shop_app/models/product_model.dart'; // Бүтээгдэхүүний загвар.
import 'package:shop_app/provider/globalProvider.dart'; // Глобал өгөгдөл удирдах provider.
import 'package:shop_app/screens/product_detail.dart'; // Бүтээгдэхүүний дэлгэрэнгүй дэлгэц.

class ProductViewShop extends StatelessWidget {
  final ProductModel data; // Бүтээгдэхүүний өгөгдлийг дамжуулах.

  const ProductViewShop(this.data, {Key? key}) : super(key: key);

  // **Барааны дэлгэрэнгүй хуудас руу шилжих функц**
  _onTap(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => Product_detail(data)), // Product_detail рүү өгөгдөл дамжуулах.
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _onTap(context), // Товч дээр дарахад _onTap функц ажиллах.
      child: Card(
        elevation: 4.0, // Сүүдрийн түвшин.
        margin: const EdgeInsets.all(8.0), // Захын зай.
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, // Элементийг сунгах.
          children: [
            // **Бүтээгдэхүүний зураг**
            Container(
              height: 150.0, // Зургийн өндөр.
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(data.image!), // Зургийн URL.
                  fit: BoxFit.fitHeight, // Зургийг өндөрт багтаах.
                ),
              ),
            ),
            // **Бүтээгдэхүүний дэлгэрэнгүй**
            Padding(
              padding: const EdgeInsets.all(16.0), // Доторх зай.
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Зүүн талд төвлөрүүлэх.
                children: [
                  // **Бүтээгдэхүүний нэр**
                  Text(
                    data.title!, // Барааны нэр.
                    style: const TextStyle(
                      fontSize: 18.0, // Үсгийн хэмжээ.
                      fontWeight: FontWeight.bold, // Үсгийн жин.
                    ),
                  ),
                  const SizedBox(height: 8.0), // Босоо зай.
                  // **Бүтээгдэхүүний үнэ**
                  Text(
                    '\$${data.price!.toStringAsFixed(2)}', // Үнийг хоёр оронтой харуулах.
                    style: const TextStyle(
                      fontSize: 16.0, // Үсгийн хэмжээ.
                      color: Colors.green, // Үнийн өнгө.
                    ),
                  ),
                  const SizedBox(height: 8.0), // Босоо зай.
                  // **Дуртай барааны товч**
                  Consumer<Global_provider>(
                    builder: (context, globalProvider, child) {
                      // Хэрэглэгчийн нэвтэрсэн эсэхийг шалгах.
                      bool isLoggedIn = globalProvider.isUserLoggedIn();

                      return IconButton(
                        icon: Icon(
                          data.isFavorite // Дуртай статусын дагуу дүрс сонгох.
                              ? Icons.favorite // Дуртай.
                              : Icons.favorite_border, // Дуртай биш.
                          color: isLoggedIn ? Colors.red : Colors.grey, // Нэвтэрсэн эсэхээс хамаарч өнгө сонгох.
                        ),
                        onPressed: isLoggedIn
                            ? () {
                                // Хэрэглэгч нэвтэрсэн бол дуртай статусыг солих.
                                Provider.of<Global_provider>(context, listen: false)
                                    .toggleFavorite(data);
                              }
                            : () {
                                // Нэвтрээгүй үед нэвтрэхийг шаардах.
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('Login Required'), // Гарчиг.
                                    content: Text(
                                        'You need to log in to add to favorites.'), // Агуулга.
                                    actions: [
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
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
