import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomm/pages/categoriespages.dart/cars.dart';
import 'package:ecomm/pages/categoriespages.dart/fashion.dart';
import 'package:ecomm/pages/categoriespages.dart/furniture.dart';
import 'package:ecomm/pages/categoriespages.dart/gadgets.dart';
import 'package:ecomm/pages/categoriespages.dart/groceries.dart';
import 'package:ecomm/pages/categoriespages.dart/houses.dart';
import 'package:ecomm/pages/categoriespages.dart/kids.dart';
import 'package:ecomm/pages/categoriespages.dart/laptops.dart';
import 'package:ecomm/pages/categoriespages.dart/pets.dart';
import 'package:ecomm/pages/categoriespages.dart/trending.dart';
import 'package:flutter/material.dart';
import 'package:ecomm/components/adcard.dart';
import 'package:ecomm/components/mytab.dart';

class HomerPage extends StatefulWidget {
  static const String routeName = '/homer-screen';

  const HomerPage({Key? key}) : super(key: key);

  @override
  State<HomerPage> createState() => _HomerPageState();
}

class _HomerPageState extends State<HomerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 4, 123, 8),
        centerTitle: true,
        title: const Text(
          "Home",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverGrid.count(
            crossAxisCount: 4,
            children: [
              MyTab(
                imagePath: "lib/assets/fire.png",
                textDescription: "Trending",
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const TrendingPage()),
                  );
                },
              ),
              MyTab(
                imagePath: "lib/assets/car.png",
                textDescription: "Cars",
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const CarsPage()),
                  );
                },
              ),
              MyTab(
                imagePath: "lib/assets/chair.png",
                textDescription: "Furniture",
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FurniturePage()),
                  );
                },
              ),
              MyTab(
                imagePath: "lib/assets/dress.png",
                textDescription: "Fashion",
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FashionPage()),
                  );
                },
              ),
              MyTab(
                imagePath: "lib/assets/food.png",
                textDescription: "Groceries",
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const GroceriesPage()),
                  );
                },
              ),
              MyTab(
                imagePath: "lib/assets/house.png",
                textDescription: "Houses",
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HousesPage()),
                  );
                },
              ),
              MyTab(
                imagePath: "lib/assets/laptop.png",
                textDescription: "Laptops",
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LaptopsPage()),
                  );
                },
              ),
              MyTab(
                imagePath: "lib/assets/pets.png",
                textDescription: "Pets",
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const PetsPage()),
                  );
                },
              ),
              MyTab(
                imagePath: "lib/assets/phone.png",
                textDescription: "Gadgets",
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const GadgetsPage()),
                  );
                },
              ),
              MyTab(
                imagePath: "lib/assets/toys.png",
                textDescription: "Kids",
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const KidsPage()),
                  );
                },
              ),
            ],
          ),
          const SliverPadding(
            padding: EdgeInsets.all(20.0),
            sliver: SliverToBoxAdapter(
              child: Text(
                "Trending",
                style: TextStyle(fontSize: 23),
              ),
            ),
          ),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("UserAdPosts")
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final post = snapshot.data!.docs[index];
                      final imageUrl =
                          post['ImageURL']; // Access the 'ImageURL' field

                      return MyAdPost(
                        email: post['UserEmail'],
                        name: post['ItemName'],
                        price: post['Price'],
                        category: post['Category'] ?? '',
                        description: post['Description'],
                        imageUrl:
                            imageUrl, // Pass the imageUrl to MyAdPost widget
                        formattedDate: snapshot.data!.docs[index].id,
                        selleruid: post["uid"],
                      );
                    },
                    childCount: snapshot.data!.docs.length,
                  ),
                );
              } else if (snapshot.hasError) {
                return SliverToBoxAdapter(
                  child: Center(
                    child: Text('Error: ${snapshot.error}'),
                  ),
                );
              }
              return const SliverToBoxAdapter(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          ),
          const SliverPadding(padding: EdgeInsets.all(8))
        ],
      ),
    );
  }
}
