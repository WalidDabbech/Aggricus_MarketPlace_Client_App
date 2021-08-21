import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled/widgets/favourite_card.dart';

class FavouriteScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final CollectionReference favourite = FirebaseFirestore.instance.collection('favourites');
    final User ? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
        body: NestedScrollView (
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar(
                iconTheme: IconThemeData(color: Colors.white),
                title:Text('Favourite Items',style: TextStyle(color: Colors.white,fontWeight:
                FontWeight.bold),),

              ),

            ];
          },
          body: ListView(
            padding:EdgeInsets.zero,
            shrinkWrap: true,
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: favourite.where('customerId',isEqualTo: user!.uid).snapshots(),
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

                  if (snapshot.data!.docs.isEmpty){
                    return Container();
                  }

                  return Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 45 ,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left:10),
                              child: Text('${snapshot.data!.docs.length}Items',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey[600]),),
                            ),
                          ],
                        ),
                      ),
                      ListView(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        children: snapshot.data!.docs.map((DocumentSnapshot document) {
                          return FavouriteCard(document);
                        }).toList(),
                      )
                    ],
                  );
                },
              ),
            ],
          ),
        )
    );

  }

}
