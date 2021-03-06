import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/providers/auth_provider.dart';
import 'package:untitled/providers/cart_provider.dart';
import 'package:untitled/providers/coupon_provider.dart';
import 'package:untitled/providers/location_provider.dart';
import 'package:untitled/screens/map_screen.dart';
import 'package:untitled/screens/profile_screen.dart';
import 'package:untitled/services/cart_services.dart';
import 'package:untitled/services/order_services.dart';
import 'package:untitled/services/store_services.dart';
import 'package:untitled/services/user_services.dart';
import 'package:untitled/widgets/cart/cart_list.dart';
import 'package:untitled/widgets/cart/cod_toggle.dart';
import 'package:untitled/widgets/cart/coupon_widget.dart';

class CartScreen extends StatefulWidget {
  final DocumentSnapshot ? document;
  const CartScreen({this.document});

  static const String id ='cart-screen';

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final StoreServices _store = StoreServices();
  final UserServices _userServices =UserServices();
  final OrderServices _orders = OrderServices();
  final CartServices _cartServices = CartServices();
  User ? user = FirebaseAuth.instance.currentUser;
  DocumentSnapshot ? doc;
  var textStyle = TextStyle(color: Colors.grey);
  int deliveryFee = 50 ;
  String _location = '';
  String _address = '';
  bool _loading = false;
  final bool _checkingUser = false ;
  double discount = 0 ;

  @override
  void initState() {
    getPrefs();
    _store.getShopDetails(widget.document!['sellerUid']).then((value){

        setState(() {
          doc = value;
        });

    });
    super.initState();
  }

  getPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? location = prefs.getString('location');
    final String? address = prefs.getString('address');
    if (mounted) {
      setState(() {
        _location = location.toString();
        _address = address.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final _cartProvider = Provider.of<CartProvider>(context);
    final locationData = Provider.of<LocationProvider>(context);
    final userDetails = Provider.of<AuthProvider>(context);
    final _coupon = Provider.of<CouponProvider>(context);
    userDetails.getUserDetails().then((value){
      final double subTotal = _cartProvider.subTotal;
      final double discountRate = _coupon.discountRate/100;
      if (mounted){
        setState(() {
          discount = subTotal*discountRate;
        });
      }
    });
    final _payable = _cartProvider.subTotal+deliveryFee-discount;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[200],
      bottomSheet: Container(
        height: 140,
        color: Colors.blueGrey[900],
        child: Column(
          children: [
            Container(
                height: 80,
                 width: MediaQuery.of(context).size.width,
                color : Colors.white,
                child:Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                       children: [
                         Expanded(
                           child: Text('Deliver to this address : ',
                             style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12),
                           ),
                         ),
                         InkWell(
                           onTap: (){
                              if (mounted) {
                                setState(() {
                                  _loading = true;
                                });
                              }
                             locationData.getCurrentPosition().then((value) {
                                if (mounted) {
                                  setState(() {
                                    _loading = false;
                                  });
                                }
                               if (value!=0){
                                 pushNewScreenWithRouteSettings(
                                   context,
                                   settings: RouteSettings(name: MapScreen.id),
                                   screen: MapScreen(),
                                   withNavBar: false,
                                   pageTransitionAnimation: PageTransitionAnimation.cupertino,
                                 );

                               }
                               else {
                                if (mounted) {
                                  setState(() {
                                    _loading = false;
                                  });
                                }
                                 print('Permission not allowed');
                               }
                             });
                           },
                             child: _loading ? Center(child:CircularProgressIndicator()) : Text('Change',style: TextStyle(color: Colors.red,fontSize: 12),))
                       ],
                     ),
                      if (userDetails.snapshot != null)
                      Text(userDetails.snapshot!['firstName'] !=null ? '${userDetails.snapshot!['firstName']} ${userDetails.snapshot!['lastName']} : $_location, $_address ' : '$_location, $_address',
                      style: TextStyle(color:Colors.grey,fontSize: 12),),

                    ],
                  ),
                ) ,
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 20,right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${_payable.toStringAsFixed(0)} DT',
                          style:
                          TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                        ),
                        Text('(Including Taxes)'
                          ,style: TextStyle(color: Colors.green,fontSize: 10),)
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        EasyLoading.show(status:'Please wait...');
                        _userServices.getUserById(user!.uid).then((value) {
                            if(value['firstName']== null){
                              EasyLoading.dismiss();
                              pushNewScreenWithRouteSettings(
                                context,
                                settings: RouteSettings(name: ProfileScreen.id),
                                screen: ProfileScreen(),
                                pageTransitionAnimation: PageTransitionAnimation.cupertino,
                              );
                            }
                           else {
                              EasyLoading.show(status:'Please wait...');
                              //TODO:PaymentGateway
                              _saveOrder(_cartProvider,_payable,_coupon,context);

                            }
                        });
                      },
                      child: _checkingUser ? Center(child:CircularProgressIndicator()) : Text(
                        'CHECKOUT',
                        style: TextStyle(
                            color: Colors.white,fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
     body: NestedScrollView(

       headerSliverBuilder:(BuildContext context , bool innerBoxIsScrolled){
         return [
           SliverAppBar(
             floating: true,
             snap: true ,
             backgroundColor: Colors.white,
             elevation: 0.0,
             title:Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Text(widget.document!['shopName'],
                   style: TextStyle(fontSize: 16),
                 ),
                 Row(
                   children: [
                     Text('${_cartProvider.cartQty} ${_cartProvider.cartQty> 1 ?  ' Items, ':' Item, '}',
                       style: TextStyle(fontSize: 10,color: Colors.grey),
                     ),
                     Text('To pay : ${_payable.toStringAsFixed(0)} DT',
                       style: TextStyle(fontSize: 10,color: Colors.grey),)
                   ],
                 ),
               ],
             ),
           ),
         ];
       } ,
       body: doc ==  null ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),)):_cartProvider.cartQty > 0 ? SingleChildScrollView(
         padding: EdgeInsets.only(bottom: 80),
         child: Container(
           padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom ) ,
           child: Column(
             children: [
               if (doc!=null)
               Container(
                 color: Colors.white,
                 child: Column(
                   children: [
                     ListTile(
                       tileColor: Colors.white,
                       leading: Container(
                         height: 60, width: 60,
                         child: ClipRRect
                           (  borderRadius: BorderRadius.circular(4),
                             child: Image.network(doc!['imageUrl'],fit:BoxFit.cover)),
                       ),
                       title: Text(doc!['shopName']),
                       subtitle: Text(doc!['address'],maxLines: 1,style: TextStyle(
                           fontSize: 12 , color: Colors.grey
                       ),),
                     ),
                     CodToggleSwitch(),
                     Divider(color: Colors.grey[300],),
                   ],
                 ),
               ),
               CartList(document: widget.document),

               if (doc != null)// coupon
               CouponWidget(doc!['uid']),
               //bill details card
               Padding(
                 padding: const EdgeInsets.only(right: 4,left: 4,top: 4,bottom: 80),
                 child: SizedBox(
                   width: MediaQuery.of(context).size.width,
                   child: Card(
                     child: Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Text('Bill Details',style: TextStyle(fontWeight: FontWeight.bold),),
                           SizedBox(height: 10,),
                           Row(
                             children: [
                                Expanded(child: Text('Basket Value',style: textStyle,)),
                                Text('${_cartProvider.subTotal.toStringAsFixed(0)} DT',style: textStyle),
                             ],
                           ),
                           SizedBox(height: 10,),
                          if ( discount > 0)
                           Row(
                             children: [
                               Expanded(child: Text('Discount',style: textStyle,)),
                               Text('${discount.toStringAsFixed(0)} DT',style: textStyle),
                             ],
                           ),
                           SizedBox(height: 10,),
                           Row(
                             children: [
                               Expanded(child: Text('Delivery Fee',style: textStyle,)),
                               Text('$deliveryFee DT',style: textStyle),
                             ],
                           ),
                           Divider(color: Colors.grey,),
                           Row(
                             children: [
                               Expanded(child: Text('Total Amount payable',style: TextStyle(fontWeight: FontWeight.bold ),)),
                               Text('${_payable.toStringAsFixed(0)} DT',style: TextStyle(fontWeight: FontWeight.bold )),
                             ],
                           ),
                           SizedBox(height: 10,),
                           Container(
                             decoration: BoxDecoration(
                               borderRadius: BorderRadius.circular(4),
                               color: Theme.of(context).primaryColor.withOpacity(.3),
                             ),
                             child:Padding(
                               padding: const EdgeInsets.all(8.0),
                               child: Row(
                                 children: [
                                   Expanded(child: Text('Total Saving',style:TextStyle(color: Colors.green),)),
                                   Text('${_cartProvider.saving.toStringAsFixed(0)} DT',style:TextStyle(color: Colors.green)),
                                 ],
                               ),
                             ) ,
                           ),
                         ],
                       ),
                     ),
                   ),
                 ),
               ),
             ],
           ),
         ),
       ) : Center(child: Text('Cart Empty , Continue Shopping'),),
     ),
    );
  }

   _saveOrder(CartProvider cartProvider,payable, CouponProvider coupon,context ) {
    _orders.saveOrder({
      'products': cartProvider.cartList,
      'userId': user!.uid,
      'deliveryFee': deliveryFee,
      'total': payable,
      'discount': discount.toStringAsFixed(0),
      'cod': cartProvider.cod,
      'discountCode': coupon.document == null ? null : coupon.document!['title'],
      'seller': {
        'shopName': widget.document!['shopName'],
        'sellerName':widget.document!['sellerUid'],
        },
      'timeStamp' : DateTime.now().toString(),
      'orderStatus' : 'Ordered',
      'deliveryBoy' : {
       'name' :'',
        'phone':'',
        'location':'',

      }

    }).then((value) {
        _cartServices.deleteCart().then((value){
          _cartServices.checkData().then((value){
            cartProvider.cartQty = 0;
            EasyLoading.showSuccess('Your order is submitted');
            Navigator.pop(context); // close cart screen
          });
        });
    });

   }
}
