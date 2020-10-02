import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:my_shope/models/cart.dart';
import 'package:my_shope/models/product_provider.dart';
import 'package:my_shope/screens/cart_detail.dart';
import 'package:my_shope/widgets/app_drawer.dart';
import 'package:my_shope/widgets/badge.dart';
import 'package:my_shope/widgets/product_grid.dart';
import 'package:provider/provider.dart';

enum FilterOptions {
  All,
  Favorites,
}

class ProductScreen extends StatefulWidget {

  static const routeName = 'ProductScreen';

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  bool showOnlyfavorites = false;
  var inItState = true;
  var isLoading = false;

  @override
  void didChangeDependencies() {
    if (inItState) {
      setState(() {
        isLoading = true;
      });
      Provider.of<ProductProvider>(context)
          .fetchAndSetProducts()
          .then((_) => setState(() {
                isLoading = false;
              }));
    }
    inItState = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('MyShop'),
          actions: <Widget>[
            PopupMenuButton(
              onSelected: (FilterOptions value) {
                setState(() {
                  if (value == FilterOptions.Favorites) {
                    showOnlyfavorites = true;
                  } else {
                    showOnlyfavorites = false;
                  }
                });
              },
              icon: Icon(Icons.more_vert),
              itemBuilder: (_) => [
                PopupMenuItem(
                  child: Text('Show All'),
                  value: FilterOptions.All,
                ),
                PopupMenuItem(
                  child: Text('Only Favorites'),
                  value: FilterOptions.Favorites,
                ),
              ],
            ),
            Consumer<Cart>(
                builder: (context, value, child) => Badge(
                      value: value.itemCount.toString(),
                      child: child,
                    ),
                child: IconButton(
                  icon: Icon(Icons.shopping_basket),
                  onPressed: () {
                    Navigator.pushNamed(context, CartDetail.routeName);
                  },
                ))
          ],
        ),
        drawer: AppDrawer(),
        body: isLoading
            ? SpinKitFadingCircle(
                color: Theme.of(context).accentColor,
                size: 50.0,
              )
            : ProductGrid(showOnlyfavorites));
  }
}
