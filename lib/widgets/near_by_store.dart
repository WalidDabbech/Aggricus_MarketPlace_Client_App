
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:provider/provider.dart';
import 'package:untitled/constants.dart';
import 'package:untitled/providers/cart_provider.dart';
import 'package:untitled/providers/store_provider.dart';
import 'package:untitled/services/store_services.dart';

class NearByStore extends StatefulWidget {

  @override
  State<NearByStore> createState() => _NearByStoreState();
}

class _NearByStoreState extends State<NearByStore> {




  final StoreServices _storeServices = StoreServices();

  PaginateRefreshedChangeListener refreshedChangeListener = PaginateRefreshedChangeListener();

  @override
  Widget build(BuildContext context) {

    final _storeData = Provider.of<StoreProvider>(context);
    final _cart = Provider.of<CartProvider>(context);

    _storeData.getUserLocationData(context);

    String getDistance(location){
      final distance = Geolocator.distanceBetween(_storeData.userLatitude, _storeData.userLongitude, location.latitude, location.longitude);
      final distanceInKm = distance/1000;
      return  distanceInKm.toStringAsFixed(2);
    }


    return Container(
        color:Color.fromRGBO(243, 244, 253,1),
      child: StreamBuilder<QuerySnapshot>(
        stream: _storeServices.getNearByStore(), // will change it soon
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot>snapShot) {
          if (!snapShot.hasData) {
            return
            Center(child: CircularProgressIndicator());
          }
          final List shopDistance = [];
          for (int i = 0; i <= snapShot.data!.docs.length - 1; i++) {
            final distance = Geolocator.distanceBetween(
                _storeData.userLatitude, _storeData.userLongitude,
                snapShot.data!.docs[i]['location'].latitude,
                snapShot.data!.docs[i]['location'].longitude);
            final distanceInKm = distance / 1000;
            shopDistance.add(distanceInKm);
          }
          shopDistance.sort();
          // this will sort with nearest distance. if nearest distance is more than 10, that means no shop near by;
          SchedulerBinding.instance!
              .addPostFrameCallback((_) => setState(() {
            _cart.getDistance(shopDistance[0]);
          }));
          if (shopDistance[0] > 10000) {
            return Container(
              child: Stack(
                children: [
              Padding(
              padding: const EdgeInsets.only(bottom: 30 , top:30 , left: 20 , right: 20),
              child: Container(
                child:Center(
                  child: Text('Currently we are not servicing in your area, Please Try again later or try an other location',
                    textAlign: TextAlign.left,style: TextStyle(color: Colors.black54,fontSize: 20),),
                ),
              ),
              ),
                  SizedBox(height: 40,),
                  Image.asset(
                      'images/city.png', color: Colors.black12),
                  Positioned(
                    right: 10.0,
                    top: 80,
                    child: Container(
                      width: 100,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Made by : ', style: TextStyle(
                              color: Colors.black54
                          ),),
                          Text('Walid Dabbech', style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Anton',
                              letterSpacing: 2,
                              color: Colors.grey
                          ),)
                        ],

                      ),
                    ),
                  )

                ],
              ),
            );
          }
          return Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RefreshIndicator(
                  onRefresh: () async {
                    refreshedChangeListener.refreshed = true;
                  },
                  child: PaginateFirestore(
                    bottomLoader: SizedBox(
                      height: 30,
                      width: 30,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Theme
                            .of(context)
                            .primaryColor),
                      ),
                    ),
                    header: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8, right: 8, top: 20
                            ),
                            child: Text('All Nearby Stores',
                              style: TextStyle(fontWeight: FontWeight.w900,
                                  fontSize: 18
                              ),),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8, right: 8, bottom: 10
                            ),
                            child: Text('Findout quality products near you',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.black54
                              ),),
                          ),
                        ],
                      ),
                    ),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilderType: PaginateBuilderType.listView,
                    itemBuilder: (index, context, document) =>
                        Padding(
                          padding: const EdgeInsets.all(4),
                          child: Container(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 100,
                                  height: 110,
                                  child: Card(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                       child: Image.network(
                                        document['imageUrl'],
                                        fit: BoxFit.cover,
                                    ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10,),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Text(
                                        document['shopName'], style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Text(document['dialog'],
                                      style: kStoreCardStyle,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Container(
                                      width: MediaQuery
                                          .of(context)
                                          .size
                                          .width - 250,
                                      child: Text(document['address'],
                                        overflow: TextOverflow.ellipsis,
                                        style: kStoreCardStyle,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Text(
                                      '${getDistance(document['location'])}Km',style: kStoreCardStyle,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          size: 12,
                                          color: Colors.grey,
                                        ),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        Text('3.2', style: kStoreCardStyle,)
                                      ],
                                    )

                                  ],
                                )

                              ],
                            ),
                          ),
                        ),
                    query: _storeServices.getNearByStorePagination(),
                    listeners: [
                      refreshedChangeListener,
                    ],
                    footer: SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Container(
                          child: Stack(
                            children: [
                              Center(
                                child: Text('***That all folks***',
                                  style: TextStyle(color: Colors.grey),),
                              ),
                              Image.asset(
                                  'images/city.png', color: Colors.black12),
                              Positioned(
                                right: 10.0,
                                top: 80,
                                child: Container(
                                  width: 100,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Made by : ', style: TextStyle(
                                          color: Colors.black54
                                      ),),
                                      Text('Walid Dabbech', style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Anton',
                                          letterSpacing: 2,
                                          color: Colors.grey
                                      ),)
                                    ],

                                  ),
                                ),
                              )

                            ],
                          ),
                        ),
                      ),
                    ),

                  ),
                )
              ],

            ),
          );
        },
      ),
    );
  }
}