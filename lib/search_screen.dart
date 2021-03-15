import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_practice/SearchDatamodel.dart';
import 'package:flutter_practice/details_populated_screen.dart';
import 'package:http/http.dart' as http;

class SearchScreen extends StatefulWidget {
  SearchScreen({Key key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<SearchDatamodel> users;
  String textapi = 'text';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("Hacker News"),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              child: TextField(
                decoration: InputDecoration(
                    border: InputBorder.none, hintText: 'Enter a search term'),
                onChanged: (text) {
                  setState(() {
                    this.textapi = text;
                    listwidget(textapi);
                  });
                },
              ),
            ),
            listwidget(textapi)
          ],
        ),
      ),
    );
  }

  Widget listwidget(String test) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: FutureBuilder(
        future: hackernews(test),
        builder: (BuildContext ctx, AsyncSnapshot snap) {
          if (snap.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return SizedBox(
              height: MediaQuery.of(context).size.height * .80,
              child: ListView.separated(
                itemCount: snap.data.length,
                separatorBuilder: (context, index) {
                  return Divider();
                },
                itemBuilder: (ctx, index) => ListTile(
                  title: Text(snap.data[index].title ?? 'null'),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => DetailsPopulatedScreen(
                            snap.data[index].title,
                            snap.data[index].objectID,
                            snap.data[index].points)));
                  },
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Future<List<SearchDatamodel>> hackernews(String search) async {
    String url = "http://hn.algolia.com/api/v1/search?query=${search}";
    var response = await http.get(url);
    var responseData = json.decode(response.body);
    print(responseData);
    List<SearchDatamodel> users = [];
    for (var singleUser in responseData['hits']) {
      print(singleUser['title']);
      SearchDatamodel data = new SearchDatamodel.searchscreen(
          singleUser['objectID'], singleUser['title'], singleUser['points']);
      if (singleUser['title'] != null) {
        users.add(data);
      }
    }
    print(users.length);
    return users;
  }
}
