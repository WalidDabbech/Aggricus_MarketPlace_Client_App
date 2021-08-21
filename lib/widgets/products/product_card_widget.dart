import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:untitled/screens/product_details_screen.dart';
import 'package:untitled/widgets/cart/counter.dart';

class ProductCard extends StatelessWidget {
  final DocumentSnapshot document;
  const ProductCard(this.document);
  @override
  Widget build(BuildContext context) {
    final String offer = ((document['comparedPrice'] - document['price']) /
        document['comparedPrice'] * 100).toStringAsFixed(0);
    return Container(
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top:8,bottom:8,left: 10,right: 10),
          child: Stack(
            children: [
              Material(
                shadowColor: Color.fromRGBO(229, 231, 232,1),
                elevation: 5,
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  onTap: (){
                    pushNewScreenWithRouteSettings(
                      context,
                      settings: RouteSettings(name: ProductDetailsScreen.id),
                      screen: ProductDetailsScreen(document: document),
                      withNavBar: false,
                      pageTransitionAnimation: PageTransitionAnimation.cupertino,
                    );

                  },
                  child: SizedBox(
                    height: 180,
                    width: 170,
                    child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Hero(
                            tag: 'product${document['productName']}',
                            child:ClipRRect(
                              child: Image.network(
                                document['productImage'],fit: BoxFit.cover,),
                            ), )),
                    ),

                  ),
                ),
              ),
              Container(
                  decoration: BoxDecoration(
                    color : Colors.grey[600],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomRight:Radius.circular(10),
                    ),
                  ),
                  child: Padding(
                      padding: const EdgeInsets.only(top: 3,bottom: 3,left: 10,right: 10),
                      child: Text('${document['price'].toStringAsFixed(0)} DT',style: TextStyle(color: Colors.white,fontSize: 12),))),
              Positioned(
                bottom: 5,
                right: 5,
                child: InkWell(
                  onTap: (){},
                  child: Icon(CupertinoIcons.heart,size: 30,color: Colors.grey[600],),),
              )
            ],
          ),
        ),
        Text(document['brand'],style: TextStyle(fontSize: 10),),
        Text(document['productName'],style: TextStyle(fontWeight: FontWeight.bold),) ]

    )
    );
  }
}