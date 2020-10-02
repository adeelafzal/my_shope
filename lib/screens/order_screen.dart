import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:my_shope/models/orders.dart';
import 'package:my_shope/widgets/app_drawer.dart';
import 'package:my_shope/widgets/order_item.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatefulWidget {
  static const routeName = 'OrderScreen';

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  var isLoading = false;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) async {
      setState(() {
        isLoading = true;
      });
      await Provider.of<Orders>(context,listen: false).fetchAndSetOrders();
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final order = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: isLoading ? SpinKitFadingCircle(
        color: Theme.of(context).accentColor,
        size: 50.0,
      ) : ListView.builder(
        itemCount: order.ordsers.length,
        itemBuilder: (context, index) {
          return MyOrderitem(order.ordsers[index]);
        },
      ),
    );
  }
}
