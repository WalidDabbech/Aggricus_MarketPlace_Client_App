import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:untitled/widgets/products/bottom_sheet_container.dart';

class ProductDetailsScreen extends StatelessWidget {
static const String id ='product-details-screen';
final DocumentSnapshot ? document;
const ProductDetailsScreen({this.document});
  @override
  Widget build(BuildContext context) {
    final offer = ((document!['comparedPrice']-document!['price'])/
        document!['comparedPrice'])*100;
    return Scaffold(
      appBar:AppBar(
        iconTheme:  IconThemeData(color: Colors.white),
        actions: [
          IconButton(icon : Icon(CupertinoIcons.search),onPressed:(){},),
        ],
      ),
      bottomSheet:BottomSheetContainer(document),
      body: Container(
        color: Color.fromRGBO(243, 244, 253,1),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.3),
                        border: Border.all(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8,right: 8,bottom: 2,top: 2),
                        child: Text(document!['brand']),
                      ),
                    ),
                  ],
                ),
              SizedBox(height: 10,),
              Text(document!['productName'],style: TextStyle(fontSize: 22),),
              SizedBox(height: 10,),
              Text(document!['weight'],style: TextStyle(fontSize: 20),),
              SizedBox(height: 10,),
              Row(
                children: [
                  Text('${document!['price'].toStringAsFixed(0)} DT',
                  style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                  SizedBox(width: 10,),
                  if(offer>0)
                    Text('${document!['comparedPrice'].toStringAsFixed(0)} DT',
                    style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,decoration: TextDecoration.lineThrough),),
                  SizedBox(width: 10,),
                  if(offer>0)
                  Container(
                    decoration: BoxDecoration(
                      color:Colors.redAccent,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8,right: 8,bottom: 3,top: 3),
                      child: Text('${offer.toStringAsFixed(0)}% OFF',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 12)),
                    ),
                  )
                ],
              ),
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Hero(
                    tag: 'product${document!['productName']}',
                  child: Image.network(
                     document!['productImage'],
                  ),),
              ),
              Divider(color: Colors.grey[300],thickness: 6,),
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8,top: 8),
                  child: Text('About this product',style: TextStyle(fontSize: 20),),
                ),
              ),
              Divider(color: Colors.grey[400]),
              Padding(
                padding: const EdgeInsets.only(bottom: 8,top: 8,left: 10,right: 10),
                child: ExpandableText(
                    document!['description'],
                  expandText: 'View more',
                  collapseText: 'View less',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              Divider(color: Colors.grey[400]),
              Container(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8,top: 8),
                  child: Text('Other product info',style: TextStyle(fontSize: 20),),
                ),
              ),
              Divider(color: Colors.grey[400]),
              Padding(
                padding: const EdgeInsets.only(left: 10,right: 10,top: 8,bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('SKU :' '${document!['sku']}',
                    style: TextStyle(color: Colors.grey),),
                    Text('Seller :' '${document!['seller']['shopName']}',
                      style: TextStyle(color: Colors.grey),),
                  ],
                ),
              ),
              SizedBox(height: 60,)
            ],
          ),
        ),
      ),
    );
  }

}
