import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/providers/store_provider.dart';
import 'package:untitled/widgets/products/product_list.dart';

class ProductListScreen extends StatelessWidget {
  static const String id = 'product-list-screen';

  @override
  Widget build(BuildContext context) {
    final _store = Provider.of<StoreProvider>(context);
    return Scaffold(
        body: Container(
           color: Color.fromRGBO(243, 244, 253,1),
          child: NestedScrollView (
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
      return [
          SliverAppBar(
            iconTheme: IconThemeData(color: Colors.white),
            title:Text(_store.category.toString(),style: TextStyle(color: Colors.white,fontWeight:
            FontWeight.bold),),

          ),

      ];
    },
    body: ListView(
      padding:EdgeInsets.zero,
      shrinkWrap: true,
      children: [
          ProductListWidget(),
      ],
    ),
    ),
        )
    );
  }
}
