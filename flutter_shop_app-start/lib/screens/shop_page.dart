import 'package:flutter/material.dart'; // Flutter UI зохион байгуулахад шаардлагатай сан.
import 'package:provider/provider.dart'; // State management хийхэд шаардлагатай сан.
import 'package:shop_app/models/product_model.dart'; // Бүтээгдэхүүний загвар.
import 'package:shop_app/provider/globalProvider.dart'; // Глобал өгөгдөл удирдах provider.
import '../widgets/ProductView.dart'; // Барааны харагдах байдал.
import 'dart:convert'; // JSON өгөгдлийг удирдах.

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  // **Барааны өгөгдлийг JSON файлаас унших функц.**
  Future<List<ProductModel>> _getData() async {
    // **assets/products.json** файлд хадгалсан өгөгдлийг уншина.
    String res =
        await DefaultAssetBundle.of(context).loadString("assets/products.json");

    // JSON өгөгдлийг ProductModel жагсаалт руу хөрвүүлэх.
    List<ProductModel> data = ProductModel.fromList(jsonDecode(res));

    // **Global_provider** ашиглан бүтээгдэхүүнийг тохируулах.
    Provider.of<Global_provider>(context, listen: false).setProducts(data);

    // **Global_provider**-оос тохируулагдсан бүтээгдэхүүний жагсаалтыг буцаах.
    return Provider.of<Global_provider>(context, listen: false).products;
  }

  @override
  Widget build(BuildContext context) {
    // **FutureBuilder ашиглан өгөгдлийг ачаалж харуулах.**
    return FutureBuilder(
      future: _getData(), // _getData функцыг дуудна.
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          // Хэрэв өгөгдөл ачаалагдсан бол барааг харуулах.
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Зүүн талд төвлөрүүлэх.
              children: [
                const SizedBox(height: 10), // Босоо зай.
                // **"Бараанууд" гарчиг.**
                const Padding(
                  padding: EdgeInsets.only(left: 10), // Зүүн талын зай.
                  child: Text(
                    "Бараанууд",
                    style: TextStyle(
                      fontSize: 24, // Үсгийн хэмжээ.
                      fontWeight: FontWeight.bold, // Үсгийн жин.
                      color: Color.fromARGB(223, 37, 37, 37), // Өнгө.
                    ),
                  ),
                ),
                const SizedBox(height: 10), // Босоо зай.
                // **Барааны жагсаалт.**
                Padding(
                  padding: const EdgeInsets.only(left: 10), // Зүүн талын зай.
                  child: Wrap(
                    spacing: 20, // Бараануудын хоорондох зай.
                    runSpacing: 10, // Мөр хоорондын зай.
                    children: List.generate(
                      // Барааны тоогоор widget үүсгэх.
                      snapshot.data!.length,
                      (index) =>
                          ProductViewShop(snapshot.data![index]), // Барааны харагдах байдлыг харуулах.
                    ),
                  ),
                ),
                const SizedBox(height: 20), // Доод талд зай авах.
              ],
            ),
          );
        } else {
          // Өгөгдөл ачаалж байх үед ачааллын индикатор харуулах.
          return const Center(
            child: SizedBox(
              height: 25, // Индикаторын өндөр.
              width: 25, // Индикаторын өргөн.
              child: CircularProgressIndicator(), // Ачааллын индикатор.
            ),
          );
        }
      }),
    );
  }
}
