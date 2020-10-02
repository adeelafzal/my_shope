import 'package:flutter/material.dart';
import 'package:my_shope/models/product_provider.dart';
import 'package:my_shope/screens/edit_product_screen.dart';
import 'package:provider/provider.dart';

class UserProductItem extends StatelessWidget {
  final String id, title, imageUrl, desc;

  UserProductItem(this.id, this.desc, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.purple, width: 0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 3,
      child: Row(
        children: <Widget>[
          Container(
            width: 100,
            height: 100,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                imageUrl,
                width: double.infinity,
                fit: BoxFit.cover,
                loadingBuilder: (BuildContext context,
                    Widget child,
                    ImageChunkEvent loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress
                          .expectedTotalBytes !=
                          null
                          ? loadingProgress
                          .cumulativeBytesLoaded /
                          loadingProgress
                              .expectedTotalBytes
                          : null,
                    ),
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: ListTile(
              title: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                desc,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Container(
                width: 100,
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                          EditProductScreen.routeName,
                          arguments: id,
                        );
                      },
                      color: Theme.of(context).primaryColor,
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Text('Are you sure?'),
                            content: Text('Do you want to delete this product?'),
                            actions: <Widget>[
                              FlatButton(onPressed: () {
                                Navigator.of(ctx).pop(false);
                              },
                                child: Text('No'),),
                              FlatButton(onPressed: () {
                                Provider.of<ProductProvider>(context).removeProduct(id);
                                Navigator.of(ctx).pop();
                              },
                                child: Text('Yes'),)
                            ],
                          ),
                        );
                      },
                      color: Theme.of(context).errorColor,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
