import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todolist_crud/model/user.dart';

import 'add_song.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Carly Rae Jepsen Songs')),
      body: StreamBuilder<List<User>>(
        stream: readUsers(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final users = snapshot.data!;
            return ListView(
              children: users.map(buildUser).toList(),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return const AddSongPage();
              });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget buildUser(User user) => ListTile(
        leading: Text(
          'Album: ${user.albumName}',
        ),
        title: Text(user.songName),
        subtitle:
            Text('Release Date: ${DateFormat('yMd').format(user.releaseDate)}'),
      );

  Stream<List<User>> readUsers() => FirebaseFirestore.instance
      .collection('songs')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => User.fromJson(doc.data())).toList());
}
