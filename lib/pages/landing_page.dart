import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:todolist_crud/model/song.dart';
import 'package:todolist_crud/pages/add_song.dart';
import 'package:todolist_crud/pages/edit_song.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Carly Rae Jepsen Songs')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('songs').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              String title = '${data['albumName']} || ${data['songName']}';
              Timestamp subtitle = data['releaseDate'];

              return ListTile(
                leading: const CircleAvatar(child: Text('#')),
                title: Text(title),
                subtitle: Text(DateFormat('yMd').format(subtitle.toDate())),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return EditSongPage(
                              songName: data['songName'],
                              albumName: data['albumName'],
                              releaseDate: subtitle.toDate(),
                              songID: data['id'],
                            );
                          },
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        deleteSong(data['id']);
                        Fluttertoast.showToast(
                            msg:
                                'The Song ${data['songName']} is succesfully Deleted!',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            webPosition: 'center',
                            backgroundColor: Colors.blue);
                      },
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return const AddSongPage();
              });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  deleteSong(songID) async {
    //instantiate new collection 'song'
    final docSong = FirebaseFirestore.instance.collection('songs').doc(songID);
    //get the instantiated collection id and pass the value to song.id

    //submit to firebase
    await docSong.delete();
  }

  //get data from firebase
  Stream<List<Song>> readUsers() => FirebaseFirestore.instance
      .collection('songs')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Song.fromJson(doc.data())).toList());
}
