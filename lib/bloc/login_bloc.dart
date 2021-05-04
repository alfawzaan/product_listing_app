import 'package:product_listing_app/model/login_model.dart';
import 'package:product_listing_app/repository/repository.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc {

  Repository _repository = Repository();
  BehaviorSubject<LoginModel> _subject = BehaviorSubject<LoginModel>();
  BehaviorSubject<LoginModel> get subject => _subject;

  doLogin(String email, String password) async{
    LoginModel  loginModel = await _repository.doUserLogin(email, password);
    _subject.sink.add(loginModel);
  }

  dispose(){
    _subject.close();
  }
}