import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:untitled/services/product_services.dart';
import 'package:untitled/widgets/products/product_card_widget.dart';

class BestSellingProduct extends StatelessWidget {
  final ProductServices _services = ProductServices();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: _services.products.where('published',isEqualTo: true).where('collection',isEqualTo: 'Best Selling').orderBy('productName').limitToLast(10).get(),
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
                  padding: const EdgeInsets.only(left:8.0,top: 12.0),
                  child: Text('Best Selling',style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontFamily: 'Tahoma',
                      fontWeight: FontWeight.bold
                  ),),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 255,
              child: ListView(
                scrollDirection: Axis.horizontal,
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
