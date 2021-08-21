import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:untitled/screens/product_details_screen.dart';

class FavouriteCard extends StatefulWidget {
  final DocumentSnapshot document;
  const FavouriteCard(this.document);
  @override
  State<FavouriteCard> createState() => _FavouriteCardState();
}

class _FavouriteCardState extends State<FavouriteCard> {

  @override
  Widget build(BuildContext context) {
    final String offer = (( widget.document['product']['comparedPrice']-widget.document['product']['price'])/widget.document['product']['comparedPrice']*100).toStringAsFixed(0);
    return Container(
      height: 180,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        border: Border(
            bottom: BorderSide(color: Color(0xFFE0E0E0))
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top:8,bottom:8,left: 10,right: 10),
        child: Row(
          children: [
            Stack(
              children: [
                Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    onTap: (){
                      pushNewScreenWithRouteSettings(
                        context,
                        settings: RouteSettings(name: ProductDetailsScreen.id),
                        screen: ProductDetailsScreen(document: widget.document),
                        withNavBar: false,
                        pageTransitionAnimation: PageTransitionAnimation.cupertino,
                      );

                    },
                    child: SizedBox(
                      height: 140,
                      width: 130,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(widget.document['product']['productImage'])),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color : Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomRight:Radius.circular(10),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 3,bottom: 3,left: 10,right: 10),
                    child: Text('$offer %OFF',style: TextStyle(color: Colors.white,fontSize: 12),),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left:8,top:5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.document['product']['brand'],style: TextStyle(fontSize: 10),),
                        SizedBox(height: 6,),
                        Text(widget.document['product']['productName'],style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 6,),
                        Container(
                          width: MediaQuery.of(context).size.width-160,
                          padding: EdgeInsets.only(top:10,bottom: 10,left: 6),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: Colors.grey[200]
                          ),
                          child:Text(widget.document['product']['weight'],
                              style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Colors.grey[600])),
                        ),
                        SizedBox(height: 6,),
                        Row(
                          children: [
                            Text(
                              '${widget.document['product']['price'].toStringAsFixed(0)}DT',
                              style: TextStyle(fontWeight: FontWeight.bold),),
                            SizedBox(width:10),
                            if (widget.document['product']['comparedPrice']>0)
                              Text('${widget.document['product']['comparedPrice'].toStringAsFixed(0)}DT'.toString(),
                                style: TextStyle(decoration: TextDecoration.lineThrough,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                    fontSize: 10),)
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(width: MediaQuery.of(context).size.width-240,),
                            IconButton(onPressed: () {
                              EasyLoading.show(status:'Loading...');
                              final CollectionReference favourite = FirebaseFirestore.instance.collection('favourites');
                              favourite.doc(widget.document.id).delete().then((value) {
                                EasyLoading.showSuccess('Removed From Favourite');
                              });
                            }, icon: Icon(Icons.favorite,color: Colors.redAccent,size: 40,),),
                          ],
                        )
                      ],
                    ) ,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
