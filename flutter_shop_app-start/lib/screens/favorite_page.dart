import 'package:flutter/material.dart'; // Flutter UI-д ашиглагдана.
import 'package:provider/provider.dart'; // State management хийхэд ашиглана.
import 'package:shop_app/models/product_model.dart'; // Бүтээгдэхүүний загвар.
import 'package:shop_app/provider/globalProvider.dart'; // Глобал өгөгдөл удирдах provider.

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key}); // Конструктор.

  @override
  Widget build(BuildContext context) {
    // **Global_provider-оос дуртай бүтээгдэхүүний жагсаалтыг авах.**
    List<ProductModel> favoritedItems =
        Provider.of<Global_provider>(context).getFavoritesItems();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'), // Дэлгэцийн гарчиг.
      ),
      // **Дуртай бүтээгдэхүүн хоосон эсэхийг шалгах.**
      body: favoritedItems.isEmpty
          ? const Center(
              // Хэрэв дуртай бүтээгдэхүүн байхгүй бол текст харуулна.
              child: Text('No favorite items yet.'), // Хоосон үед харуулах текст.
            )
          : ListView.builder(
              // **Дуртай бүтээгдэхүүний жагсаалтыг харуулах.**
              itemCount: favoritedItems.length, // Жагсаалтын нийт тоо.
              itemBuilder: (context, index) {
                // **Бүтээгдэхүүний нэг элементийг харуулах ListTile.**
                return ListTile(
                  leading: Image.network(
                    favoritedItems[index].image ?? '', // Зурагны URL.
                    width: 50, // Зургийн өргөн.
                    height: 50, // Зургийн өндөр.
                    fit: BoxFit.cover, // Зургийг бүрэн багтаах.
                  ),
                  title: Text(favoritedItems[index].title ?? ''), // Бүтээгдэхүүний нэр.
                  subtitle: Text(
                    '\$${favoritedItems[index].price?.toStringAsFixed(2) ?? ''}', // Бүтээгдэхүүний үнэ.
                  ),
                  // Энэ хэсэгт нэмэлт тохируулга буюу функцүүдийг хэрэгжүүлж болно.
                );
              },
            ),
    );
  }
}
