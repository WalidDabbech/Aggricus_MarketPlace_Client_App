import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled/services/product_services.dart';
import 'package:untitled/widgets/products/product_card_widget.dart';

class RecentlyAddedProducts extends StatelessWidget {
  final ProductServices _services = ProductServices();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: _services.products.where('published',isEqualTo: true).where('collection',isEqualTo: 'Recently Added').orderBy('productName').limitToLast(10).get(),
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 46,
                child: Padding(
                  padding: EdgeInsets.only(left: 8,top: 12.0),
                  child: Row(
                    mainAxisAlignment:MainAxisAlignment.spaceBetween ,
                    children: [
                      Text('Recently Added',style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        fontFamily: 'Tahoma',

                      ),),
                      Padding(
                        padding: const EdgeInsets.only(right:8),
                        child: InkWell(
                          onTap: (){},
                          child: Row(
                            children: [
                              Text('View All',style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.bold,fontFamily: 'Tahoma',fontSize: 16),),
                              Icon(Icons.arrow_forward_ios_rounded,color: Colors.grey[600],size: 16,)
                            ],
                          ),
                        )
                      )
                    ],
                  )
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 255,
              child: ListView(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  return ProductCard(document);
                }).toList(),
              ),
            )
          ],
        );
      },
    );
  }
}
