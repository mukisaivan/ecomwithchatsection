// ignore_for_file: public_member_api_docs, sort_constructors_first, use_build_context_synchronously

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthMethods {
  FirebaseAuth auth = FirebaseAuth.instance;

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  // addProduct({
  //   required BuildContext context,
  //   required String name,
  //   required String category,
  //   required int price,
  //   required String description,
  //   required List<Uint8List> pdtImages,
  // }) async {
  //   try {
  //     List<String> imgs =
  //         await StorageServices().uploadImage("Product Images", pdtImages);

  //     var pdtId = const Uuid().v1();

  //     var timeAdded = DateTime.now();

  //     ProductModel product = ProductModel(
  //       pdtId: pdtId,
  //       name: name,
  //       category: category,
  //       price: price,
  //       description: description,
  //       pdtImages: imgs,
  //       timeAdded: timeAdded,
  //       uploaderUid: FirebaseAuth.instance.currentUser!.uid,
  //     );

  //     await firebaseFirestore.collection("products").add(product.toMap());

  //     Fluttertoast.showToast(
  //       msg: "Product added Successfully",
  //       gravity: ToastGravity.CENTER,
  //     );

  //     // Navigator.pushNamed(context, MyBottomBar.routeName);
  //   } on FirebaseException catch (e) {
  //     return Fluttertoast.showToast(msg: e.toString());
  //   }
  // }

  Widget fetchProduct(String category) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("products").snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final filteredDocs = snapshot.data!.docs.where((doc) {
          Map<String, dynamic> data = doc.data();
          String pdtcategory = data["category"];
          return pdtcategory == category;
        }).toList();

        return SizedBox(
          height: 300,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: 200,
              mainAxisSpacing: 0,
              crossAxisSpacing: 10,
            ),
            itemCount: filteredDocs.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> data = filteredDocs[index].data();
              return buildPdtList(data);
            },
          ),
        );
      },
    );
  }

  Widget buildPdtList(Map<String, dynamic> data) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleProduct(data: data),
    );
  }

  deleteProduct({
    required BuildContext context,
    required String pdtId,
  }) async {
    try {
      var snapshot =
          await FirebaseFirestore.instance.collection("products").get();

      for (var docs in snapshot.docs) {
        var data = docs.data()["pdtId"];

        if (pdtId == data) {
          docs.reference.delete();

          Timer(const Duration(seconds: 2), () {
            Navigator.pop(context);
          });
        }
      }

      Fluttertoast.showToast(
        msg: "Product deleted Successfully",
        gravity: ToastGravity.CENTER,
      );
    } on FirebaseException catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  // moveToupdateProductScreen({
  //   required BuildContext context,
  //   required Map<String, dynamic> pdtData,
  // }) {
  //   try {
  //     Navigator.pushNamed(context, UpdatePdtScreen.routeName,
  //         arguments: pdtData);
  //   } on FirebaseException catch (e) {
  //     Fluttertoast.showToast(
  //         msg: e.toString(), backgroundColor: Colors.redAccent);
  //   }
  // }

  // void saveProductDataToFirestore(Map<String, dynamic> productData) async {
  //   try {
  //     String productId = productData[
  //         'productId']; // Assuming productId is part of your product data
  //     await FirebaseFirestore.instance
  //         .collection('products')
  //         .doc(productId)
  //         .update(productData);
  //     print('Product data updated successfully!');
  //   } catch (e) {
  //     print('Error updating product data: $e');
  //   }
  // }
}

class SingleProduct extends StatefulWidget {
  final Map<String, dynamic>? data;
  const SingleProduct({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  State<SingleProduct> createState() => _SingleProductState();
}

class _SingleProductState extends State<SingleProduct> {
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.orange,
      ),
      height: 300,
      width: 200,
      child: Column(
        children: [
          SizedBox(
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black12,
                  width: 0.5,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: GestureDetector(
                    onTap: () {
                      Future.delayed(Duration.zero, () {});
                    },
                    child: Image.network(
                      widget.data!["pdtImages"][0],
                      fit: BoxFit.cover,
                      height: 100,
                      width: 200,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.only(
              left: 8,
              top: 5,
              right: 15,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      widget.data!["name"],
                      style: const TextStyle(fontSize: 13),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "Shs. ${widget.data!["price"].toString()}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    setState(
                      () {
                        isLiked = !isLiked;
                      },
                    );
                  },
                  child: Icon(Icons.favorite,
                      size: 20, color: isLiked ? Colors.red : Colors.grey),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}




// Widget fetchProduct(String category) {
  //   return StreamBuilder(
  //     stream: FirebaseFirestore.instance.collection("products").snapshots(),
  //     builder: (context, snapshot) {
  //       if (snapshot.hasError) {
  //         return Text("Error: ${snapshot.error}");
  //       }

  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         return const Center(child: CircularProgressIndicator());
  //       }

  //       return SizedBox(
  //         height: 300,
  //         child: GridView(
  //           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  //               crossAxisCount: 2,
  //               mainAxisExtent: 200,
  //               mainAxisSpacing: 0,
  //               crossAxisSpacing: 10),
  //           children: snapshot.data!.docs.map<Widget>((e) {
  //             return buildPdtList(e, category);
  //           }).toList(),
  //         ),
  //       );
  //     },
  //   );
  // }

  // buildPdtList(DocumentSnapshot snapshot, String category) {
  //   Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

  //   String pdtcategory = data["category"];

  //   if (pdtcategory == category) {
  //     return Padding(
  //       padding: const EdgeInsets.all(8.0),
  //       child: SingleProduct(data: data),
  //     );
  //   } else {
  //     return SizedBox.shrink();
  //   }
  // }