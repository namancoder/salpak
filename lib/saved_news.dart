import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'news.dart';

Future<List<News>> fetchNews() async {
  final response =
      await http.get(Uri.parse("https://api.first.org/data/v1/news"));

  if (response.statusCode == 200) {
    var list = json.decode(response.body);
    var ero = list["data"];
    List<News> pikachu = [];
    print("list.length");
    print(ero.length);
    for (var u in ero) {
      News news = News(
        id: u["id"] == null ? null : u["id"],
        title: u["title"] == null ? " " : u["title"],
        summary: u["summary"] == null ? " " : u["summary"],
        link: u["link"] == null ? " " : u["link"],
        published: u["published"] == null ? " " : u["published"],
      );

      pikachu.add(news);
    }
    print(pikachu.length);

    return pikachu;
  } else
    throw Exception("Request API Error");
}

class SavedNews extends StatefulWidget {
  const SavedNews({Key? key}) : super(key: key);

  @override
  _SavedNewsState createState() => _SavedNewsState();
}

class _SavedNewsState extends State<SavedNews> {
  late SharedPreferences prefs;
  late List<String> list = [];
  @override
  void initState() {
    // TODO: implement initState
    loadSharedPreferences();
    super.initState();
  }

  loadSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<News>>(
        future: fetchNews(),
        builder: (context, snapshot) {
          if (snapshot.hasData && list.length > 0) {
            //print(snapshot.data);
            //print(snapshot.data.length.toString());
            return ListView.builder(
                padding: EdgeInsets.all(8.0),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  return Container(
                     margin: EdgeInsets.all(8.0),
                    padding: EdgeInsets.all(8.0),
                     decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    color: Color.fromRGBO(0, 0, 0, .3),
                                    blurRadius: 20,
                                    offset: Offset(0, 10))
                              ]),
                    child: ListTile(
                      // leading: IconButton(
                      //   icon: Icon(Icons.delete, color: Colors.red,),
                      //   onPressed: () async {
                      //     print(list[index] + "is remove");
                      //     _remove(index);
                      //     setState(() {});
                      //         print(list.toString());

                      //   },
                      // ),
                      title: Text(
                        snapshot.data![int.parse(list[index])].title,
                        maxLines: 2,
                      ),
                      subtitle: Text(
                        snapshot.data![int.parse(list[index])].summary,
                        maxLines: 2,
                      ),
                    ),
                  );
                });
          } else if (list.length != 0) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Center(child: Text("No saved Articles"));
          }
        });
  }

  loadData() {
    list = prefs.getStringList('list')!;

    setState(() {});
  }

  _remove(int index) {
    list = prefs.getStringList('list')!;
    print("BEFORE");
    print(list.length);
    print(list.toString());
    list.removeWhere((element) => element == list[index]);
    prefs.setStringList('list', list);
    print(list.length);
    setState(() {
      initState();
    });
  }
}
