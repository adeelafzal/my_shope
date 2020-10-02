import 'package:flutter/material.dart';
import 'package:my_shope/models/products.dart';
import 'package:my_shope/models/product_provider.dart';
import 'package:my_shope/widgets/product_item.dart';
import 'package:provider/provider.dart';

class ProductGrid extends StatelessWidget {
  bool Showfavoure;

  ProductGrid(this.Showfavoure);

  @override
  Widget build(BuildContext context) {

    final products = Provider.of<ProductProvider>(context);
    return GridView.builder(
      padding: EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        return ChangeNotifierProvider.value(
            value: Showfavoure ? products.favoriteList[index] : products.items[index],
            child: ProductsItem());
      },
      itemCount: Showfavoure ? products.favCount : products.taskCount,
    );
  }
}
