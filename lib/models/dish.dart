import 'package:json_annotation/json_annotation.dart';

part 'dish.g.dart';

@JsonSerializable()
class Dish {
  final String name;
  final int price;
  final bool veggie;
  final int healthy;
  final int prep_time;
  final int difficulty;
  final String picture;

  final String id;

  Dish(this.id, this.name, this.price, this.veggie, this.healthy, this.prep_time,
      this.difficulty, this.picture)
      : super();

  factory Dish.fromJson(Map<String, dynamic> json) => _$DishFromJson(json);

  Map<String, dynamic> toJson() => _$DishToJson(this);
}
