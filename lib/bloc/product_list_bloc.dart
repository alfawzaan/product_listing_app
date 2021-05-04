import 'package:product_listing_app/model/product_list_response.dart';
import 'package:product_listing_app/repository/repository.dart';
import 'package:rxdart/rxdart.dart';

class ProductListBloc {
  Repository _repository = Repository();
  BehaviorSubject<ProductListResponse> _subject = BehaviorSubject<ProductListResponse>();

  BehaviorSubject<ProductListResponse> get subject => _subject;

  getProductList(String category) async {
    ProductListResponse productListResponse =
        await _repository.doGetProductsList(category);
    _subject.sink.add(productListResponse);
  }

  dispose() {
    _subject.close();
  }
}
