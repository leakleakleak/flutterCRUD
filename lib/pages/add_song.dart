import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

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
                TextFormField(
                  controller: controllerSongName,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a text';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _name = value ?? '';
                  },
                  decoration: const InputDecoration(
                    labelText: 'Song Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),
                //-----------------------ALBUM NAME
                TextFormField(
                  controller: controllerSongAlbum,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a text';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Album Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                //-----------------------RELEASE DATE
                const SizedBox(height: 24),
                DateTimeFormField(
                  mode: DateTimeFieldPickerMode.date,
                  dateFormat: DateFormat.yMd(),
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a date';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Release Date',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.event_note),
                  ),
                  onDateSelected: (DateTime value) {
                    setState(() {
                      dateTime = value;
                    });
                  },
                ),
                const SizedBox(height: 35),
                SizedBox(
                  height: 35,
                  child: ElevatedButton(
                    child: const Text('Create'),
                    onPressed: () {
                      if (formKey.currentState?.validate() == true) {
                        formKey.currentState!.save();
                        DateTime selectedDate = dateTime!;
                        final user = Song(
                            songName: controllerSongName.text,
                            albumName: controllerSongAlbum.text,
                            releaseDate: selectedDate);
                        createUser(user);
                        Navigator.pop(context);
                        Fluttertoast.showToast(
                            msg: 'Added Succesfully!',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            webPosition: 'center',
                            backgroundColor: Colors.blue);
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
