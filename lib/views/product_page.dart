import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:product_listing_app/bloc/product_list_bloc.dart';
import 'package:product_listing_app/model/product_list_response.dart';
import 'package:product_listing_app/model/product_model.dart';

import '../constants.dart';

class ProductPage extends StatefulWidget {
  String catId;
  String catName;

  ProductPage(this.catId, this.catName);

  @override
  State<StatefulWidget> createState() {
    return ProductPageState();
  }
}

class ProductPageState extends State<ProductPage> {
  ProductListBloc productListBloc = ProductListBloc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    debugPrint("CHECKING PRODUCTS INIT");

    // productListBloc.getProductList(widget.catName);
  }

  @override
  Widget build(BuildContext context)  {
    doGetList();
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.catName} Products"),
      ),
      body: buildProductList(context),
    );
  }

  void doGetList() async{
     productListBloc.subject.stream.drain();
    productListBloc.getProductList(widget.catName);
  }

  Widget buildProductList(BuildContext context) {
    return StreamBuilder(
        stream: productListBloc.subject.stream,
        builder: (context, asyncsnapshot) {
          if (asyncsnapshot.hasData) {
            if (asyncsnapshot.data.errorValue != null &&
                asyncsnapshot.data.errorValue.length > 0) {
              return Center(
                  child: Text("Sorry, No product available at the moment"));
            }

            return productListBuildComposer(asyncsnapshot.data);
          } else if (asyncsnapshot.hasError) {
            return Center(
                child: Text("An error occurred while fetching products"));
          } else {
            return Center(
                child: SizedBox(
                    width: getWidth(context, ratio: .3),
                    child: LinearProgressIndicator()));
          }
        });
  }

  //BUILD PRODUCT LIST FROM THE STREAM DATA
  productListBuildComposer(ProductListResponse productResponse) {
    List<ProductModel> products = productResponse.productList;
    if (products.length == 0) {
      return Text("Sorry! no product entry at the moment");
    } else {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: products == null ? 0 : products.length,
        itemBuilder: (context, index) {
          var product = products[index];
          return customDeco(productBuildComposer(product), Colors.white70,
              getWidth(context, ratio: isLargeScreen(context) ? 0.02 : .1));
        },
      );
    }
  }

  //PROCESS INDIVIDUAL PRODUCT DATA
  productBuildComposer(ProductModel product) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal:
              getWidth(context, ratio: isLargeScreen(context) ? 0.02 : 0.04),
          vertical:
              getWidth(context, ratio: isLargeScreen(context) ? 0.02 : 0.03)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.max,
        children: [
          CachedNetworkImage(
            imageUrl: product.image,
            placeholder: (context, url) => Text("Loading..."),
            errorWidget: (context, url, error) => Icon(Icons.error),
            width: getWidth(context, ratio: isLargeScreen(context) ? 0.4 : 0.9),
            height: getHeight(context, ratio: 0.3),
            fit: BoxFit.cover,
          ),
/*
          Image.network(
            "https://i.stack.imgur.com/dKNUO.jpg",
            width: getWidth(context, ratio: isLargeScreen(context) ? 0.4 : 0.9),
            height: getHeight(context, ratio: 0.3),
            fit: BoxFit.cover,
          ),
*/
          Text(
            product.name,
            softWrap: true,
            style: TextStyle(
                fontSize: getWidth(context,
                    ratio: isLargeScreen(context) ? 0.01 : .05),
                fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              Text(
                "Selling Price:",
                softWrap: true,
                style: TextStyle(
                    fontSize: getWidth(context,
                        ratio: isLargeScreen(context) ? 0.01 : .05),
                    fontWeight: FontWeight.bold),
              ),
              Expanded(
                  child: Text(
                product.sellingPrice,
                softWrap: true,
                style: TextStyle(
                    fontSize: getWidth(context,
                        ratio: isLargeScreen(context) ? 0.01 : .05)),
              ))
            ],
          ),
          Row(
            children: [
              Text(
                "Buying Price:",
                softWrap: true,
                style: TextStyle(
                    fontSize: getWidth(context,
                        ratio: isLargeScreen(context) ? 0.01 : .05),
                    fontWeight: FontWeight.bold),
              ),
              Expanded(
                  child: Text(
                product.buyingPrice,
                softWrap: true,
                style: TextStyle(
                    fontSize: getWidth(context,
                        ratio: isLargeScreen(context) ? 0.01 : .05)),
              ))
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    productListBloc.dispose();
  }
}
