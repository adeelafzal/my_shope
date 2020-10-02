import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_shope/models/cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final String amount;
  final List<CartItem> products;
  final String dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _ordsers = [];

  final String autToken;

  Orders(this.autToken,this._ordsers);

  List<OrderItem> get ordsers {
    return [..._ordsers];
  }

  Future<void> fetchAndSetOrders() async {
    final url = 'https://myshop-7a15c.firebaseio.com/orders.json?auth=$autToken';
    try {
      final response = await http.get(url);
      final extractData = json.decode(response.body) as Map<String, dynamic>;
      if(extractData==null){
        return;
      }
      final List<OrderItem> loadedProduct = [];
      extractData.forEach((proId, proData) {
        loadedProduct.add(OrderItem(
          dateTime: proData['dateTime'],
          id: proId.toString(),
          amount: proData['amount'],
          products: (proData['products'] as List<dynamic>)
              .map((e) => CartItem(
                    e['id'],
                    e['title'],
                    e['quantity'],
                    e['price'],
                  ))
              .toList(),
        ));
        _ordsers = loadedProduct;
        notifyListeners();
      });
    } catch (error) {
      throw error;
    }
  }

  Future<void> addOrder(List<CartItem> products, String total) async {
    final url = 'https://myshop-7a15c.firebaseio.com/orders.json?auth=$autToken';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'amount': total.toString(),
          'dateTime': DateFormat('dd-MM-yyyy hh:mm a').format(DateTime.now()).toString(),
          'products': products
              .map((e) => {
                    'title': e.title,
                    'id': DateTime.now().toString(),
                    'quantity': e.quantity,
                    'price': e.price,
                  })
              .toList()
        }),
      );
      _ordsers.insert(
        0,
        OrderItem(
          products: products,
          amount: total,
          dateTime: DateFormat('dd-MM-yyyy hh:mm a').format(DateTime.now()).toString(),
          id: json.decode(response.body)['name'],
        ),
      );
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
