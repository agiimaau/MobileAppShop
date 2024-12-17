import 'package:json_annotation/json_annotation.dart';
part 'product_model.g.dart'; //json serializable ashiglasn code -iig holboh

//json to object hurwuuleh functioniig uusgene.
//but object to json uusgehgui.
@JsonSerializable(createToJson: false)
class ProductModel {
  final int? id;
  final String? title;
  final double? price;
  final String? description;
  final String? category;
  final String? image;
  final Rating? rating;
  bool isFavorite;
  int count;
  //constructor
  ProductModel({
    this.isFavorite = false,
    this.id,
    this.title,
    this.price,
    this.description,
    this.category,
    this.image,
    this.rating,
    this.count = 1,
  });

 //json-iig product model bolgono 
  ProductModel fromJson(Map<String, dynamic> json) {
    return _$ProductModelFromJson(json);
  }
  
//json list to obeject list
  static List<ProductModel> fromList(List<dynamic> data) => data.map((e) => ProductModel().fromJson(e)).toList();
  
  Map<String, dynamic> toJson() {//obj to json
    throw UnimplementedError();
  }
}

@JsonSerializable(createToJson: false)
class Rating {
  double? rate;
  int? count;

  Rating({this.rate, this.count});
//_$RatingFromJson функц нь json_serializable 
//хэрэгслээр автоматаар үүсгэгддэг.
  factory Rating.fromJson(Map<String, dynamic> json) {
    return _$RatingFromJson(json);
  }
}
