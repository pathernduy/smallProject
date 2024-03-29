import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart' show Cart;
import '../providers/orders.dart';
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = "/cart";
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Cart"),
      ),
      body: Column(children: <Widget>[
        Card(
          margin: EdgeInsets.all(15),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Row(children: <Widget>[
              Text(
                "Total: ",
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                width: 10,
              ),
              Spacer(),
              Chip(
                label: Text(
                  '\$${cart.totalAmount.toStringAsFixed(2)}',
                  style: TextStyle(
                      color:
                          Theme.of(context).primaryTextTheme.headline1?.color),
                ),
                backgroundColor: Theme.of(context).primaryColor,
              ),
              OrderButton(cart: cart)
            ]),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Expanded(
            child: ListView.builder(
          itemBuilder: ((context, index) => CartItem(
                id: cart.items.values.toList()[index].id,
                productId: cart.items.keys.toList()[index],
                price: cart.items.values.toList()[index].price,
                quantity: cart.items.values.toList()[index].quantity,
                title: cart.items.values.toList()[index].title,
              )),
          itemCount: cart.itemCount,
        ))
      ]),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: (widget.cart.totalAmount <= 0 || _isLoading)
          ? null
          : () async {
              await Provider.of<Orders>(context, listen: false).addOrder(
                  widget.cart.items.values.toList(), widget.cart.totalAmount);
              widget.cart.clear();
            },
      child: _isLoading ? CircularProgressIndicator() : Text("Order Now"),
      textColor: Theme.of(context).primaryColor,
    );
  }
}
