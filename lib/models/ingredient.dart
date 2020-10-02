class Ingredient {
  final String name;
  final String measurementUnit;
  final String type; // Vegetable, meat, dairy,...
  final double price; // Price in euro for 1 measurementUnit
  final String pictureUrl;

  Ingredient(
      this.name, this.measurementUnit, this.type, this.price, this.pictureUrl)
      : super();
}

class IngredientAmount {
  final Ingredient ingredient;
  final double amount;

  IngredientAmount(this.ingredient, this.amount) : super();
}
