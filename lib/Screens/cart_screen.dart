import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider/order.dart';
import '../Provider/cart.dart';
import '../Widgets/cart_item.dart' as ct;

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  static const routName = '/CartScreen';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartItem>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Card(
              margin: const EdgeInsets.all(5),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    const Spacer(),
                    Chip(
                      label: Text(
                        '\$${cart.total}',
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.purpleAccent,
                    ),
                    orderButton(cart: cart)
                  ],
                ),
              ),
            ),
            Expanded(
                child: ListView.builder(
                    itemCount: cart.items.length,
                    itemBuilder: (ctx, index) => ct.CartItem(
                          //we will convert it like this
                          id: cart.cartItem.values.toList()[index].id,
                          productId: cart.cartItem.keys.toList()[index],
                          titleName: cart.cartItem.values.toList()[index].title,
                          price: cart.cartItem.values.toList()[index].price,
                          quantity:
                              cart.cartItem.values.toList()[index].quantity,
                        )))
          ],
        ),
      ),
    );
  }
}

class orderButton extends StatefulWidget {
  const orderButton({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final CartItem cart;

  @override
  State<orderButton> createState() => _orderButtonState();
}

class _orderButtonState extends State<orderButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: widget.cart.total <= 0
            ? null
            : () async {
                setState(() {
                  _isLoading = true;
                });
                await Provider.of<Orders>(context, listen: false).addOrder(
                    widget.cart.cartItem.values.toList(), widget.cart.total);
                setState(() {
                  _isLoading = false;
                });
                widget.cart.clear();
              },
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : const Text('Order Now'));
  }
}
