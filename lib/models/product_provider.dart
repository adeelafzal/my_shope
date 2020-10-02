import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_shope/models/products.dart';
import 'package:http/http.dart' as http;

class ProductProvider with ChangeNotifier {
  final String authToken, userId;

  ProductProvider(this.authToken, this._items, this.userId);

  List<Products> _items = [
//    Products(
//      id: 'p1',
//      title: 'Dazzle',
//      desc:
//          'Dazzle is a meld of rich woody tones a hint of sandalwood intertwined with the freshness of patchouli to be the ideal evening fragrance Dazzle is a meld of rich woody tones a hint of sandalwood intertwined with the freshness of patchouli to be the ideal evening fragrance Dazzle is a meld of rich woody tones a hint of sandalwood intertwined with the freshness of patchouli to be the ideal evening fragrance',
//      price: 2990.0,
//      imageUrl:
//          'https://pk.khaadi.com/media/catalog/product/a/p/apf19204_default_1.jpg?width=600&height=900&canvas=600:900&quality=80&bg-color=255,255,255&fit=bounds',
//    ),
//    Products(
//        id: 'p2',
//        title: 'Clutch',
//        desc: 'Box Clutch Bags',
//        price: 199.0,
//        imageUrl:
//            'https://pk.khaadi.com/media/catalog/product/a/c/aclt20202_black_1.jpg?width=600&height=900&canvas=600:900&quality=80&bg-color=255,255,255&fit=bounds'),
//    Products(
//        id: 'p3',
//        title: 'Handbag',
//        desc: 'Tote Handbag Bags',
//        price: 269.0,
//        imageUrl:
//            'https://pk.khaadi.com/media/catalog/product/a/h/ahb20203_mustard_1_1.jpg?width=600&height=900&canvas=600:900&quality=80&bg-color=255,255,255&fit=bounds'),
//    Products(
//        id: 'p4',
//        title: 'Kurta Dupatta Shalwar',
//        desc: 'SCHIFFLI CC 3 PC',
//        price: 6990.99,
//        imageUrl:
//            'https://pk.khaadi.com/media/catalog/product/c/c/cc20204_green_1.jpg?width=900&height=1350&canvas=900:1350&quality=80&bg-color=255,255,255&fit=bounds'),
//    Products(
//        id: 'p5',
//        title: 'Shirt Shalwar',
//        desc: 'Brosha Embroidered Shirt 3.25m Shalwar 2.5 m',
//        price: 3990.9,
//        imageUrl:
//            'https://pk.khaadi.com/media/catalog/product/b/i/bi20203_blue_1_5.jpg?width=600&height=900&canvas=600:900&quality=80&bg-color=255,255,255&fit=bounds'),
//    Products(
//        id: 'p6',
//        title: 'Shirt Shalwar',
//        desc: 'Lawn Printed Shirt 3.0 m Shalwar 2.5',
//        price: 1990.9,
//        imageUrl:
//            'https://pk.khaadi.com/media/catalog/product/j/2/j20207_red_1_5.jpg?width=600&height=900&canvas=600:900&quality=80&bg-color=255,255,255&fit=bounds'),
//    Products(
//        id: 'p7',
//        title: 'Waistcoat',
//        desc: 'Jacquard Waistcoat',
//        price: 235.9,
//        imageUrl:
//            'https://pk.khaadi.com/media/catalog/product/b/w/bwce20102_grey_1.jpg?width=600&height=900&canvas=600:900&quality=80&bg-color=255,255,255&fit=bounds'),
//    Products(
//        id: 'p8',
//        title: 'Unstitched',
//        desc:
//            'The real summer perfection lies in soft lawn fabrics and beautiful prints that can be tailored as per your unique style.',
//        price: 1500.0,
//        imageUrl:
//            'https://pk.khaadi.com/media/promobanners//u/n/unstitchedcategoryimage04082020.jpg'),
//    Products(
//        id: 'p9',
//        title: 'Kurta Dupatta Shalwar',
//        desc: 'CHIFFON',
//        price: 1450.9,
//        imageUrl:
//            'https://pk.khaadi.com/media/catalog/product/l/c/lcp20101_black_1_3.jpg?width=900&height=1350&canvas=900:1350&quality=80&bg-color=255,255,255&fit=bounds'),
//    Products(
//        id: 'p10',
//        title: 'Elegant green 2 piece unstitched embroidered',
//        desc:
//            'Elegant green 2 piece unstitched embroidered  pret dress by Nishat Linen collection vol.1 2018',
//        price: 2390.9,
//        imageUrl:
//            'https://pakistanpretwear.com/wp-content/uploads/2018/03/Elegant-green-2-piece-unstitched-embroidered-pret-dress-by-Nishat-Linen-collection-vol.1-2018-758x1137.jpeg'),
//    Products(
//        id: 'p11',
//        title: 'PS20-169 Dyed Stitched Denim Shirt - 1PC',
//        desc:
//            'Contemporary blue dyed stitched denim shirt from latest one piece ready to wear Eid ul Azha collection 2020 by Nishat Linen.',
//        price: 3200.9,
//        imageUrl:
//            'https://nishatlinen.com/media/wysiwyg/PretWebBanner17082020.jpg'),
  ];

  List<Products> get items {
    return [..._items.reversed];
  }

  List<Products> get favoriteList {
    return _items.where((element) => element.isFavorite).toList();
  }

  int get taskCount {
    return _items.length;
  }

  int get favCount {
    return favoriteList.length;
  }

  Products findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="creatorid"&equalTo="$userId"' : '';
    var url =
        'https://myshop-7a15c.firebaseio.com/products.json?auth=$authToken&$filterString';
    try {
      final response = await http.get(url);
      final extractData = json.decode(response.body) as Map<String, dynamic>;
      if (extractData == null) {
        return;
      }
      url =
          'https://myshop-7a15c.firebaseio.com/favorite$userId.json?auth=$authToken';
      final favResponse = await http.get(url);
      final favData = json.decode(favResponse.body);
      final List<Products> loadedProduct = [];
      extractData.forEach((proId, proData) {
        loadedProduct.add(Products(
          price: proData['price'],
          desc: proData['desc'],
          id: proId,
          title: proData['title'],
          imageUrl: proData['imageUrl'],
          isFavorite: favData == null ? false : favData[proId] ?? false,
        ));
        _items = loadedProduct;
        notifyListeners();
      });
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProducts(Products product) async {
    final url =
        'https://myshop-7a15c.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'desc': product.desc,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'creatorid': userId,
        }),
      );
      final newProduct = Products(
        price: product.price,
        desc: product.desc,
        title: product.title,
        imageUrl: product.imageUrl,
        id: json.decode(response.body)['name'],
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProduct(String id, Products newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url =
          'https://myshop-7a15c.firebaseio.com/products/$id.json?auth=$authToken';
      try {
        await http.patch(
          url,
          body: json.encode({
            'title': newProduct.title,
            'desc': newProduct.desc,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
          }),
        );
        _items[prodIndex] = newProduct;
        notifyListeners();
      } catch (error) {
        throw error;
      }
    }
  }

  void removeProduct(String id) {
    final url =
        'https://myshop-7a15c.firebaseio.com/products/$id.json?auth=$authToken';
    final existingProductIndex =
        _items.indexWhere((element) => element.id == id);
    var existingProduct = _items[existingProductIndex];
    http.delete(url).then((value) => existingProduct = null).catchError((_) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
    });
    _items.removeAt(existingProductIndex);
    notifyListeners();
  }
}
