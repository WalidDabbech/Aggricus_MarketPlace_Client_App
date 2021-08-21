
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class CouponProvider with ChangeNotifier {
  bool expired = false;
  DocumentSnapshot ? document;
  int discountRate = 0 ;
  getCouponDetails (title , sellerId)
  async {
    final DocumentSnapshot document =
    await FirebaseFirestore.instance.collection('coupons').doc(title).get();
    if (document.exists){
      this.document = document;
      notifyListeners();
      if (document['sellerId']==sellerId){
        checkExpiry(document);
      }
    } else {
      this.document=null;
      notifyListeners();
    }
  }

  checkExpiry(DocumentSnapshot document){

    final DateTime date = document['expiry'].toDate();
    final dateDiff = date.difference(DateTime.now()).inDays;
    if (dateDiff<0) {
      expired = true;
      notifyListeners();
    }
    else {
        this.document = document;
        expired = false;
        discountRate = document['discountRate'];
        notifyListeners();

    }
  }
}