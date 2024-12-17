// JSON өгөгдлийг хөрвүүлэхэд шаардлагатай сангууд.
import 'dart:convert'; // JSON өгөгдлийг объект руу хөрвүүлэх эсвэл буцаах.
import 'package:flutter/material.dart'; // Flutter-ийн UI-г зохион байгуулах.
import 'package:json_annotation/json_annotation.dart'; // JSON өгөгдлийг загварт хөрвүүлэх.
import 'package:provider/provider.dart'; // State management хийхэд ашиглана.
import 'package:shared_preferences/shared_preferences.dart'; // Локал өгөгдлийг хадгалах.

// GlobalProvider-ийг импортлох.
import 'package:shop_app/provider/globalProvider.dart';

// -------------------
// **CartModel**
// Сагсны өгөгдлийг JSON-оос объект руу хөрвүүлэх функц.
CartModel _$CartModelFromJson(Map<String, dynamic> json) {
  return CartModel(
    id: json['id'] as int, // Сагсны ID.
    userId: json['userId'] as int, // Хэрэглэгчийн ID.
    date: json['date'] as String, // Сагсны огноо.
    products: (json['products'] as List<dynamic>)
        .map((e) => Product.fromJson(e as Map<String, dynamic>))
        .toList(), // Сагсны бүтээгдэхүүний жагсаалт.
    v: json['__v'] as int, // Өгөгдлийн хувилбар.
  );
}

// Сагсны өгөгдлийг объект -> JSON руу хөрвүүлэх функц.
Map<String, dynamic> _$CartModelToJson(CartModel instance) => <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'date': instance.date,
      'products': instance.products.map((e) => e.toJson()).toList(),
      '__v': instance.v,
    };

// -------------------
// **Product**
// Бүтээгдэхүүний өгөгдлийг JSON-оос объект руу хөрвүүлэх функц.
Product _$ProductFromJson(Map<String, dynamic> json) {
  return Product(
    productId: json['productId'] as int, // Бүтээгдэхүүний ID.
    quantity: json['quantity'] as int, // Бүтээгдэхүүний тоо ширхэг.
  );
}

// Бүтээгдэхүүний өгөгдлийг объект -> JSON руу хөрвүүлэх функц.
Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'productId': instance.productId,
      'quantity': instance.quantity,
    };

// -------------------
// **CartModel**
// Сагсны загвар (class).
@JsonSerializable()
class CartModel {
  int id; // Сагсны ID.
  int userId; // Хэрэглэгчийн ID.
  String date; // Сагсны огноо.
  List<Product> products; // Сагсны бүтээгдэхүүний жагсаалт.
  int v; // Өгөгдлийн хувилбар (__v).

  CartModel({
    required this.id,
    required this.userId,
    required this.date,
    required this.products,
    required this.v,
  });

  // JSON-оос объект руу хөрвүүлэх.
  factory CartModel.fromJson(Map<String, dynamic> json) =>
      _$CartModelFromJson(json);

  // Объектоос JSON руу хөрвүүлэх.
  Map<String, dynamic> toJson() => _$CartModelToJson(this);
}

// -------------------
// **Product**
// Бүтээгдэхүүний загвар (class).
@JsonSerializable()
class Product {
  int productId; // Бүтээгдэхүүний ID.
  int quantity; // Бүтээгдэхүүний тоо ширхэг.

  Product({required this.productId, required this.quantity});

  // JSON-оос объект руу хөрвүүлэх.
  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  // Объектоос JSON руу хөрвүүлэх.
  Map<String, dynamic> toJson() => _$ProductToJson(this);
}

// -------------------
// **BagsPage**
// Сагсны өгөгдлийг харуулах дэлгэцийн загвар.
class BagsPage extends StatefulWidget {
  const BagsPage({Key? key}) : super(key: key);

  @override
  _BagsPageState createState() => _BagsPageState();
}

class _BagsPageState extends State<BagsPage> {
  late List<CartModel> cartList; // Сагсны өгөгдөл хадгалах жагсаалт.

  @override
  void initState() {
    super.initState();
    loadCartData(); // Сагсны өгөгдлийг ачаалж байна.
  }

  // **Сагсны өгөгдлийг SharedPreferences-с ачаалах.**
  Future<void> loadCartData() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = prefs.getString('cartData') ?? '[]'; // JSON өгөгдлийг авах.
    setState(() {
      cartList = List<CartModel>.from(json
          .decode(jsonData)
          .map((x) => CartModel.fromJson(x))); // JSON -> Объект.
    });
  }

  // **Сагсны өгөгдлийг SharedPreferences-д хадгалах.**
  Future<void> saveCartData() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = json.encode(cartList.map((cart) => cart.toJson()).toList());
    prefs.setString('cartData', jsonData); // JSON өгөгдлийг хадгалах.
  }

  @override
  void dispose() {
    saveCartData(); // Дэлгэц хаагдахад өгөгдлийг хадгална.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Сагсны жишээ JSON өгөгдөл.
    const jsonData =
        '[{"id":1,"userId":1,"date":"2020-03-02T00:00:00.000Z","products":[{"productId":1,"quantity":4},{"productId":2,"quantity":1},{"productId":3,"quantity":6}],"__v":0}]';

    List<CartModel> cartList = List<CartModel>.from(json
        .decode(jsonData)
        .map((x) => CartModel.fromJson(x))); // JSON -> Объект.

    return Consumer<Global_provider>(builder: (context, provider, child) {
      return Scaffold(
        appBar: AppBar(title: const Text('Cart')), // Сагсны дэлгэцийн гарчиг.
        body: ListView.separated(
          itemCount: cartList.length, // Сагсны элементийн тоо.
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            final cart = cartList[index]; // Тухайн сагсны өгөгдөл.
            return Card(
              margin: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Text('User ID: ${cart.userId}'), // Хэрэглэгчийн ID.
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Date: ${cart.date}'), // Огноо.
                    Text('Number of Products: ${cart.products.length}'), // Бүтээгдэхүүний тоо.
                    CartProductsList(
                      products: cart.products,
                      onDecrease: (product) {
                        decreaseQuantity(cart, product); // Тоо ширхэг багасгах.
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }

  // **Тоо ширхэгийг багасгах функц.**
  void decreaseQuantity(CartModel cart, Product product) {
    final globalProvider =
        Provider.of<Global_provider>(context, listen: false);
    globalProvider.decreaseQuantity(cart, product); // GlobalProvider ашиглах.
    saveCartData(); // Өгөгдлийг хадгална.
  }
}

// -------------------
// **CartProductsList**
// Бүтээгдэхүүний жагсаалтыг харуулах.
class CartProductsList extends StatelessWidget {
  final List<Product> products; // Бүтээгдэхүүний жагсаалт.
  final void Function(Product) onDecrease; // Тоо ширхэг багасгах функц.

  const CartProductsList(
      {super.key, required this.products, required this.onDecrease});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Products:'), // Гарчиг.
        ListView.builder(
          shrinkWrap: true, // Scroll асуудалгүй болгох.
          itemCount: products.length, // Бүтээгдэхүүний тоо.
          itemBuilder: (context, index) {
            final product = products[index];
            return ListTile(
              title: Text('Product ID: ${product.productId}'), // Бүтээгдэхүүний ID.
              subtitle: Row(
                children: [
                  Text('Quantity: ${product.quantity}'), // Бүтээгдэхүүний тоо ширхэг.
                  IconButton(
                    icon: const Icon(Icons.remove), // Хасах товч.
                    onPressed: () {
                      onDecrease(product); // Тоо ширхэг багасгах.
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
