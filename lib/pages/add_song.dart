import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todolist_crud/widgets/custom_datepicker.dart';
import 'package:todolist_crud/widgets/custom_textformfield.dart';

import '../model/song.dart';

class AddSongPage extends StatefulWidget {
  const AddSongPage({super.key});

  @override
  State<AddSongPage> createState() => _AddSongPage();
}

class _AddSongPage extends State<AddSongPage> {
  final formKey = GlobalKey<FormState>();
  final controllerSongName = TextEditingController();
  final controllerSongAlbum = TextEditingController();

  DateTime? dateTime;
  String _name = '';

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
                //-----------------------SONG NAME
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
                //-----------------------RELEASE DATE
                const SizedBox(height: 24),
                const CustomDatePicker(),
                const SizedBox(height: 35),
                SizedBox(
                  height: 35,
                  child: ElevatedButton(
                    child: const Text('Create'),
                    onPressed: () {
                      if (formKey.currentState?.validate() == true) {
                        formKey.currentState!.save();
                        DateTime selectedDate = dateTime ?? DateTime.now();
                        final song = Song(
                            songName: controllerSongName.text,
                            albumName: controllerSongAlbum.text,
                            releaseDate: selectedDate);
                        createUser(song);
                        Navigator.pop(context);
                        Fluttertoast.showToast(
                            msg: 'Added Succesfully!',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            webPosition: 'center',
                            backgroundColor: Colors.blue);
                      } else {
                        Fluttertoast.showToast(
                            msg: 'Error!',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            webPosition: 'center',
                            backgroundColor: Colors.red);
                      }
                      //converting the null aware data type to a standard data type
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

  Future createUser(Song song) async {
    //instantiate new collection 'user'
    final docUser = FirebaseFirestore.instance.collection('songs').doc();
    //get the instantiated collection id and pass the value to user.id
    song.id = docUser.id;
    //convert to json
    final json = song.toJson();
    //submit to firebase
    await docUser.set(json);
  }
}
