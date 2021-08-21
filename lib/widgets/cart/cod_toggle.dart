import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toggle_bar/toggle_bar.dart';
import 'package:untitled/providers/cart_provider.dart';

class CodToggleSwitch extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final _cart = Provider.of<CartProvider>(context);
    return Container(
      color: Colors.white,
      child: ToggleBar(
        backgroundColor: Colors.grey[300],
         textColor: Colors.grey[600],
          selectedTabColor: Theme.of(context).primaryColor,
          labels: ["Pay Online", "Cash on delivery"],
          onSelectionUpdated: (index) {
            _cart.getPaymentMethod(index);
          }
      ),
    );
  }
}
