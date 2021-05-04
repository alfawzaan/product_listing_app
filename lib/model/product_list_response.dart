import 'package:product_listing_app/model/product_model.dart';

class ProductListResponse {
  List<ProductModel> productList;
  String errorValue = "";

  ProductListResponse(this.productList, this.errorValue);

  ProductListResponse.fromJson(List<dynamic> json) {
    this.productList = json.map((e) => ProductModel.fromJson(e)).toList();
  }

  ProductListResponse.withError(String errorValue)
      : this.productList = null,
        this.errorValue = errorValue;
}
