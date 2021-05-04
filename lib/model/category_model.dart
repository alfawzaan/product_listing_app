class CategoryModel {
  String catId = "";
  String catName = "";
  String errorValue = "";

  CategoryModel(this.catId, this.catName);

  CategoryModel.fromJson(Map<String, dynamic> json) {
    catId = json['catId'];
    catName = json['catName'];
  }

  Map<String, dynamic> toJson(){
    return {
      "catId":catId,
      "catName":catName
    };
  }


}
