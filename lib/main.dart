import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Album {
  String? userId;
  int? id;
  String? title;

  Album({this.userId, this.id, this.title});

  Album.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    id = json['id'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['id'] = this.id;
    data['title'] = this.title;
    return data;
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
  int count=0;

  List<Album> albums =[];

  Future<List<Album>> _getAlbums() async{

    final response = await http.get(Uri.parse('https://ifri.raycash.net/getalbum/50'));
      var jsons = json.decode(response.body);
      setState(() {
        for(var i in jsons){
          count=jsons.length;
          albums.add(Album.fromJson(i));
        }
      });

      return albums;
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
        body: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: albums.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("UserId : "+albums[index].userId.toString()),
                  Text("Id : "+albums[index].id.toString()),
                  Text("Title : "+albums[index].title.toString()),
                  SizedBox(height:40),
                ],
              );
            }),
      ),
    );
  }
}