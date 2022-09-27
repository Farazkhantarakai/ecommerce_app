import 'dart:math';
import 'package:flutter/material.dart';
import '../Provider/order.dart' as ordItem;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OrderItem extends StatefulWidget {
  const OrderItem({Key? key, this.ord}) : super(key: key);

  final ordItem.OrderItem? ord;

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var show = false;

//we cannot set it up as asyn and await therefore we use future.delayed function

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('${widget.ord!.amount}'),
            subtitle: Text(
                DateFormat('dd/MM/yyyy hh:ss').format(widget.ord!.dateTime)),
            trailing: IconButton(
                onPressed: () {
                  setState(() {
                    show = !show;
                  });
                },
                icon: show
                    ? const Icon(Icons.expand_less)
                    : const Icon(Icons.expand_more)),
          ),
          if (show)
            Container(
                height: min(widget.ord!.products.length * 10 + 100,
                    180), //Be Remember how to add such kind of functionality
                child: ListView(
                  children: widget.ord!.products
                      .map((e) => Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  e.title,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  e.price.toString(),
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal),
                                )
                              ],
                            ),
                          ))
                      .toList(),
                ))
        ],
      ),
    );
  }
}
