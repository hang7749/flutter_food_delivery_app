import 'package:food_delivery_app/model/category_model.dart';

List<CategoryModel> getCategories() {

  List<CategoryModel> categories = [];
  CategoryModel categoryModel = new CategoryModel();

  categoryModel.name = "Pizza";
  categoryModel.image = "images/pizza.png";
  categories.add(categoryModel);
  categoryModel = new CategoryModel();

  categoryModel.name = "Burger";
  categoryModel.image = "images/burger.png";
  categories.add(categoryModel);
  categoryModel = new CategoryModel();

  categoryModel.name = "Chinese";
  categoryModel.image = "images/chinese.png";
  categories.add(categoryModel);
  categoryModel = new CategoryModel();

  categoryModel.name = "Mexican";
  categoryModel.image = "images/tacos.png";
  categories.add(categoryModel);
  
  return categories;
}