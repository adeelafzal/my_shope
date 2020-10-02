import 'dart:convert';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  final String id, title, desc;
  final String price;
  final String imageUrl;
  bool isFavorite;

  Products(
      {@required this.id,
      @required this.title,
      @required this.desc,
      @required this.price,
      @required this.imageUrl,
      this.isFavorite = false});

  void toggleFavoriteStatus(String token, String userId) async {
    final olStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    try {
      await http.put(
        'https://myshop-7a15c.firebaseio.com/favorite$userId/$id.json?auth=$token',
        body: json.encode(
          isFavorite,
        ),
      );
    } catch (error) {
      isFavorite = olStatus;
      notifyListeners();
    }
  }
}
