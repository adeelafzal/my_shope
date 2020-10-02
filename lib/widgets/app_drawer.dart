import 'package:flutter/material.dart';
import 'package:my_shope/screens/order_screen.dart';
import 'package:my_shope/screens/products_screen.dart';
import 'package:my_shope/screens/user_product_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            height: 176,
            color: Theme.of(context).primaryColor,
            child: Center(
              child: Image.asset('assets/images/my_shop.png',
              width: 120,
              color: Colors.white,),
            ),
          ),
          DrawerItemWidget(
            icon: Icons.shop,
            title: 'Shop',
            ontap: () {
              Navigator.pushReplacementNamed(context, ProductScreen.routeName);
            },
          ),
          Divider(),
          DrawerItemWidget(
            icon: Icons.payment,
            title: 'Orders',
            ontap: () {
              Navigator.pushReplacementNamed(context, OrderScreen.routeName);
            },
          ),
          Divider(),
          DrawerItemWidget(
            icon: Icons.edit,
            title: 'Manage Products',
            ontap: () {
              Navigator.pushReplacementNamed(context, UserProductScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}

class DrawerItemWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final Function ontap;

  DrawerItemWidget(
      {@required this.icon, @required this.title, @required this.ontap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: ontap,
    );
  }
}
