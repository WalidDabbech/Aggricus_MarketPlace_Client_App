import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class SaveForLater extends StatefulWidget {

final DocumentSnapshot? document;
const SaveForLater(this.document);

  @override
  State<SaveForLater> createState() => _SaveForLaterState();
}

class _SaveForLaterState extends State<SaveForLater> {
  @override
  Widget build(BuildContext context) {
    final User ? user = FirebaseAuth.instance.currentUser;
    bool _fav = true ;

    FirebaseFirestore.instance
        .collection('favourites').doc(widget.document!.id).collection('product')
        .where('productId',isEqualTo: widget.document!['productId']).where('customerId',isEqualTo:user!.uid)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if(doc['productId']==widget.document!['productId']){
          setState(() {
            _fav = false;
          });
        }
      });
    });
    return _fav ? InkWell(
      onTap: (){
        EasyLoading.show(
            status: 'Saving...'
        );
        saveForLater().then((value){
          EasyLoading.showSuccess(
              'Saved successfully'
          );
        });
      },
      child: Container(
        height: 56,
        color: Colors.grey[800],
        child: Center(
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min ,
                children: [
                  Icon(CupertinoIcons.bookmark,color: Colors.white,),
                  SizedBox(width: 10,),
                  Text('Save for later',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                  ),
                ],
              )
          ),
        ),
      ),
    ):Container();
  }

  Future <void> saveForLater() {
    final CollectionReference _favourite = FirebaseFirestore.instance.collection('favourites');
    final User ? user = FirebaseAuth.instance.currentUser;
    return _favourite.add(
        {
          'product':widget.document!.data(),
          'customerId': user!.uid
        }
    );
  }
}
