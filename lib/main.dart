import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Album {
  final int userId;
  final int id;
  final String title;

  const Album({
    required this.userId,
    required this.id,
    required this.title,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
    );
  }
}

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool loading = true;

  List<Album> albums =[];

  Future<List<Album>> _getAlbums() async{

    final response = await http
        .get(Uri.parse('https://ifri.raycash.net/getalbum/50'));

    if (response.statusCode == 200) {
      var jsons = json.decode(response.body);

      for(var i in jsons){
        albums.add(Album(userId: i['userId'], id: i['id'], title: i['title']));
      }

      loading =false;
      return albums;

    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }


  }

  @override
  void initState() {
    super.initState();
    _getAlbums();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Fetch Data from API'),
        ),
        body: Center(
          child:ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: albums.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("UserId : "+albums[index].userId.toString()),
                    Text("Id : "+albums[index].id.toString()),
                    Text("Title : "+albums[index].title),

                    SizedBox(height:40),
                  ],
                );
              }),
        ),
      ),
    );
  }
}