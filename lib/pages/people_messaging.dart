import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomm/chatservice/screens/mobile_chat_screen.dart';
import 'package:ecomm/chatservice/widgets/loading.dart';
import 'package:ecomm/models/messeger.dart';
import 'package:ecomm/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PeopleMessaging extends StatefulWidget {
  const PeopleMessaging({super.key});

  @override
  State<PeopleMessaging> createState() => _PeopleMessagingState();
}

class _PeopleMessagingState extends State<PeopleMessaging> {
  Stream<List<Messager>> getmessagers() {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("messagers")
        .snapshots()
        .asyncMap((event) async {
      List<Messager> messagers = [];
      for (var element in event.docs) {
        var messagerdata = Messager.fromMap(element.data());

        var userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(messagerdata.contactId)
            .get();

        var wholeUserMap = UserModel.fromMap(userData.data()!);

        messagers.add(
          Messager(
            name: wholeUserMap.username,
            contactId: wholeUserMap.phonecontact,
            timeSent: DateTime.now(),
            lastMessage: "",
          ),
        );
      }
      print("+++++++++++++++++++++++++++++++++++++++++${messagers.length}");
      return messagers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Messager>>(
          stream: getmessagers(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              const Loading();
            }
            if (snapshot.data == null || snapshot.data!.isEmpty) {
              return const Center(
                child: Column(
                  children: [
                    Text('fetching chats ....... '),
                  ],
                ),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var snapdata = snapshot.data![index];

                return GestureDetector(
                  onTap: () => Navigator.pushNamed(
                      context, MobileChatScreen.routeName,
                      arguments: {
                        'name': snapdata.name,
                        'uid': snapdata.contactId,
                        'isGroupChat': false,
                        'profilePic': "imageUrl",
                      }),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(221, 187, 169, 169),
                            borderRadius: BorderRadius.circular(25)),
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                        padding: const EdgeInsets.all(10),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                snapdata.name,
                                style: const TextStyle(fontSize: 34),
                              ),
                            ])),
                  ),
                );
              },
            );
          }),
    );
  }
}
