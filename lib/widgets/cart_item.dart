import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';

class CartItem extends StatelessWidget {

  final String id;
  final String productId;
  final String title;
  final double price;
  final int quantity;

  CartItem(this.id,this.productId, this.price, this.quantity, this.title);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: DismissDirection.endToStart,
      key: ValueKey(id),
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 30),
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete, 
          color: Colors.white,
          size: 40,
        ),
      ),

      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },

        child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            title: Text(title),
            subtitle: Text('Total ${(price * quantity)} \$'),
            leading: CircleAvatar(
              child: FittedBox(
                child:Text('$price \$'),
              ),
            ),
            trailing: Text('x$quantity'),
          ),
        ),
      ),
    );
  }
}