import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/providers/location_provider.dart';
import 'package:untitled/screens/map_screen.dart';

class MyAppBar extends StatefulWidget {

  @override
  _MyAppBarState createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
  String ? _location  ;
  String ? _address ;
  @override
  void initState() {
    getPrefs();
    super.initState();
  }

  getPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? location = prefs.getString('location');
    final String? address = prefs.getString('address');

    setState(() {
      _location=location.toString();
      _address=address.toString();
    });
  }
  @override
  Widget build(BuildContext context) {
    final locationData = Provider.of<LocationProvider>(context);

    return SliverAppBar(
      automaticallyImplyLeading: false,
      elevation: 0.0,
      floating: true,
      snap: true,
      title:TextButton(
        onPressed: () {
          locationData.getCurrentPosition().then((value) {
            if (locationData.permissionAllowed==true){
              pushNewScreenWithRouteSettings(
                context,
                settings: RouteSettings(name: MapScreen.id),
                screen: MapScreen(),
                withNavBar: false,
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              );

            }
            else {
              print('Permission not allowed');
            }
          });
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment:CrossAxisAlignment.start ,
          children: [
            Row(
              children: [
              Flexible(child: Text(
                _location == null?'Address not set':_location.toString(),
                style: TextStyle(color : Colors.white,fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,)),
              Icon(
                Icons.edit_outlined,
                color:Colors.white,
                size: 15,
              ),
            ],
          ),
            Flexible(child: Text(
              _address==null?'Address not set':_address.toString(),
              style: TextStyle(color : Colors.white,fontSize: 12),
              overflow: TextOverflow.ellipsis,)),
          ],
        ),
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search',
              prefixIcon: Icon(Icons.search,color: Colors.grey,),
              border : OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide.none
              ),
              contentPadding:EdgeInsets.zero ,
              filled: true,
              fillColor: Colors.white,
            ),

          ),
        ),
      ),
    );
  }
}
