import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled/widgets/categories_widget.dart';
import 'package:untitled/widgets/products/best_selling_product.dart';
import 'package:untitled/widgets/products/featured_products.dart';
import 'package:untitled/widgets/products/recently_added_product.dart';
import 'package:untitled/widgets/vendor_appbar.dart';
import 'package:untitled/widgets/vendor_banner.dart';

class VendorHomeScreen extends StatelessWidget {
 static const String id ='vendor-home-screen';
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        color: Color.fromRGBO(243, 244, 253,1),
        child: NestedScrollView (
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              VendorAppBar(),
            ];
          },
          body: ListView(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: [
              VendorBanner(),
              VendorCategories(),
              RecentlyAddedProducts(),
              FeaturedProducts(),
              Padding(
                padding: const EdgeInsets.only(bottom: 45),
                child: BestSellingProduct(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
