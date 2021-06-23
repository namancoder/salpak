import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:salpak/saved_news.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'news.dart';

Future<List<News>> fetchNews() async {
  final response =
      await http.get(Uri.parse("https://api.first.org/data/v1/news"));

  if (response.statusCode == 200) {
    print(response.body);
    var list = json.decode(response.body);
    var ero = list["data"];
    List<News> pikachu = [];
    print("list.length");
    int i = 0;
    print(ero.length);
    for (var u in ero) {
      print("$i");
      i++;
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

class NewsPage extends StatefulWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  //late Future<List<News>> futureNews;
  int selectedIndex = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // futureNews = fetchNews();
    // print("FUTURE NEWS");
    // print(futureNews.toString());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("News"),
      ),
      body: selectedIndex == 0 ? futurexx() : SavedNews(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.new_releases),
            label: 'News',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.saved_search),
            label: 'Saved',
          ),
        ],
        currentIndex: selectedIndex,
        onTap: (index) =>
            setState(() => selectedIndex = selectedIndex == 0 ? 1 : 0),
      ),
    );
  }
}

Widget futurexx() {
  return FutureBuilder<List<News>>(
      future: fetchNews(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print(snapshot.data);
          //print(snapshot.data.length.toString());
          return ListView.builder(
              padding: EdgeInsets.all(8.0),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: IconButton(
                    icon: Icon(Icons.saved_search_outlined),
                    onPressed: () {
                      _addtoList() async {
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        int counter = (prefs.getInt('counter')??0)
                      }
                      
                    },
                  ),
                  title: Text(
                    snapshot.data![index].title,
                    maxLines: 2,
                  ),
                  subtitle: Text(
                    snapshot.data![index].summary,
                    maxLines: 2,
                  ),
                );
              });
        } else {
          return Center(child: CircularProgressIndicator());
        }
      });
}
