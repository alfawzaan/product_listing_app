import 'package:product_listing_app/model/login_model.dart';
import 'package:product_listing_app/repository/repository.dart';
import 'package:rxdart/rxdart.dart';

class RegisterationBloc{
  Repository _repository = Repository();
  BehaviorSubject<LoginModel> _subject = BehaviorSubject();
  BehaviorSubject<LoginModel> get subject => _subject;

  registerUser(String email, String password) async{
    LoginModel loginModel = await _repository.doRegisterUser(email, password);
    _subject.sink.add(loginModel);
  }

  dispose(){
    _subject.close();
  }
}