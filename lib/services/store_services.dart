
import 'package:cloud_firestore/cloud_firestore.dart';

class StoreServices{

  CollectionReference vendors = FirebaseFirestore.instance.collection('vendors');

  getTopPickedStore(){
    return vendors.where('accVerified',isEqualTo: true).where('isTopPicked',isEqualTo: true).where('shopOpen',isEqualTo: true).orderBy('shopName').snapshots();
    
  }
  getNearByStore(){
    return vendors.where('accVerified',isEqualTo: true).orderBy('shopName').snapshots();

  }

  getNearByStorePagination(){
    return vendors.where('accVerified',isEqualTo: true).orderBy('shopName');


  }

  Future<DocumentSnapshot>getShopDetails(sellerUid)async{
    final DocumentSnapshot snapshot = await vendors.doc(sellerUid).get();
    return snapshot;
  }
  
  
}