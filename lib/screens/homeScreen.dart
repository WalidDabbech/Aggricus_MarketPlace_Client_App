import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled/widgets/image_slider.dart';
import 'package:untitled/widgets/my_appbar.dart';
import 'package:untitled/widgets/near_by_store.dart';
import 'package:untitled/widgets/top_picked_store.dart';
class HomeScreen extends StatefulWidget {
  static const String id ='home-screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
            MyAppBar(),
            ];
          },
          body: ListView(
            padding: EdgeInsets.only(),
            children: [
              ImageSlider(),
              Container(
                  color:Color.fromRGBO(243, 244, 253,1),
                  child: TopPickStore()),
              Padding(
                padding: const EdgeInsets.only(top:6),
                child: NearByStore(),
            ),
          ],
        ),
      ),
    );
  }
}
