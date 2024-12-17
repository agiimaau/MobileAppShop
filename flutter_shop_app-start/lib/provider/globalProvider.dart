import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/models/product_model.dart';
import 'package:shop_app/screens/bags_page.dart';

// ignore: camel_case_types
class Global_provider extends ChangeNotifier {
  // Бүх бүтээгдэхүүний жагсаалт
  List<ProductModel> products = [];
  
  // Худалдааны сагсны жагсаалт
  List<ProductModel> cartItems = [];
  
  // Одоогийн сонгогдсон индекс (жишээ нь: навигацийн доорх цэсний индекс)
  int currentIdx = 0;

  // Хэрэглэгч нэвтэрсэн эсэхийг заах төлөв
  bool _isLoggedIn = true;

  // SharedPreferences-г хадгалах хувьсагч
  late SharedPreferences _prefs;

  // -------------------------------
  // **Конструктор**
  // SharedPreferences-г инициализ хийхийн тулд дуудна.
  Global_provider() {
    _initSharedPreferences();
     _loadFavoritesFromStorage();
  }

  // -------------------------------
  // **SharedPreferences-г инициализ хийх функц**
  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // -------------------------------
  // **Бүтээгдэхүүний жагсаалт тохируулах**
  void setProducts(List<ProductModel> data) {
    // Бүтээгдэхүүн бүрийн дуртай төлөвийг (isFavorite) ачаалж байна
    products = data.map((product) {
      product.isFavorite = loadFavoriteStatus(product.id!);
      return product;
    }).toList();

    // UI-г шинэчлэхийг мэдэгдэх
    notifyListeners();
  }

  // -------------------------------
  // **Сагсанд бүтээгдэхүүн нэмэх эсвэл хасах**
  void addCartItems(ProductModel item) {
    if (cartItems.contains(item)) {
      // Хэрэв бүтээгдэхүүн аль хэдийн сагсанд байвал устгана
      cartItems.remove(item);
    } else {
      // Хэрэв байхгүй бол сагсанд нэмнэ
      cartItems.add(item);
    }
    notifyListeners();
  }

  // -------------------------------
  // **Одоогийн индекс солих**
  void changeCurrentIdx(int idx) {
    currentIdx = idx;
    notifyListeners();
  }

  // -------------------------------
  // **Дуртай бүтээгдэхүүнийг өөрчлөх (toggleFavorite)**
  // **Toggle Favorite**
  void toggleFavorite(ProductModel product) {
    if (!_isLoggedIn) {
      print('User is not logged in');
      return; // Prevent toggling if user is not logged in
    }

    final int index = products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      products[index].isFavorite = !products[index].isFavorite;
      _saveFavoritesToStorage(); // Save updated favorite state
      notifyListeners();
    }
  }
   // **Save Favorites to SharedPreferences**
  Future<void> _saveFavoritesToStorage() async {
    final favoriteIds = products
        .where((product) => product.isFavorite)
        .map((product) => product.id.toString())
        .toList();
    await _prefs.setStringList('favoriteIds', favoriteIds);
  }

  // -------------------------------
  // **Load Favorites from SharedPreferences**
  Future<void> _loadFavoritesFromStorage() async {
    final favoriteIds = _prefs.getStringList('favoriteIds') ?? [];
    for (var product in products) {
      product.isFavorite = favoriteIds.contains(product.id.toString());
    }
    notifyListeners();
  }


void saveFavorites() async {
  final prefs = await SharedPreferences.getInstance();
  final favoriteIds = products
      .where((product) => product.isFavorite) // Get only favorite items.
      .map((product) => product.id) // Extract their IDs.
      .toList();
  await prefs.setStringList('favoriteIds', favoriteIds.map((id) => id.toString()).toList());
}


  // -------------------------------
  // **SharedPreferences-оос дуртай бүтээгдэхүүний төлөв унших**
  bool loadFavoriteStatus(int productId) {
    return _prefs.getBool('favorite_$productId') ?? false;
  }

  // -------------------------------
  // **Дуртай бүтээгдэхүүнүүдийг авах**
  List<ProductModel> getFavoritesItems() {
    return products.where((product) => product.isFavorite).toList();
  }

  // -------------------------------
  // **Сагсан дахь бүтээгдэхүүний тоо ширхэгийг нэмэгдүүлэх**
  void increaseCartItemQuantity(ProductModel item) {
    final index = cartItems.indexWhere((cartItem) => cartItem.id == item.id);
    if (index != -1) {
      cartItems[index].count++;
      notifyListeners();
    }
  }

  // -------------------------------
  // **Сагсан дахь бүтээгдэхүүний тоо ширхэгийг багасгах**
  void decreaseQuantity(CartModel cart, Product product) {
    // Сагснаас тухайн бүтээгдэхүүнийг хайх
    final productItem = cart.products.firstWhere(
      (p) => p.productId == product.productId,
      orElse: () => Product(productId: 0, quantity: 0),
    );

    if (productItem.productId != 0) {
      if (productItem.quantity > 1) {
        // Хэрэв тоо ширхэг 1-ээс их байвал багасгана
        productItem.quantity--;
      } else {
        // Хэрэв 1-тэй тэнцүү байвал бүтээгдэхүүнийг устгана
        cart.products.remove(productItem);
      }
      notifyListeners();
    }
  }

  // -------------------------------
  // **Сагсны нийт үнийг тооцоолох**
  double calculateTotal() {
    return cartItems.fold(0, (sum, item) => sum + (item.price! * item.count));
  }

  // -------------------------------
  // **Хэрэглэгч нэвтэрсэн эсэхийг шалгах**
  bool isUserLoggedIn() {
    return _isLoggedIn;
  }

  // -------------------------------
  // **Хэрэглэгчийг нэвтрүүлэх**
  void loginUser() {
    _isLoggedIn = true;
    notifyListeners();
  }

  // -------------------------------
  // **Хэрэглэгчийг гарах**
  void logoutUser() {
    _isLoggedIn = false;
    notifyListeners();
  }
}
