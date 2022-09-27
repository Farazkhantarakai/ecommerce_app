import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_app/Provider/Products.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String? id;
  final String title;
  final String description;
  final double prices;
  final String imageUrl;
  bool isFavorite;
  Product(
      {this.id,
      required this.title,
      required this.description,
      required this.prices,
      required this.imageUrl,
      this.isFavorite = false});

  // toggleFavorite() {
  //   //if it is true it will become false and if it is false it will become true
  //   isFavorite = !isFavorite;
  //   notifyListeners();
  // }

  get favoriteItem {
    return Products('', [])
        .item
        .where((product) => product.isFavorite == isFavorite);
  }

  Future<void> updateFavorite() async {
    final oldFavorite = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    String url =
        'https://myproject-fc918-default-rtdb.firebaseio.com/products/$id.json';
    try {
      var response = await http.patch(Uri.parse(url),
          body: jsonEncode({
            'favorite': isFavorite,
          }));

      if (response.statusCode >= 400) {
        isFavorite = oldFavorite;
        notifyListeners();
      }
    } catch (error) {
      isFavorite = oldFavorite;
      notifyListeners();
      throw error;
    }
  }
}

//get it fetch items from the server 
//post it put data on server 
// patch it update data on a server 