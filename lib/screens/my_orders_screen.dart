import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/providers/order_provider.dart';
import 'package:untitled/services/order_services.dart';
import 'package:intl/intl.dart';

class MyOrdersScreen extends StatefulWidget {

  @override
  _MyOrdersScreenState createState() => _MyOrdersScreenState();
}


class _MyOrdersScreenState extends State<MyOrdersScreen> {
  final OrderServices _orderServices = OrderServices();
  User ? user = FirebaseAuth.instance.currentUser;
  int tag = 0;
  List<String> options = [
    'All Orders', 'Ordered', 'Accepted', 'Picked Up',
    'On the way', 'Delivered',
  ];
  @override
  Widget build(BuildContext context) {
    final _orderProvider = Provider.of<OrderProvider>(context);
    return Scaffold(
      backgroundColor:Color.fromRGBO(243, 244, 253,1),
      appBar: AppBar(
        title: Text('My Orders',style: TextStyle(color: Colors.white),),
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){}, icon: Icon(CupertinoIcons.search,color: Colors.white,))
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 56,
            width: MediaQuery.of(context).size.width,
            child: ChipsChoice<int>.single(
              choiceStyle: C2ChoiceStyle(borderRadius:
              BorderRadius.all(Radius.circular(3))),
              value: tag,
              onChanged: (val) {
                if (val==0){
                  setState(() {
                    _orderProvider.filterOrder(null);
                  });
                }
                setState(() {
                  tag = val;
                  if (tag>0) {
                    _orderProvider.filterOrder(options[val]);
                  }
                });
              },
              choiceItems: C2Choice.listFrom<int, String>(
                source: options,
                value: (i, v) => i,
                label: (i, v) => v,
              ),
            ),
          ),
          Container(
              child:StreamBuilder<QuerySnapshot>(
                stream: _orderServices.orders.where('userId',isEqualTo:user!.uid).where('orderStatus',isEqualTo: _orderProvider.status).snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.data!.size==0){
                    //TODO:No Orders Screen
                    return Center (child: Text(tag>0 ? 'No ${options[tag]} orders':'No Orders. Continue Shopping'),);
                  }

                  return Expanded(
                    child: ListView(
                    children: snapshot.data!.docs.map((DocumentSnapshot document) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 5 , bottom : 5, left: 10 , right:10),
                      child: Material(
                        shadowColor: Color.fromRGBO(229, 231, 232,1),
                        borderRadius: BorderRadius.circular(6),
                        elevation: 5,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Container(
                          color: Colors.white,
                          child: Column(
                            children: [
                              ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 14,
                                  child: _orderServices.statusIcon(document),
                                ),
                                horizontalTitleGap: 0,
                                title: Text(
                                  document['orderStatus'],
                                  style: TextStyle(
                                      fontSize: 12,
                                      color:  _orderServices.statusColor(document),
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text('On ${DateFormat.yMMMd().format(DateTime.parse(document['timeStamp']))}',style: TextStyle(
                                    fontSize: 12),
                                ),
                                trailing: Column(
                                  crossAxisAlignment:  CrossAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('Payment Type: ${document['cod'] == true ? 'Cash on delivery' : 'Paid Online'} ',style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                                    Text('Amount: ${document['total'].toStringAsFixed(0)} DT',style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                                  ],
                                ),
                              ),
                              if (document['deliveryBoy']['email']!=null)
                              Padding(
                                padding: const EdgeInsets.only(left: 10, right: 10),
                                child: ClipRRect(
                                  borderRadius:BorderRadius.circular(6),
                                  child: Container(
                                  color: Theme.of(context).primaryColor.withOpacity(.3),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor:Colors.white,
                                      child:Image.network(document['deliveryBoy']['image'],height: 24,)
                                    ),
                                    title: Text(document['deliveryBoy']['name'],style: TextStyle(fontSize: 14)),
                                    subtitle: Text(_orderServices.statusComment(document),
                                    style: TextStyle(fontSize: 12),),
                                  ),
                                  ),
                                ),
                              ),
                              ExpansionTile(title: Text('Order details',style: TextStyle(fontSize: 10,color:Colors.black ),),
                                subtitle: Text('View order details',style: TextStyle(fontSize: 12,color:Colors.grey )),
                                children: [
                                  ListView.builder(
                                    shrinkWrap:true,
                                    physics : NeverScrollableScrollPhysics(),
                                    itemBuilder:(BuildContext context , int index){
                                      return ListTile(
                                        leading: CircleAvatar(
                                          backgroundColor: Colors.white,
                                          child: Image.network(document['products'][index]['productImage']),
                                        ),
                                        title: Text(document['products'][index]['productName'],style: TextStyle(fontSize: 12),),
                                        subtitle: Text(
                                          '${document['products'][index]['qty']} X ${document['products'][index]['price'].toStringAsFixed(0)}DT = ${document['products'][index]['total'].toStringAsFixed(0)}DT',
                                          style: TextStyle(color:Colors.grey,fontSize: 12),),
                                      );
                                    },
                                    itemCount: document['products'].length,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 12,right: 12,top:8,bottom: 8),
                                    child: Card(
                                      elevation:4,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Text('Seller : ',style: TextStyle(fontWeight: FontWeight.bold,fontSize:12 ),),
                                                Text(document['seller']['shopName'],style: TextStyle(color: Colors.grey,fontSize:12),)
                                              ],
                                            ),
                                            SizedBox(height: 10,),
                                            if (int.parse(document['discount'])>0)
                                              Container(
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text('Discount : ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12),),
                                                        Text('${document['discount']} ',style: TextStyle(color: Colors.grey,fontSize: 12),)
                                                      ],
                                                    ),
                                                    SizedBox(height: 10,),
                                                    Row(
                                                      children: [
                                                        Text('Discount Code : ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12),),
                                                        Text('${document['discountCode']} ',style: TextStyle(color: Colors.grey,fontSize: 12),)
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            SizedBox(height: 10,),
                                            Row(
                                              children: [
                                                Text('Delivery Fee : ',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12),),
                                                Text('${document['deliveryFee'].toString()}DT',style: TextStyle(color: Colors.grey,fontSize: 12),)

                                              ],
                                            ),
                                          ],
                                        ),
                                      ),),
                                  )
                                ],
                              ),
                            ],

                          ),
                          ),
                        ),
                      ),
                    );

                    }).toList(),
                    ),
                  );
                },
              )
          ),
        ],
      ),
    );
  }
}
