import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:untitled/providers/store_provider.dart';
import 'package:untitled/screens/product_list_screen.dart';
import 'package:untitled/services/product_services.dart';

class VendorCategories extends StatefulWidget {

  @override
  _VendorCategoriesState createState() => _VendorCategoriesState();
}

class _VendorCategoriesState extends State<VendorCategories> {
  final ProductServices _services = ProductServices();
  final List _catList=[];
  @override
  void didChangeDependencies() {
    final _store = Provider.of<StoreProvider>(context);
    FirebaseFirestore.instance
        .collection('products').where('seller.sellerUid',isEqualTo:_store.storeDetails!['uid'] )
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
       if (mounted) {
         setState(() {
           _catList.add(doc['category']['mainCategory']);
         });
       }
        
      });
    });
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {

    final _store = Provider.of<StoreProvider>(context);
    return FutureBuilder(
      future: _services.category.get(),
      builder:(BuildContext context,AsyncSnapshot<QuerySnapshot>snapshot){
        if (snapshot.hasError){
          return Center(child: Text('Something Went Wrong...'),);
        }
        if (!snapshot.hasData){
          return Container();
        }
        return SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 46,
                child: Padding(
                  padding: const EdgeInsets.only(left:8.0),
                  child: Text('Shop By Category',style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Tahoma',

                  ),),
                ),
              ),
              Wrap(
                children:snapshot.data!.docs.map((DocumentSnapshot document){
                  return _catList.contains(document['name']) ?
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Material(
                      shadowColor: Color.fromRGBO(229, 231, 232,1),
                      elevation: 5,
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        onTap: (){
                          _store.selectedCategory(document['name']);
                          pushNewScreenWithRouteSettings(
                            context,
                            settings: RouteSettings(name: ProductListScreen.id),
                            screen: ProductListScreen(),
                            withNavBar: true,
                            pageTransitionAnimation: PageTransitionAnimation.cupertino,
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: SizedBox(
                            width: 120,
                            height: 150,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border : Border.all(
                                    color: Colors.grey,
                                    width: .5
                                ),
                              ),
                              child: Column(
                                children: [
                                  Center(
                                    child: Image.network(document['image']),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left:8,right: 8),
                                    child: Text(document['name'],textAlign: TextAlign.center,),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ) : Text('');
                }).toList(),
              ),
            ],
          )
        );
      },
    );
  }
}
