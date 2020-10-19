import 'package:json_annotation/json_annotation.dart';

part 'ingredient.g.dart';

@JsonSerializable()
class Ingredient {
  final String name;
  final String measurementUnit;
  final String type; // Vegetable, meat, dairy,...
  final double price; // Price in euro for 1 measurementUnit
  final String pictureUrl;

  Ingredient(
      this.name, this.measurementUnit, this.type, this.price, this.pictureUrl)
      : super();

  factory Ingredient.fromJson(Map<String, dynamic> json) => _$IngredientFromJson(json);

  Map<String, dynamic> toJson() => _$IngredientToJson(this);
}
