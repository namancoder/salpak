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

class NewsPage extends StatefulWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  int selectedIndex = 0;
  late SharedPreferences prefs;
  List<String> list = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSharedPreferences();

    setState(() {});
  }

  initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    list = prefs.getStringList('list')!;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
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
        onTap: (index) => setState(() => selectedIndex = index == 0 ? 0 : 1),
      ),
    );
  }

  Widget futurexx() {
    return FutureBuilder<List<News>>(
        future: fetchNews(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                padding: EdgeInsets.all(8.0),
                itemCount: snapshot.data!.length,
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
                      leading: IconButton(
                        icon: (list.indexOf(index.toString()) >= 0)
                            ? Image.asset("assets/redheart.png",
                                width: 24.0, height: 24.0)
                            : Image.asset("assets/whiteheart.png",
                                width: 24.0, height: 24.0),
                        onPressed: () {
                          print("$index  is pressed");
                          if (list.indexOf(index.toString()) >= 0)
                            _remove(index);
                          else
                            _addtoList(index);

                          setState(() {});
                        },
                      ),
                      title: Text(
                        snapshot.data![index].title,
                        maxLines: 2,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            snapshot.data![index].summary,
                            maxLines: 2,
                          )
                          ,
                          SizedBox(height:5.0),  Text(
                            snapshot.data![index].published,
                            style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.w200),
                          ),
                        ],
                      ),
                    ),
                  );
                });
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Future _addtoList(int value) async {
    if (list.indexOf(value.toString()) >= 0) {
    } else
      list.add(value.toString());
    prefs.setStringList("list", list);
    print(list.length);
  }

  Future _remove(int index) async {
    list = prefs.getStringList('list')!;
    print("BEFORE");
    print(list.length);
    print(list.toString());
    list.removeWhere((element) => element == list[index]);
    prefs.setStringList('list', list);
    print(list.length);
    //setState(() {});
  }
}
