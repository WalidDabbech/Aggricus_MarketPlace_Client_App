import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:untitled/constants.dart';

class OnBaordScreen extends StatefulWidget {

  @override
  _OnBaordScreenState createState() => _OnBaordScreenState();
}
final _controller = PageController(
  
);

int _currentPage = 0;
List<Widget> _pages = [
Column(
  children: [
    Expanded(child: Image.asset('images/enteraddress.png')),
    Text('Set Your Delivery Location', style: kPageViewTextStyle,textAlign:TextAlign.center,)
  ],
),
  Column(
    children: [
      Expanded(child: Image.asset('images/orderfood.png')),
      Text('Order Online From Your Favorite Store' , style: kPageViewTextStyle, textAlign:TextAlign.center, )
    ],
  ),
  Column(
    children: [
      Expanded(child: Image.asset('images/deliverfood.png')),
      Text('Quick Deliver to your Doorstep' , style: kPageViewTextStyle,textAlign:TextAlign.center,)
    ],
  )
];
class _OnBaordScreenState extends State<OnBaordScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView(
            controller:_controller ,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            children: _pages,
          ),
        ),
        DotsIndicator(
          dotsCount: _pages.length,
          position: _currentPage.toDouble(),
          decorator: DotsDecorator(
              activeSize: const Size(18.0, 9.0),
              activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
              activeColor: Theme.of(context).primaryColor,
          ),
        ),
        SizedBox(height: 20,),
      ],
    );
    
  }
}
