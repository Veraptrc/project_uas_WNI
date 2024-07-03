import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  Post({required this.image, required this.description});

  Post.fromJson(Map<String, Object?> json)
      : this(
    image: json['image']! as String,
    description: json['description']! as String,
  );

  final String image;
  final String description;

  Map<String, Object?> toJson() {
    return {
      'image': image,
      'description': description,
    };
  }
}

final postCollection =
FirebaseFirestore.instance.collection('post').withConverter<Post>(
  fromFirestore: (snapshot, _) => Post.fromJson(snapshot.data()!),
  toFirestore: (post, _) => post.toJson(),
);