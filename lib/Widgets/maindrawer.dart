import 'package:flutter/material.dart';
import '../Screens/manage_product_screen.dart';
import 'package:shop_app/Screens/order_screen.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: Column(
          children: [
            AppBar(
              title: const Text('Hello Friends'),
              automaticallyImplyLeading: false,
            ),
            const Divider(),
            Card(
              child: ListTile(
                leading: const Icon(Icons.shop),
                title: const Text('Shop'),
                onTap: () {
                  Navigator.of(context).pushReplacementNamed('/');
                },
              ),
            ),
            const Divider(),
            Card(
              child: ListTile(
                leading: const Icon(Icons.payment),
                title: const Text('Order'),
                onTap: () {
                  Navigator.of(context)
                      .pushReplacementNamed(OrderScreen.routName);
                },
              ),
            ),
            const Divider(),
            Card(
              child: ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Manage Products'),
                onTap: () {
                  Navigator.of(context)
                      .pushReplacementNamed(ManageProductScreen.routName);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
