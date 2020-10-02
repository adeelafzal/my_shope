import 'package:flutter/material.dart';
import 'package:my_shope/models/product_provider.dart';
import 'package:provider/provider.dart';

class Productdetail extends StatelessWidget {
  static const routeName = 'Productdetail';

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context).settings.arguments as Map<String, String>;
    final leadProduct =
        Provider.of<ProductProvider>(context).findById(routeArgs['id']);
    return Scaffold(
      appBar: AppBar(
        title: Text(leadProduct.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 350,
              width: double.infinity,
              child: Image.network(
                leadProduct.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 10,),
            Text('Rs.${leadProduct.price}/-',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey
            ),),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(leadProduct.desc,
              textAlign: TextAlign.center,
              softWrap: true,),
            ),
          ],
        ),
      ),
    );
  }
}
