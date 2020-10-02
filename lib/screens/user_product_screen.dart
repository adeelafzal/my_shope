import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:my_shope/models/product_provider.dart';
import 'package:my_shope/screens/edit_product_screen.dart';
import 'package:my_shope/widgets/app_drawer.dart';
import 'package:my_shope/widgets/user_product_item.dart';
import 'package:provider/provider.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = 'UserProductScreen';

  Future<void> refreshProducts(BuildContext context) async {
    await Provider.of<ProductProvider>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    //final product = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          )
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: refreshProducts(context),
        builder: (context, snapshot) {
          return RefreshIndicator(
            onRefresh: () => refreshProducts(context),
            child: Consumer(
              builder: (context, product, _) {
                return ListView.builder(
                  itemBuilder: (context, index) {
                    return snapshot.connectionState == ConnectionState.waiting
                        ? SpinKitFadingCircle(
                            color: Theme.of(context).accentColor,
                            size: 50.0,
                          )
                        : UserProductItem(
                            product.items[index].id,
                            product.items[index].desc,
                            product.items[index].title,
                            product.items[index].imageUrl,
                          );
                  },
                  itemCount: product.items.length,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
