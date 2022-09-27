import 'package:flutter/material.dart';
import 'package:shop_app/Models/http_exceptions.dart';
import 'package:shop_app/Provider/auth.dart';
import 'Product.dart';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Products with ChangeNotifier {
  var _loadedProduct = [
    Product(
        id: 'P1',
        title: 'Hoodie',
        description: 'this product is delivered only for the rest of the api ',
        prices: 241.0,
        imageUrl: 'assets/1.jpg'),
    Product(
        id: 'P2',
        title: 'Kentucky Choop',
        description: 'this is a product of liza',
        prices: 345.0,
        imageUrl: 'assets/2.jpg'),
    Product(
        id: 'P3',
        title: 'Burjan',
        description: 'this is a product of burjan ',
        prices: 341.0,
        imageUrl: 'assets/3.jpg'),
    Product(
        id: 'P4',
        title: 'Pasha',
        description: 'this is a verified product of pasha',
        prices: 300.0,
        imageUrl: 'assets/4.jpg'),
    Product(
        id: 'P5',
        title: 'R Sheen',
        description: 'this is a verified product of Rshen',
        prices: 343.0,
        imageUrl: 'assets/1.jpg'),
  ];
  final String authToken;

  Products(this.authToken, this._loadedProduct);

  var showFavoriteOnly = false;

// _loadedProduct
  List<Product> get item {
    if (showFavoriteOnly) {
      return _loadedProduct.where((element) => element.isFavorite).toList();
    }

    return [..._loadedProduct];
  }

  showFavorite() {
    showFavoriteOnly = true;
    notifyListeners();
  }

  showAll() {
    showFavoriteOnly = false;
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
//there are four operation of http that we can perform
//there is a great difference between get -> fectch data ,post -> send data
//patch ->  update data  , put -> replace data, delete -> delete data

    String url =
        'https://myproject-fc918-default-rtdb.firebaseio.com/products.json';
    try {
      final response = await http.post(Uri.parse(url),
          body: jsonEncode({
            'title': product.title,
            'price': product.prices,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'favorite': product.isFavorite,
          }));

      final newProduct = Product(
          id: jsonDecode(response.body)['name'],
          title: product.title,
          description: product.description,
          prices: double.parse(product.prices.toString()),
          imageUrl: product.imageUrl);
      _loadedProduct.add(newProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product product) async {
    //indexWhere will search the index of the given id and if matches
    //it will return that particular object
    var prodId = _loadedProduct.indexWhere((element) => element.id == id);
    if (prodId >= 0) {
      //final variable will constant at run
      //const variable will be contstant at compile time
      final url =
          'https://myproject-fc918-default-rtdb.firebaseio.com/products/$id.json';

      try {
        await http.patch(Uri.parse(url),
            body: jsonEncode({
              'title': product.title,
              'price': product.prices,
              'description': product.description,
              'imageUrl': product.imageUrl,
              'favorite': product.isFavorite,
              'id': product.id
            }));
      } catch (error) {
        throw error;
      }

      _loadedProduct[prodId] = product;
      notifyListeners();
    } else {
      print('..');
    }
  }

  Future<void> fetchData() async {
    final url =
        'https://myproject-fc918-default-rtdb.firebaseio.com/products.json?auth=$authToken';
    try {
      var response = await http.get(Uri.parse(url));
      //Be remember specifying types of each data or object is compulsory
      var result = jsonDecode(response.body) as Map<String, dynamic>;
      print(jsonDecode(result.toString()));
      final List<Product> newProduct = [];
      result.forEach((productId, data) {
        newProduct.add(Product(
            id: productId,
            title: data['title'],
            description: data['description'],
            prices: data['price'],
            imageUrl: data['imageUrl'],
            isFavorite: data['favorite']));
      });
      _loadedProduct = newProduct;
      notifyListeners();
    } catch (error) {
      rethrow;
    }

    // result.forEach((key,value) {

    // });
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://myproject-fc918-default-rtdb.firebaseio.com/products/$id.json';

    var existingProdIndex =
        _loadedProduct.indexWhere((productId) => productId == id);
    Product? existingProduct = _loadedProduct[existingProdIndex];
    _loadedProduct.removeAt(existingProdIndex);
    final response = await http.delete(Uri.parse(url));

    if (response.statusCode >= 400) {
      _loadedProduct.insert(existingProdIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete the product');
    }
    existingProduct = null;
    // _loadedProduct.removeWhere((element) => element.id == id);
    notifyListeners();
  }
}
