import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:untitled/providers/auth_provider.dart';
import 'package:untitled/providers/location_provider.dart';
import 'package:untitled/screens/profile_update_screen.dart';
import 'package:untitled/screens/welcome_screen.dart';

import 'map_screen.dart';

class ProfileScreen extends StatelessWidget {
  static const String id ='profile-screen';
  @override
  Widget build(BuildContext context) {
    final userDetails = Provider.of<AuthProvider>(context);
    final locationData = Provider.of<LocationProvider>(context);

    userDetails.getUserDetails();
    final User ? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      backgroundColor:Color.fromRGBO(243, 244, 253,1),
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        title: Text('Aggricus',style: TextStyle(color: Colors.white),),
      ),
      body: userDetails.snapshot != null ?
      SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          children: [
            Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('MY ACCOUNT',style:TextStyle(fontWeight: FontWeight.bold) ,),
              ),
            ),
            Stack(
              children: [
                Container(
                  color: Colors.redAccent,
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:Column(
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 40,
                                backgroundColor: Theme.of(context).primaryColor,
                                child: Text('j',style: TextStyle(fontSize: 50,color: Colors.white),),
                              ),
                              SizedBox(width: 10,),
                              Container(
                                height: 70,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      userDetails.snapshot!['firstName']!=null ? '${userDetails.snapshot!['firstName']} ${userDetails.snapshot!['lastName']}':'Update your Name',
                                      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.white),),
                                        if(userDetails.snapshot!['email']!=null)
                                          Text(userDetails.snapshot!['email'],style: TextStyle(fontSize:14,color: Colors.white ),),
                                      Text(user!.phoneNumber.toString(),style: TextStyle(fontSize:14,color: Colors.white ),),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10,),
                          if (userDetails.snapshot!=null)
                            Container(
                              color: Colors.white,
                              child: ListTile(
                                tileColor: Colors.white,
                                leading: Icon(Icons.location_on,color: Colors.redAccent),
                                title: Text(userDetails.snapshot!['location']),
                                subtitle:Text(userDetails.snapshot!['address'],maxLines: 1,) ,
                                trailing: SizedBox(
                                  width: 80,
                                  child: TextButton(
                                    style: TextButton.styleFrom(side: BorderSide(color: Colors.redAccent)),
                                    onPressed: () {
                                      EasyLoading.show(status:'Please wait...');
                                      locationData.getCurrentPosition().then((value) {
                                        if (value!=0){
                                          EasyLoading.dismiss();
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
                                    child: Text('Change',style: TextStyle(color: Colors.redAccent),),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      )
                  ),
                ),
                Positioned(
                  right: 10.0,
                  child:IconButton(icon: Icon(Icons.edit_outlined,color:Colors.white), onPressed: () {
                    pushNewScreenWithRouteSettings(
                      context,
                      settings: RouteSettings(name: UpdateProfile.id),
                      screen: UpdateProfile(),
                      withNavBar: false,
                      pageTransitionAnimation: PageTransitionAnimation.cupertino,
                    );
                  },) ,)
              ],
            ),
            ListTile(
                horizontalTitleGap:2 ,
                leading: Icon(Icons.history),
                title: Text('My Orders')),
            Divider(),
            ListTile(
                horizontalTitleGap:2 ,
                leading: Icon(Icons.comment_outlined),
                title: Text('My Ratings & Reviews'),
            ),
            Divider(),
            ListTile(
                horizontalTitleGap:2 ,
                leading: Icon(Icons.notifications_none),
                title: Text('Notifications')),
            Divider(),
            ListTile(
                horizontalTitleGap:2 ,
                leading: Icon(Icons.power_settings_new),
                title: Text('Logout'),
                onTap:(){
                  FirebaseAuth.instance.signOut();
                  pushNewScreenWithRouteSettings(
                    context,
                    settings: RouteSettings(name: WelcomeScreen.id),
                    screen: WelcomeScreen(),
                    withNavBar: false,
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );
                 } ,
            ),
          ],
        ),
      ) : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
      ),
      ),
    );
  }
}
