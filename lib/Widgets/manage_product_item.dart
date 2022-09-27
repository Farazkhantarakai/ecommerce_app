import 'package:flutter/material.dart';
import '../Screens/edit_product_screen.dart';
import 'package:provider/provider.dart';
import '../Provider/Products.dart';

class ManageProductItem extends StatelessWidget {
  const ManageProductItem({Key? key, this.id, this.imageUrl, this.title})
      : super(key: key);
  final String? id;
  final String? imageUrl;
  final String? title;

  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    return ListTile(
      leading: Container(
        constraints: const BoxConstraints(maxWidth: 100),
        child: Image.asset(imageUrl!),
      ),
      title: Text(
        title!,
        style: const TextStyle(fontSize: 20, color: Colors.black),
      ),
      trailing: Container(
        constraints: const BoxConstraints(maxWidth: 100),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditedProductScreen.routName, arguments: id);
              },
              icon: const Icon(Icons.edit),
              color: Colors.purple,
            ),
            IconButton(
              onPressed: () async {
                try {
                  await Provider.of<Products>(context, listen: false)
                      .deleteProduct(id.toString());
                } catch (error) {
                  scaffold.showSnackBar(
                      const SnackBar(content: Text('Deleting Failed')));
                }
              },
              icon: const Icon(Icons.delete),
              color: Colors.red,
            )
          ],
        ),
      ),
    );
  }
}
