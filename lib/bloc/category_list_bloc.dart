import 'package:product_listing_app/model/category_list_response.dart';
import 'package:product_listing_app/repository/repository.dart';
import 'package:rxdart/rxdart.dart';

class CategoryListBloc {
  Repository _repository = Repository();
  BehaviorSubject<CategoryListResponse> _subject = BehaviorSubject<CategoryListResponse>();

  BehaviorSubject<CategoryListResponse> get subject => _subject;

  getCategoryList() async {
    CategoryListResponse categoryListResponse =
        await _repository.doGetCategoryList();
    _subject.sink.add(categoryListResponse);
  }

  dispose() {
    _subject.close();
  }
}
