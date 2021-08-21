import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:untitled/widgets/products/add_to_cart_widget.dart';
import 'package:untitled/widgets/products/save_for_later.dart';

class BottomSheetContainer extends StatefulWidget {

final DocumentSnapshot? document;
const BottomSheetContainer(this.document);

  @override
  _BottomSheetContainerState createState() => _BottomSheetContainerState();
}

class _BottomSheetContainerState extends State<BottomSheetContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Flexible(child: SaveForLater(widget.document)),
          Flexible(child: AddToCartWidget(widget.document)),
        ],
      ),
    );
  }
}
