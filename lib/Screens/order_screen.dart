import 'package:flutter/material.dart';
import 'package:shop_app/Widgets/maindrawer.dart';
import '../Widgets/order_item.dart';
import '../Provider/order.dart' as ord;
import 'package:provider/provider.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  static const routName = 'OrderScreen';

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  bool _isInit = true;
  bool _isLoading = false;
  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      Provider.of<ord.Orders>(context, listen: false)
          .fecthOrderedData()
          .then((value) {
        setState(() {
          _isLoading = false;
        });
      });
    }

    _isInit = false;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<ord.Orders>(context);

    return Scaffold(
      drawer: const MainDrawer(),
      appBar: AppBar(
        title: const Text('Order Screen'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: orderData.order.length,
              itemBuilder: (ctx, i) => OrderItem(
                    ord: orderData.order[i],
                  )),
    );
  }
}
