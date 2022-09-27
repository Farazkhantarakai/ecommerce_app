import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider/Product.dart';
import '../Screens/product_description.dart';
// import 'dart:developer';
import '../Provider/cart.dart';

class ProductItem extends StatelessWidget {
  // const ProductItem({Key? key, this.id, this.title, this.imageUrl})
  //     : super(key: key);
  // final String? id;
  // final String? title;
  // final String? imageUrl;
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<CartItem>(context, listen: false);
    return Scaffold(
        body: GridTile(
      footer: GridTileBar(
          backgroundColor: Colors.black54,
          leading: Consumer<Product>(
            builder: (context, value, child) => IconButton(
                onPressed: () async {
                  // await Provider.of<Product>(context, listen: false)
                  //     .updateFavorite();
                  product.updateFavorite();
                },
                icon: product.isFavorite
                    ? const Icon(Icons.favorite)
                    : const Icon(Icons.favorite_outline)),
          ),
          title: FittedBox(child: Text(product.title)),
          trailing: IconButton(
              onPressed: () {
                cart.addItem(product.id!, product.title, product.prices);
                //the scaffoldMessenger.of(context) will hide the snackbar
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                SnackBar snackbar = SnackBar(
                    action: SnackBarAction(
                        label: 'Undo',
                        onPressed: () {
                          cart.removeItem(product.id!);
                        }),
                    backgroundColor: Colors.greenAccent,
                    duration: const Duration(seconds: 2),
                    content: const Text('Product added to the cart'));
                ScaffoldMessenger.of(context).showSnackBar(snackbar);
                // log('i am at the last ');
              },
              icon: const Icon(Icons.shopping_cart))),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context)
              .pushNamed(ProductDescription.routName, arguments: product.id);
        },
        child: Image.asset(
          product.imageUrl,
          fit: BoxFit.cover,
        ),
      ),
    ));
  }
}



// in provider package  we create a separate logic building class while implementing
// utility method ChangeNotifier class product with ChangeNotifier
// {
// now here you need to implement your logic while calling a method to change the 
// the state at the end of every function
// }
// at the top app level we wrap ChangeNotifierProvider(
// create:(ctx) => Product();
// )
// now if some where in the app need data then we listen there 
//var provide= Provider.of<Product>(context,listen:false); we can also set listen to false
// but it build our widget every time for the whole tree


