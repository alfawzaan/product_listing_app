import 'package:product_listing_app/model/category_model.dart';

class CategoryListResponse {
  List<CategoryModel> categoryList;
  String errorValue = "";

  CategoryListResponse(this.categoryList, this.errorValue);

  CategoryListResponse.fromJson(List<dynamic> json) {
    this.categoryList = json.map((e) => CategoryModel.fromJson(e)).toList();
  }

  CategoryListResponse.withError(String errorValue) {
    this.categoryList = null;
    this.errorValue = errorValue;
  }
}
