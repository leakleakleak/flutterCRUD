import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '../model/user.dart';

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
                TextFormField(
                  controller: controllerSongName,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a text';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      labelText: 'Song Name', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: controllerSongAlbum,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a text';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      labelText: 'Album', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 24),
                DateTimeFormField(
                  initialDate: dateTime,
                  initialValue: dateTime,
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
                    child: const Text('Update'),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        DateTime selectedDate = dateTime!;
                        if (selectedDate != null) {
                          final user = User(
                              songName: controllerSongName.text,
                              albumName: controllerSongAlbum.text,
                              releaseDate: selectedDate);
                          editUser(user, songID);
                        }
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

  Future editUser(User user, songID) async {
    //instantiate new collection 'user'
    final docUser = FirebaseFirestore.instance.collection('songs').doc(songID);
    //get the instantiated collection id and pass the value to user.id
    user.id = docUser.id;
    //convert to json
    final json = user.toJson();
    //submit to firebase
    await docUser.set(json);
  }
}
