import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:product_listing_app/bloc/category_list_bloc.dart';
import 'package:product_listing_app/model/category_list_response.dart';
import 'package:product_listing_app/model/category_model.dart';
import 'package:product_listing_app/views/product_page.dart';

import '../constants.dart';

typedef Null ItemSelectedCallback(CategoryModel category);

class CategoryPage extends StatefulWidget {
  final ItemSelectedCallback itemSelectedCallback;

  CategoryPage(this.itemSelectedCallback);

  @override
  State<StatefulWidget> createState() {
    return CategoryPageState();
  }
}

class CategoryPageState extends State<CategoryPage> {
  CategoryListBloc categoryListBloc = CategoryListBloc();

  @override
  void initState() {
    super.initState();

    categoryListBloc.getCategoryList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: categoryPageBuildComposer(context),
    );
  }

  Widget categoryPageBuildComposer(BuildContext context) {
    return StreamBuilder(
        stream: categoryListBloc.subject.stream,
        builder: (context, asyncsnapshot) {
          debugPrint("IS LARGE SCREEN: ${isLargeScreen(context)}");
          if (asyncsnapshot.hasData) {
            if (asyncsnapshot.data.errorValue != null &&
                asyncsnapshot.data.errorValue.length > 0) {
              return Center(child: Text("No category Entry at the moment"));
            }

            return categoryListBuildComposer(asyncsnapshot.data);
          } else if (asyncsnapshot.hasError) {
            return Center(
                child: Text("An error occurred while fetching categories"));
          } else {
            return Center(
                child: SizedBox(
                    width: getWidth(context, ratio: .3),
                    child: LinearProgressIndicator()));
          }
        });
  }

  //BUILD CATEGORY LIST FROM THE STREAM DATA
  Widget categoryListBuildComposer(CategoryListResponse categoryResponse) {
    List<CategoryModel> categories = categoryResponse.categoryList;

    if (categories.length == 0) {
      return Text("Sorry! no category entry at the moment");
    } else {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: categories == null ? 0 : categories.length,
        itemBuilder: (context, index) {
          debugPrint("CHECKING PRODUCTS ${categories[index].catName}");

          return customDeco(categoryBuildComposer(categories[index]), Colors.white70,
              getWidth(context, ratio: 0.05));
        },
      );
    }
  }

  //PROCESS INDIVIDUAL CATEGORY DATA
  Widget categoryBuildComposer(CategoryModel category) {
    return InkWell(
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal:
                getWidth(context, ratio: isLargeScreen(context) ? 0.01 : 0.04),
            vertical:
                getWidth(context, ratio: isLargeScreen(context) ? 0.01 : 0.03)),
        child: Text(
          category.catName,
          softWrap: true,
          style: TextStyle(
              fontSize: getWidth(context,
                  ratio: isLargeScreen(context) ? 0.01 : 0.05),
              fontWeight: FontWeight.bold),
        ),
      ),
      onTap: () {
        debugPrint("CHECKING PRODUCTS");
        widget.itemSelectedCallback(category);
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    categoryListBloc.dispose();
  }
}
