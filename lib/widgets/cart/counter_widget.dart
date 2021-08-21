import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/providers/cart_provider.dart';
import 'package:untitled/services/cart_services.dart';
import 'package:untitled/widgets/products/add_to_cart_widget.dart';

class CounterWidget extends StatefulWidget {

  final DocumentSnapshot? document;
  final String ? docId;
  final int ?  qty;
  const CounterWidget({this.document,this.qty,this.docId});

  @override
  _CounterWidgetState createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  final CartServices _cart = CartServices();
  int ? _qty;
  bool _updating  = false;
  bool _existing = true;
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    if (mounted) {
      setState(() {
        _qty = widget.qty;
      });
    }
    return _existing ? Container(
      margin: EdgeInsets.only(left: 20,right: 20),
      height: 56,
      child: Center(
       child: Padding(
         padding:EdgeInsets.all(8),
         child: FittedBox(
           child: Row(
             children: [
               InkWell(
                 onTap: (){
                    if (mounted) {
                      setState(() {
                        _updating = true;
                      });
                    }
                   if (_qty==1){
                     _cart.removeFromCart(widget.docId).then((value) {
                     if (mounted) {
                       setState(() {
                         _updating = false;
                         _existing = false;
                       });
                     }
                       _cart.checkData();
                     } );

                   }
                   if (_qty!>1){
                     if (mounted) {
                       setState(() {
                         _qty = _qty! - 1;
                       });
                     }
                     final total = _qty! * widget.document!['price'];
                     _cart.updateCartQty(widget.docId, _qty,total).then((value){
                        if (mounted) {
                          setState(() {
                            _updating = false;
                          });
                        }
                     });

                   }

                 },
                 child: Container(
                   decoration: BoxDecoration(
                     border: Border.all(color:Colors.red,
                     )
                   ),
                   child: Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: Icon(
                       _qty == 1 ? Icons.delete_outline : Icons.remove,
                         color:Colors.red
                     ),
                   ),
                 ),
               ),
               Container(

                 child: Padding(
                   padding: const EdgeInsets.only(left: 20,right: 20,top: 8,bottom:8),
                   child: _updating ? Container(
                     height: 24,width:24,
                     child: CircularProgressIndicator(
                   valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                    )
                   )
                   :Text(_qty.toString().toString(),style: TextStyle(color: Colors.red),),
                 ),
               ),
               InkWell(
                 onTap: (){
                      if (mounted) {
                        setState(() {
                          _updating = true;
                          _qty = _qty! + 1;
                        });
                      }
                   final total = _qty! * widget.document!['price'];
                   _cart.updateCartQty(widget.docId, _qty,total).then((value){
                    if (mounted) {
                      setState(() {
                        _updating = false;
                      });
                    }
                   });

                 },
                 child: Container(
                   decoration: BoxDecoration(
                       border: Border.all(color:Colors.red)
                   ),
                   child: Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: Icon(
                         Icons.add,
                         color:Colors.red
                     ),
                   ),
                 ),
               ),
             ],
           ),
         ),
       ),
      ),
    ):AddToCartWidget(widget.document);
  }
}
