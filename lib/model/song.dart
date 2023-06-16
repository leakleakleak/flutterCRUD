import 'package:cloud_firestore/cloud_firestore.dart';

class Song {
  String id;
  final String songName;
  final String albumName;
  final DateTime releaseDate;

  Song({
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

  static Song fromJson(Map<String, dynamic> json) => Song(
        id: json['id'],
        songName: json['songName'],
        albumName: json['albumName'],
        releaseDate: (json['releaseDate'] as Timestamp).toDate(),
      );
}
