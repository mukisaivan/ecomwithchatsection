// ignore_for_file: public_member_api_docs, sort_constructors_first

class ProductModel {
  final String pdtId;
  final String name;
  final String category;
  final int price;
  final String description;
  final List<String> pdtImages;
  final DateTime timeAdded;
  final String uploaderUid;
  ProductModel({
    required this.pdtId,
    required this.name,
    required this.category,
    required this.price,
    required this.description,
    required this.pdtImages,
    required this.timeAdded,
    required this.uploaderUid,
  });

  ProductModel copyWith({
    String? pdtId,
    String? name,
    String? category,
    int? price,
    String? description,
    List<String>? pdtImages,
    DateTime? timeAdded,
    String? uploaderUid,
  }) {
    return ProductModel(
      pdtId: pdtId ?? this.pdtId,
      name: name ?? this.name,
      category: category ?? this.category,
      price: price ?? this.price,
      description: description ?? this.description,
      pdtImages: pdtImages ?? this.pdtImages,
      timeAdded: timeAdded ?? this.timeAdded,
      uploaderUid: uploaderUid ?? this.uploaderUid,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'pdtId': pdtId,
      'name': name,
      'category': category,
      'price': price,
      'description': description,
      'pdtImages': pdtImages,
      'timeAdded': timeAdded.millisecondsSinceEpoch,
      "uploaderUid": uploaderUid,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      pdtId: map['pdtId'] as String,
      name: map['name'] as String,
      category: map['category'] as String,
      price: map['price'] as int,
      description: map['description'] as String,
      pdtImages: List<String>.from((map['pdtImages'] as List<String>)),
      timeAdded: DateTime.fromMillisecondsSinceEpoch(map['timeAdded']),
      uploaderUid: map["uploaderUid"] as String,
    );
  }
}




//   ProductModel({
//     required this.pdtId,
//     required this.name,
//     required this.category,
//     required this.price,
//     required this.description,
//     required this.pdtImages,
//     required this.timestamp,
//   });

//   ProductModel copyWith({
//     String? pdtId,
//     String? name,
//     String? category,
//     int? price,
//     String? description,
//     List<String>? pdtImages,
//     Timestamp? timestamp,
//   }) {
//     return ProductModel(
//       pdtId: pdtId ?? this.pdtId,
//       name: name ?? this.name,
//       category: category ?? this.category,
//       price: price ?? this.price,
//       description: description ?? this.description,
//       pdtImages: pdtImages ?? this.pdtImages,
//       timestamp: timestamp ?? this.timestamp,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       "pdtId": pdtId,
//       'name': name,
//       'category': category,
//       'price': price,
//       'description': description,
//       'pdtImages': pdtImages,
//       'timestamp': timestamp,
//     };
//   }

//   factory ProductModel.fromMap(Map<String, dynamic> map) {
//     return ProductModel(
//       pdtId: map["pdtId"] as String,
//       name: map['name'] as String,
//       category: map['category'] as String,
//       price: map['price'] as int,
//       description: map['description'] as String,
//       pdtImages: List<String>.from(
//         (map['pdtImages'] as List<String>),
//       ),
//       timestamp: map["timestamp"],
//     );
//   }
// }
