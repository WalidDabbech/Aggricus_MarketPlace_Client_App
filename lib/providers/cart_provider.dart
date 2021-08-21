

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:untitled/services/cart_services.dart';

class CartProvider with ChangeNotifier{
  final CartServices _cart = CartServices();
  double subTotal=0.0;
  int cartQty = 0;
  QuerySnapshot ? snapshot;
  DocumentSnapshot ? document;
  double saving = 0.0;
  double distance =0.0;
  bool cod = false;
  List cartList = [];
  Future <double ? > getCardTotal()async{
    var cartTotal = 0.0;
    var saving =0.0;
    final List _newList = [];
     final QuerySnapshot  snapshot = await _cart.cart.doc(_cart.user!.uid).collection('products').get();
      if (snapshot.size == 0){
        cartQty = 0;
        return null;
      }
      snapshot.docs.forEach((doc) {
        if(!_newList.contains(doc.data())){
          _newList.add(doc.data());
          cartList = _newList;
          notifyListeners();
        }
        cartTotal = cartTotal+doc['total'];
        saving = saving + ((doc['comparedPrice']-doc['price']) > 0 ? doc['comparedPrice']-doc['price'] : 0 );
      });
      subTotal = cartTotal;
      cartQty = snapshot.size;
      this.snapshot = snapshot;
      this.saving = saving;
      notifyListeners();

      return cartTotal;
  }
    getDistance(distance){
      this.distance=distance;
      notifyListeners();
    }

    getPaymentMethod(index){
      if (index == 0 ) {
        cod = false;
        notifyListeners();

      }
      else {
        cod = true ;
        notifyListeners();

      }
    }

  getShopName()async {
    final DocumentSnapshot doc = await _cart.cart.doc(_cart.user!.uid).get();
    if (doc.exists){
      document = doc ;
      notifyListeners();
    }
    else {
      document = null;
      notifyListeners();
    }
  }

}