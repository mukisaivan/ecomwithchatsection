// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomm/chatservice/screens/mobile_chat_screen.dart';
import 'package:ecomm/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class MyAdPost extends StatelessWidget {
  final String email;
  final String name;
  final String price;
  final String category;
  final String description;
  final String formattedDate;
  final String imageUrl;
  final String selleruid;

  const MyAdPost({
    Key? key,
    required this.email,
    required this.name,
    required this.price,
    required this.category,
    required this.description,
    required this.imageUrl,
    required this.formattedDate,
    required this.selleruid,
  }) : super(key: key);

  getsellername() async {
    var sellerdata = await FirebaseFirestore.instance
        .collection("users")
        .doc(selleruid)
        .get();
    var data = sellerdata.data()!;

    var dd = UserModel.fromMap(data);

    return dd.username;
  }

  void savePost(BuildContext context) async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await FirebaseFirestore.instance
          .collection("Ecomm Users")
          .doc(user.uid)
          .update({
        'savedPosts': FieldValue.arrayUnion([formattedDate])
      });
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Post saved successfully!',
              style: TextStyle(color: Colors.white)),
          backgroundColor: Color.fromARGB(255, 4, 123, 8),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving post: $error')),
      );
    }
  }

  void deletePost(BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection("UserAdPosts")
          .doc(formattedDate)
          .delete();

      if (imageUrl.isNotEmpty) {
        Reference reference = FirebaseStorage.instance.refFromURL(imageUrl);
        await reference.delete();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ad deleted successfully!')),
      );
      Navigator.of(context).pop();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting ad: $error')),
      );
    }
  }

  // getsellername() {
  //   FirebaseFirestore.instance
  //       .collection("UserAdPosts")
  //       .doc(formattedDate) // Assuming formattedDate is the document ID
  //       .get()
  //       .then((DocumentSnapshot documentSnapshot) {
  //     if (documentSnapshot.exists) {
  //       // Extract seller's name from the document data
  //       var sellerName = documentSnapshot.data();
  //       print('Seller Name: $sellerName');
  //     } else {
  //       print('Document does not exist');
  //     }
  //   }).catchError(() {});
  // }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final bool isUserPost = user.email == email;

    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (BuildContext context) {
            return FractionallySizedBox(
              heightFactor: 0.9,
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (imageUrl.isNotEmpty)
                      Image.network(
                        imageUrl,
                        width: double.infinity,
                        height: 300,
                        fit: BoxFit.contain,
                      ),
                    const SizedBox(height: 20),
                    Text(
                      'Price UGX: $price',
                      style: const TextStyle(fontSize: 18),
                    ),
                    Text(
                      'Item: $name',
                      style: const TextStyle(fontSize: 18),
                    ),
                    Text(
                      'Category: $category',
                      style: const TextStyle(fontSize: 18),
                    ),
                    Text(
                      'Description: $description',
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                isUserPost
                                    ? Colors.red
                                    : const Color.fromARGB(255, 4, 123, 8),
                              ),
                            ),
                            onPressed: () {
                              if (isUserPost) {
                                deletePost(context);
                              } else {
                                // var namy = await getsellername();

                                Navigator.pushNamed(
                                    context, MobileChatScreen.routeName,
                                    arguments: {
                                      'name': name,
                                      'uid': selleruid,
                                      'isGroupChat': false,
                                      'profilePic': imageUrl,
                                    });
                              }
                            },
                            child: Text(
                              isUserPost ? 'Delete Ad' : 'Message Seller',
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.white),
                            ),
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                isUserPost
                                    ? const Color.fromARGB(255, 4, 123, 8)
                                    : const Color.fromARGB(255, 243, 215, 3),
                              ),
                            ),
                            onPressed: () {
                              if (isUserPost) {
                                Navigator.of(context).pop();
                              } else {
                                savePost(context);
                              }
                            },
                            child: Text(
                              isUserPost ? 'Cancel' : 'Save',
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
        padding: const EdgeInsets.all(25),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Price: UGX $price'),
                  Text('Item: $name'),
                ],
              ),
              if (imageUrl.isNotEmpty)
                Image.network(
                  imageUrl,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                )
              else
                const Text('No Image'),
            ],
          ),
        ),
      ),
    );
  }
}
