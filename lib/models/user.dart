// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class UserModel {
  static const admin = "admin";
  static const client = "client";

  final String username;
  final String uid;
  final String email;
  final String phonecontact;
  final String role;
  final List<dynamic> cart;
  UserModel({
    required this.username,
    required this.uid,
    required this.email,
    required this.phonecontact,
    required this.role,
    required this.cart,
  });

  UserModel copyWith({
    String? username,
    String? uid,
    String? email,
    String? phonecontact,
    String? role,
    List<dynamic>? cart,
  }) {
    return UserModel(
      username: username ?? this.username,
      uid: uid ?? this.uid,
      email: email ?? this.email,
      phonecontact: phonecontact ?? this.phonecontact,
      role: role ?? this.role,
      cart: cart ?? this.cart,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'username': username,
      'uid': uid,
      'email': email,
      'phonecontact': phonecontact,
      'role': role,
      'cart': cart,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      username: map['username'] as String,
      uid: map['uid'] as String,
      email: map['email'] as String,
      phonecontact: map['phonecontact'] as String,
      role: map['role'] as String,
      cart: List<Map<String, dynamic>>.from(
        (map['cart']!.map((x) => Map<String, dynamic>.from(x))),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  factory UserModel.fromSnapShot(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;
    return UserModel(
      username: data["username"],
      uid: data["uid"],
      email: data["email"],
      phonecontact: data["phonecontact"],
      role: data["role"] ?? client,
      cart: [],
    );
  }

  @override
  String toString() {
    return 'UserModel(username: $username, uid: $uid, email: $email, phonecontact: $phonecontact, role: $role, cart: $cart)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.username == username &&
        other.uid == uid &&
        other.email == email &&
        other.phonecontact == phonecontact &&
        other.role == role &&
        listEquals(other.cart, cart);
  }

  @override
  int get hashCode {
    return username.hashCode ^
        uid.hashCode ^
        email.hashCode ^
        phonecontact.hashCode ^
        role.hashCode ^
        cart.hashCode;
  }
}
