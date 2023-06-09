import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String id;
  final String songName;
  final String albumName;
  final DateTime releaseDate;

  User({
    this.id = '',
    required this.songName,
    required this.albumName,
    required this.releaseDate,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'songName': songName,
        'albumName': albumName,
        'releaseDate': releaseDate,
      };

  static User fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        songName: json['songName'],
        albumName: json['albumName'],
        releaseDate: (json['releaseDate'] as Timestamp).toDate(),
      );
}
