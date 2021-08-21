import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/providers/store_provider.dart';
import 'package:untitled/services/product_services.dart';
import 'package:untitled/widgets/products/product_card_widget.dart';

class ProductListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ProductServices _services = ProductServices();
    final _store = Provider.of<StoreProvider>(context);
    return FutureBuilder<QuerySnapshot>(
      future: _services.products.where('published',isEqualTo: true).where('category.mainCategory',isEqualTo:_store.category).get(),
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

        return Container(
          child: Column(
            children: [
              Container(height: 50,
              color: Colors.grey,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8,right: 8),
                  child: ListView(
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.horizontal,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left:6,right: 2),
                        child: Chip(
                          backgroundColor: Colors.white,
                          shape:RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4)
                          ),
                          label:Text('Sub Category'),),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left:6,right: 2),
                        child: Chip(
                          backgroundColor: Colors.white,
                          shape:RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4)
                          ),
                          label:Text('Sub Category'),),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left:6,right: 2),
                        child: Chip(
                          backgroundColor: Colors.white,
                          shape:RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4)
                          ),
                          label:Text('Sub Category'),),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left:6,right: 2),
                        child: Chip(
                          backgroundColor: Colors.white,
                          shape:RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4)
                          ),
                          label:Text('Sub Category'),),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left:6,right: 2),
                        child: Chip(
                          backgroundColor: Colors.white,
                          shape:RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4)
                          ),
                          label:Text('Sub Category'),),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left:6,right: 2),
                        child: Chip(
                          backgroundColor: Colors.white,
                          shape:RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4)
                          ),
                          label:Text('Sub Category'),),
                      ),
                    ],
                  ),
                ),
              ),
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
              Container(
                height: 200,
                width: MediaQuery.of(context).size.width,
                child: Wrap(
                  children: snapshot.data!.docs.map((DocumentSnapshot document) {
                    return ProductCard(document);
                  }).toList(),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
