import 'package:flutter/material.dart';
import 'package:salpak/news.dart';
import 'package:salpak/newsfeed.dart';
import 'package:salpak/saved_news.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  static List<Widget> tabWidgets = <Widget>[NewsPage(), SavedNews()];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("News")),
      body: Center(child: tabWidgets.elementAt(selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.red,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            //backgroundColor: Colors.orange,
            icon: Icon(
              Icons.new_releases,
            ),
            label: 'News',
          ),
          BottomNavigationBarItem(
            //backgroundColor: Colors.red,
            icon: Icon(Icons.saved_search),
            label: 'Saved',
          ),
        ],
        currentIndex: selectedIndex,
        onTap: (index) => setState(() => selectedIndex = index),
      ),
    );
  }
}
