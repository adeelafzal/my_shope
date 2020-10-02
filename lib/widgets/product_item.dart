import 'package:flutter/material.dart';
import 'package:my_shope/models/auth.dart';
import 'package:my_shope/models/cart.dart';
import 'package:my_shope/models/products.dart';
import 'package:my_shope/screens/product_details.dart';
import 'package:provider/provider.dart';

class ProductsItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final value = Provider.of<Products>(context, listen: false);
    final cartValue = Provider.of<Cart>(context, listen: false);
    final authValue = Provider.of<Auth>(context, listen: false);
    return Card(
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.deepPurple, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 6,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GridTile(
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, Productdetail.routeName,
                  arguments: {'id': value.id, 'title': value.title});
            },
            child: Image.network(
              value.imageUrl,
              width: double.infinity,
              fit: BoxFit.cover,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.grey,
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes
                        : null,
                  ),
                );
              },
            ),
          ),
          footer: GridTileBar(
            backgroundColor: Colors.black54,
            title: Text(
              value.title,
            ),
            leading: IconButton(
              onPressed: () {
                value.toggleFavoriteStatus(authValue.token,authValue.userid);
              },
              icon: Icon(
                value.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Theme.of(context).accentColor,
              ),
            ),
            trailing: IconButton(
              onPressed: () {
                cartValue.addItem(value.id, value.price, value.title);
                Scaffold.of(context).hideCurrentSnackBar();
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text('Item added to cart!'),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                    onPressed: () {
                      cartValue.removeSingleItem(value.id);
                    },
                    label: 'Undo',
                  ),
                ));
              },
              icon: Icon(
                Icons.add_shopping_cart,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
