import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:provider/provider.dart';
import 'package:untitled/providers/store_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class VendorAppBar extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final _store = Provider.of<StoreProvider>(context);

    mapLauncher()async{
      final GeoPoint location =_store.storeDetails!['location'];
      final availableMaps = await MapLauncher.installedMaps;
      print(availableMaps); // [AvailableMap { mapName: Google Maps, mapType: google }, ...]
      await availableMaps.first.showMarker(
          coords: Coords(location.latitude,location.longitude),
          title: '${_store.storeDetails!['shopName']} Here');

    }

    return SliverAppBar(
      floating: true,
      snap: true,
      iconTheme:IconThemeData(
          color: Colors.white
      ),
      expandedHeight: 280,
      flexibleSpace: SizedBox(
          child: Padding(
            padding: const EdgeInsets.only(top:86),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      image:DecorationImage(
                          fit:BoxFit.cover,
                          image: NetworkImage(_store.storeDetails!['imageUrl']))
                  ),
                  child: Container(
                    color:Colors.grey.withOpacity(.7),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          Text(_store.storeDetails!['dialog'],
                          style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15),),
                          Text(_store.storeDetails!['address'],
                            style: TextStyle(color: Colors.white),),
                          Text(_store.storeDetails!['emil'],
                            style: TextStyle(color: Colors.white),),
                          Text(
                            'Distance :${_store.distance}km'.toString(),
                            style: TextStyle(color: Colors.white),),
                          SizedBox(height: 6,),
                          Row(
                            children: [
                              Icon(Icons.star,color: Colors.white),
                              Icon(Icons.star,color: Colors.white),
                              Icon(Icons.star,color: Colors.white),
                              Icon(Icons.star_half,color:Colors.white),
                              Icon(Icons.star_outline,color:Colors.white),
                              SizedBox(width:5),
                              Text('3.5',style: TextStyle(color: Colors.white)),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              CircleAvatar(backgroundColor: Colors.white,
                              child: IconButton(onPressed:(){
                                launch('tel:${_store.storeDetails!['mobile']}');
                              }, icon: Icon(Icons.phone,color:Theme.of(context).primaryColor)),),
                              SizedBox(width: 3,),
                              CircleAvatar(backgroundColor: Colors.white,
                              child:IconButton(onPressed:(){
                                mapLauncher();
                              }, icon: Icon(Icons.map,color:Theme.of(context).primaryColor)),),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
      ),
      actions: [
        IconButton(onPressed: () {
        },
          icon: Icon(CupertinoIcons.search),)
      ],
      title: Text(_store.storeDetails!['shopName'].toString(),
        style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold
        ),),
    );
  }
}
