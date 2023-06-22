import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todolist_crud/widgets/custom_datepicker.dart';

import '../model/song.dart';
import '../widgets/custom_textformfield.dart';

class EditSongPage extends StatefulWidget {
  final String songID;
  final String songName;
  final String albumName;
  final DateTime releaseDate;
  const EditSongPage(
      {super.key,
      required this.songName,
      required this.albumName,
      required this.releaseDate,
      required this.songID});

  @override
  State<EditSongPage> createState() => _EditSongPage();
}

class _EditSongPage extends State<EditSongPage> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController controllerSongName;
  late TextEditingController controllerSongAlbum;
  late DateTime? dateTime;
  late String songID;

  @override
  void initState() {
    super.initState();
    controllerSongName = TextEditingController(text: widget.songName);
    controllerSongAlbum = TextEditingController(text: widget.albumName);
    dateTime = widget.releaseDate;
    songID = widget.songID;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Song'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Form(
            key: formKey,
            child: Column(
              children: [
                CustomeTextFormField(
                  controller: controllerSongName,
                  textLabel: 'Song Name',
                ),
                const SizedBox(height: 24),
                //-----------------------ALBUM NAME
                CustomeTextFormField(
                  controller: controllerSongAlbum,
                  textLabel: 'Album Name',
                ),
                const SizedBox(height: 24),
                CustomDatePicker(hasInitialDate: dateTime),
                const SizedBox(height: 35),
                SizedBox(
                  height: 35,
                  child: ElevatedButton(
                    child: const Text('Update'),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        DateTime selectedDate = dateTime!;
                        final user = Song(
                            songName: controllerSongName.text,
                            albumName: controllerSongAlbum.text,
                            releaseDate: selectedDate);
                        editSong(user, songID);
                        Navigator.pop(context);
                        Fluttertoast.showToast(
                            msg: 'Edited Succesfully',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            webPosition: 'center',
                            backgroundColor: Colors.blue);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future editSong(Song song, songID) async {
    //instantiate new collection 'Song'
    final docSong = FirebaseFirestore.instance.collection('songs').doc(songID);
    //get the instantiated collection id and pass the value to Song.id
    song.id = docSong.id;
    //convert to json
    final json = song.toJson();
    //submit to firebase
    await docSong.set(json);
  }
}
