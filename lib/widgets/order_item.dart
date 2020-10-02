import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_shope/models/orders.dart';

class MyOrderitem extends StatefulWidget {
  final OrderItem order;

  MyOrderitem(this.order);

  @override
  _MyOrderitemState createState() => _MyOrderitemState();
}

class _MyOrderitemState extends State<MyOrderitem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(
              'Rs. ${widget.order.amount}/-',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              widget.order.dateTime,
            ),
            trailing: IconButton(
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
            ),
          ),
          if (_expanded)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              height: min(widget.order.products.length * 20.0 + 10, 180),
              child: ListView(
                children: widget.order.products
                    .map((prod) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              prod.title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${prod.quantity}x Rs. ${prod.price}/-',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ))
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }
}
