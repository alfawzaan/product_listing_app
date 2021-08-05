import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:product_listing_app/bloc/category_list_bloc.dart';
import 'package:product_listing_app/bloc/registeration_bloc.dart';
import 'package:product_listing_app/model/login_model.dart';
import 'package:product_listing_app/views/category_page.dart';
import 'package:product_listing_app/views/excel_upload_screen.dart';
import 'package:product_listing_app/views/product_page.dart';

import '../bloc/login_bloc.dart';
import '../constants.dart';

class HomePageScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePageScreenState();
  }
}

class HomePageScreenState extends State<HomePageScreen> {
  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  LoginBloc loginBloc = LoginBloc();
  RegisterationBloc registrationBloc = RegisterationBloc();

  Stream loginStream;

  String loginInfo = "";
  bool showProgress = false;
  UserCredential credential;
  bool createAccount = false;
  bool showForm = false;
  bool isSignedIn = true;
  var catName = "";
  var catId = "";

  CategoryListBloc categoryListBloc = CategoryListBloc();

  @override
  void initState() {
    super.initState();
    loginStream = loginBloc.subject.stream;

    //LISTEN TO STREAM
    loginStream.listen((event) {
      LoginModel loginModel = event;
      setState(() {
        credential = loginModel.credential;

        if (loginModel.errorValue != null) {
          loginInfo = loginModel.errorValue;
        } else {
          showForm = false;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: [
          Row(
            children: [
              credential == null
                  ? customDeco(
                      InkWell(
                        child: Text("Sign In",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: getWidth(context,
                                    ratio:
                                    (isLargeScreen(context) || isMediumScreen(context)) ? 0.01 : 0.04))),
                        onTap: () {
                          setState(() {
                            showForm = true;
                            createAccount = false;
                          });
                        },
                      ),
                      Colors.white,
                      0.01)
                  : Container(),
              credential != null
                  ? customDeco(
                      InkWell(
                        child: Text("Sign Out",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: getWidth(context,
                                    ratio:
                                    (isLargeScreen(context) || isMediumScreen(context)) ? 0.01 : 0.04))),
                        onTap: () {
                          setState(() {
                            showForm = true;
                            createAccount = false;
                            credential = null;
                          });
                        },
                      ),
                      Colors.white,
                      0.01)
                  : Container(),
              credential != null
                  ? customDeco(
                      InkWell(
                        child: Text(
                          "Sync Data",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: getWidth(context,
                                  ratio: (isLargeScreen(context) || isMediumScreen(context)) ? 0.01 : 0.04)),
                        ),
                        onTap: () {
                          setState(() {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return ExcelUploadScreen();
                            }));
                          });
                        },
                      ),
                      Colors.white,
                      0.01)
                  : Container(),
            ],
          )
        ],
      ),
      body: homePageBuildComposer(context),
    );
  }

  Widget homePageBuildComposer(BuildContext context) {
    return Stack(
      children: [
        Row(
          children: [
            SizedBox(
              width: (isLargeScreen(context) || isMediumScreen(context))
                  ? getWidth(context, ratio: 0.3)
                  : getWidth(context),
              child: CategoryPage((category) {
                if (!isLargeScreen(context) && !isMediumScreen(context)) {
                  debugPrint("Loading Small Screen");
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ProductPage(category.catId, category.catName);
                  }));
                } else {
                  debugPrint("Loading Large Screen");
                  catId = category.catId;
                  catName = category.catName;
                  setState(() {});
                }
              }),
            ),
            Expanded(
                child: ((isLargeScreen(context) || isMediumScreen(context)) && catName != "")
                    ? ProductPage(catId, catName)
                    : Container())
          ],
        ),
        showForm
            ? Center(
                child: SizedBox(
                    width: getWidth(context,
                        ratio: (isLargeScreen(context) || isMediumScreen(context)) ? 0.4 : 1),
                    child: loginRegBuildComposer()))
            : Container()
      ],
    );
  }

  //BUILD LOGIN FORM
  Widget loginRegBuildComposer() {
    return customDeco(
        ListView(
          shrinkWrap: true,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: customDeco(
                  SizedBox(
                    width: getWidth(context,
                        ratio: (isLargeScreen(context) || isMediumScreen(context)) ? 0.03 : 0.08),
                    child: InkWell(
                        child: Icon(Icons.close),
                        onTap: () {
                          setState(() {
                            showForm = false;
                          });
                        }),
                  ),
                  Colors.white,
                  getWidth(context, ratio: 0.05)),
            ),
            customDeco(
                Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: getWidth(context, ratio: 0.06)),
                    child: TextField(
                      controller: emailTextController,
                      decoration: InputDecoration(hintText: "email"),
                    )),
                Colors.white,
                getWidth(context, ratio: .05)),
            customDeco(
                Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: getWidth(context, ratio: 0.06)),
                    child: TextField(
                        controller: passwordTextController,
                        decoration: InputDecoration(hintText: "Password"))),
                Colors.white,
                getWidth(context, ratio: .05)),
            Align(
              alignment: Alignment.center,
              child: RichText(
                text: TextSpan(
                    text: !createAccount ? "Create an account" : "Go to login",
                    style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: getWidth(context,
                            ratio: (isLargeScreen(context) || isMediumScreen(context)) ? 0.015 : 0.05)),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        setState(() {
                          createAccount = !createAccount;
                        });
                      }),
              ),
            ),
            createAccount
                ? InkWell(
                    child: textClick(
                        "create an account",
                        Colors.green,
                        getWidth(
                          context,
                        )),
                    onTap: () async {
                      FocusScope.of(context).unfocus();
                      setState(() {
                        showProgress = true;
                      });

                      final email = emailTextController.text;
                      final password = passwordTextController.text;

                      //PASS THE CREDENTIALS TO THE STREAM EVENT WAIT FOR THE LISTENER
                      loginStream = registrationBloc.subject.stream;

                      //LISTEN TO STREAM
                      loginStream.listen((event) {
                        LoginModel loginModel = event;
                        setState(() {
                          credential = loginModel.credential;
                          if (loginModel.errorValue != null) {
                            loginInfo = loginModel.errorValue;
                          } else {
                            showForm = false;
                          }
                        });
                      }).onError(() {});
                      await registrationBloc.registerUser(email, password);
                      setState(() {
                        showProgress = false;
                      });
                    })
                : InkWell(
                    child: textClick(
                        "Login", Colors.green, getWidth(context, ratio: .5)),
                    onTap: () async {
                      setState(() {
                        showProgress = true;
                      });
                      final email = emailTextController.text;
                      final password = passwordTextController.text;

                      //PASS THE CREDENTIALS TO THE STREAM EVENT WAIT FOR THE LISTENER
                      loginBloc.doLogin(email, password);
                      FocusScope.of(context).unfocus();
                      setState(() {
                        showProgress = false;
                      });
                    },
                  ),
            showProgress
                ? Center(
                    child: SizedBox(
                        width: getWidth(context, ratio: .3),
                        child: LinearProgressIndicator()),
                  )
                : Container(),
            Center(
              child: Text(loginInfo),
            )
          ],
        ),
        Colors.white70,
        30);
  }

  @override
  void dispose() {
    super.dispose();
    //CLOSE THE UserLoginBloc
    loginBloc.dispose();
  }
}
