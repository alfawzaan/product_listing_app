class ProductModel {
  String id;
  String name;
  String image;
  String sellingPrice;
  String buyingPrice;



  ProductModel(
      this.id, this.name, this.image, this.sellingPrice, this.buyingPrice);

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json["id"].toString();
    name = json["name"];
    image = json["image"];
    sellingPrice = json["sellingPrice"].toString();
    buyingPrice = json["buyingPrice"].toString();
  }


}
