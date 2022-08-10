import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/constants/image_assets.dart';
import '../../../../core/utils/custom_textfield.dart';
import '../../../../data/remote/products/products.dart';
import '../../../../di/di.dart';
import '../view/search_product.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  List<Product> product = [];
  var productService = getIt<ProductService>();
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  Search search = Search();

  @override
  void initState() {
    _db.collection('product').get().then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((element) {
        setState(() {
          print(element);
          product.add(Product(
            category: element['category'],
            created_at: element['created_at'],
            description: element['description'],
            id: element['id'],
            image: element['images'][0],
            price: element["price"],
            document: element,
            product_name: element['product_name'],
            shipping_type: element['shipping_type'],
            user_id: element['user_id'],
          ));
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return OlxTextFormField(
      hintText: "Search for products",
      onTap: () {
        search.search(context, product);
      },
      // enabled: false,
      prefixIcon: Container(
        padding: EdgeInsets.all(15),
        height: 10,
        width: 10,
        child: SvgPicture.asset(
          ImagesAsset.search,
          height: 2,
          width: 2,
        ),
      ),
    );
  }
}
