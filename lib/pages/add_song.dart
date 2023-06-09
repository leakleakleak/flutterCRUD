import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/user.dart';

class AddSongPage extends StatefulWidget {
  const AddSongPage({super.key});

  @override
  State<AddSongPage> createState() => _AddSongPage();
}

class _AddSongPage extends State<AddSongPage> {
  DateTime? dateTime;
  final controllerSongName = TextEditingController();
  final controllerSongAlbum = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Song'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          TextField(
            controller: controllerSongName,
            decoration: InputDecoration(
                labelText: 'Song Name', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: controllerSongAlbum,
            decoration: InputDecoration(
                labelText: 'Album', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 24),
          DateTimeFormField(
            mode: DateTimeFieldPickerMode.date,
            dateFormat: DateFormat.yMd(),
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
                //converting the null aware data type to a standard data type
                DateTime selectedDate = dateTime!;
                if (selectedDate != null) {
                  final user = User(
                      songName: controllerSongName.text,
                      albumName: controllerSongAlbum.text,
                      releaseDate: selectedDate);
                  createUser(user);
                }
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Future createUser(User user) async {
    //instantiate new collection 'user'
    final docUser = FirebaseFirestore.instance.collection('songs').doc();
    //get the instantiated collection id and pass it to user.id
    user.id = docUser.id;
    //convert to json
    final json = user.toJson();
    //submit to firebase
    await docUser.set(json);
  }
}
