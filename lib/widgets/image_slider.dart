
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';

class ImageSlider extends StatefulWidget {
  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {

  int _index = 0;
  int _dataLength=1;

  @override
  void initState() {
    getSliderImageFromDb();
    super.initState();
  }


  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getSliderImageFromDb() async {
    final _fireStore = FirebaseFirestore.instance;
    final QuerySnapshot<Map<String,dynamic>> snapshot = await _fireStore.collection('slider').get();
    if (mounted) {
      setState(() {
        _dataLength = snapshot.docs.length;
      });
    }
    return snapshot.docs;
  }



  @override
  Widget build(BuildContext context) {
    return Container(
        color:Color.fromRGBO(243, 244, 253,1),
      child: Column(
        children: [
          if(_dataLength!=0)
            FutureBuilder(
              future: getSliderImageFromDb(),
              builder: (_, AsyncSnapshot<List<QueryDocumentSnapshot<Map<String, dynamic>>>> snapShot) {
                return snapShot.data == null ? Center(child: CircularProgressIndicator(),) : Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: CarouselSlider.builder(
                      itemCount: snapShot.data!.length,
                      itemBuilder: (context, int index, int){
                        final DocumentSnapshot<Map<String,dynamic>> sliderImage = snapShot.data![index];
                        final Map<String, dynamic>? getImage = sliderImage.data();
                        return SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Image.network(
                              getImage!['image'],
                              fit: BoxFit.fill,

                            ),);
                      },
                      options: CarouselOptions(
                          viewportFraction: 1,
                          autoPlay: true,
                          height: 150,
                          onPageChanged: (int i,carouselPageChangedReason){
                            setState(() {
                              _index=i;
                            });
                          }
                      )),
                );
              },
            ),
          if(_dataLength!=0)
            DotsIndicator(
              dotsCount: _dataLength,
              position: _index.toDouble(),
              decorator: DotsDecorator(
                  size: const Size.square(5.0),
                  activeSize: const Size(18.0, 5.0),
                  activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                  activeColor: Theme.of(context).primaryColor
              ),
            )
        ],
      ),
    );
  }
}