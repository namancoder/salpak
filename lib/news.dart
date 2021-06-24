// To parse this JSON data, do
//
//     final news = newsFromMap(jsonString);

import 'dart:convert';

List<News> newsFromMap(String str) =>
    List<News>.from(json.decode(str).map((x) => News.fromMap(x)));

String newsToMap(List<News> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class News {
  News({
    required this.id,
    required this.title,
    required this.summary,
    required this.link,
    required this.published,
  });

  int id;
  String title = " ";
  String summary = " ";
  String link = " ";
  String published = " ";

  factory News.fromMap(Map<String, dynamic> json) => News(
        id: json["id"] == null ? null : json["id"],
        title: json["title"] == null ? null : json["title"],
        summary: json["summary"] == null ? null : json["summary"],
        link: json["link"] == null ? null : json["link"],
        published: json["published"] == null ? null : json["published"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "summary": summary,
        "link": link,
        "published": published,
      };
}
