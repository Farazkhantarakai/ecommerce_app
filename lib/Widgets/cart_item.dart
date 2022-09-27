import 'package:flutter/material.dart';
import '../Provider/cart.dart' as ct;
import 'package:provider/provider.dart';

class CartItem extends StatelessWidget {
  const CartItem(
      {Key? key,
      required this.id,
      required this.productId,
      required this.titleName,
      required this.price,
      required this.quantity})
      : super(key: key);
  final String id;
  final String productId;
  final String titleName;
  final double price;
  final int quantity;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: const Text('Are your sure '),
                actions: [
                  TextButton(
                      onPressed: () {
                        Provider.of<ct.CartItem>(context, listen: false)
                            .removeItem(productId);
                        Navigator.pop(context);
                      },
                      child: const Text('Yes')),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: const Text('No'))
                ],
              );
            });
      },
      direction: DismissDirection.endToStart,
      key: ValueKey(id),
      background: Container(
        color: Colors.redAccent,
        child: const Icon(Icons.delete),
      ),
      onDismissed: (value) {
        Provider.of<ct.CartItem>(context, listen: false).removeItem(productId);
      },
      child: Card(
        margin: const EdgeInsets.all(5),
        child: ListTile(
          leading: CircleAvatar(
              radius: 20,
              child: Text(
                price.toString(),
                style:
                    const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              )),
          title: Text(
            titleName.toString(),
            style: const TextStyle(fontSize: 20),
          ),
          subtitle: Text('${price * quantity}'),
          trailing: Text(
            '$quantity x',
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}
