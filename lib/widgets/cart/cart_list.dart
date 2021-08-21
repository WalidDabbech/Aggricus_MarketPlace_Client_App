import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:untitled/services/cart_services.dart';
import 'package:untitled/widgets/cart/cart_card.dart';

class CartList extends StatefulWidget {

  final DocumentSnapshot ?  document;
  const CartList({this.document});


  @override
  _CartListState createState() => _CartListState();
}

class _CartListState extends State<CartList> {

  final CartServices _cart = CartServices();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _cart.cart.doc(_cart.user!.uid).collection('products').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
            ),
          );
        }

        return ListView(
          physics: ScrollPhysics(),
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            return CartCard(document: document,);
          }).toList(),
        );
      },
    );
  }
}
