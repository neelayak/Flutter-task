import 'package:flutter/material.dart';
import 'package:flutter_practice/SearchDatamodel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DetailsPopulatedScreen extends StatefulWidget {
  String title, objectID;
  int points;

  DetailsPopulatedScreen(this.title, this.objectID, this.points);

  @override
  _DetailsPopulatedScreenState createState() =>
      _DetailsPopulatedScreenState(title, objectID, points);
}

class _DetailsPopulatedScreenState extends State<DetailsPopulatedScreen> {
  String title, objectID;
  int points;

  _DetailsPopulatedScreenState(this.title, this.objectID, this.points);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Column(
        children: [
          Text(
            'Points :${points}',
            style: TextStyle(fontSize: 20.0),
          ),
          Container(
            padding: EdgeInsets.all(16.0),
            child: FutureBuilder(
              future: hackernewspopulate(),
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
                          title: Text(
                        snap.data[index].text,
                        maxLines: 2,
                      )),
                    ),
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    print(hackernewspopulate().toString());
  }

  Future<List<SearchDatamodel>> hackernewspopulate() async {
    String url = "http://hn.algolia.com/api/v1/items/${objectID}";
    var response = await http.get(url);
    var responseData = json.decode(response.body);

    print(responseData);
    List<SearchDatamodel> users = [];
    for (var singleUser in responseData['children']) {
      SearchDatamodel data = new SearchDatamodel.populate(singleUser['text']);
      print(singleUser['text']);
      if (singleUser['text'] != null) {
        users.add(data);
      }
    }
    print(users.length);
    return users;
  }
}
