import 'package:json_annotation/json_annotation.dart';

part 'dish.g.dart';

@JsonSerializable()
class Dish {
  final String name;
  final int price;
  final bool veggie;
  final int healthy;
  final int prepTime;
  final int difficulty;
  final String pictureUrl;

  final String id;

  Dish(this.id, this.name, this.price, this.veggie, this.healthy, this.prepTime,
      this.difficulty, this.pictureUrl)
      : super();

  factory Dish.fromJson(Map<String, dynamic> json) => _$DishFromJson(json);

  Map<String, dynamic> toJson() => _$DishToJson(this);
}
