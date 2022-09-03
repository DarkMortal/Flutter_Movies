import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:desktop_app/Components/Items.dart';
import 'package:desktop_app/Shows.dart';

Future<http.Response> fetchShow(String name) {
  return http.get(Uri.parse('https://api.tvmaze.com/search/shows?q=$name'));
}

final List<Color> colorArr = [Colors.green, Colors.red, Colors.blue];

Color randomColor() {
  Random random = Random();
  return colorArr[random.nextInt(3)];
}

final FutureOr<Set<void>> err = {};

class Homepage extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

final textController = TextEditingController();

class HomeState extends State<Homepage> {
  List<Show> showList = [];
  String viewText = "Try searching for a movie";
  dynamic resBody = {};
  String title = "", body = "", image = "";

  @override
  void initState() {
    super.initState();
    showList = <Show>[];
    viewText = "Try searching for a movie";
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text("Flutter API"),
          centerTitle: true,
          backgroundColor: Colors.blue,
          actions: [
            Theme(
                data: Theme.of(context).copyWith(
                  iconTheme: Theme.of(context).iconTheme,
                  textTheme: Theme.of(context).textTheme,
                ),
                child: Settings())
          ],
        ),
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: textController,
                    decoration: InputDecoration(
                        hintText: "Search a movie",
                        labelText: "Movie Name",
                        labelStyle: search),
                    maxLength: 100,
                  ),
                ),
                for (Show sh in showList)
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    color: randomColor(),
                    child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          //crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Image.network(sh.imageURL,
                                  errorBuilder:
                                      (context, exception, stackTrace) =>
                                          Text('No Image Found')),
                            ),
                            Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Html(
                                  data: """
                              <div style="color: white; width: 800px">
                                <h1 style="margin: auto; width:fit-content; font-size: 2rem;"><u>${sh.title}</u></h1>
                                <h1 style="margin: auto; width:fit-content; font-size: 1.5rem;">${sh.body}</h1>
                                <h2 style="margin: auto; width:fit-content; font-size: 1.5rem;">Genres : ${sh.genres()}</h2>
                              </div>
                            """,
                                )),
                          ],
                        )),
                  ),
                if (showList.isEmpty)
                  Text(
                    viewText,
                    style: heading,
                  )
              ],
            )),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (textController.text == "")
              setState(() {
                showList.clear();
                viewText = "Please Enter some Text";
              });
            else {
              setState(() {
                showList.clear();
                viewText = "Searching...";
              });
              fetchShow(textController.text)
                  .then((res) => {
                        resBody = jsonDecode(res.body),
                        if (resBody.isEmpty)
                          setState(() {
                            viewText = "No movies found :(";
                          })
                        else
                          {
                            for (dynamic i in resBody)
                              {
                                title = (i['show']['name'] != null)
                                    ? i['show']['name']
                                    : "",
                                body = (i['show']['summary'] != null)
                                    ? i['show']['summary']
                                    : "",
                                image = (i['show']['image'] != null)
                                    ? i['show']['image']['medium']
                                    : "",
                                showList.add(Show(
                                    title, body, image, i['show']['genres']))
                              },
                            setState((() {
                              //showList = showList;
                            }))
                          }
                      })
                  .catchError((Object e, StackTrace stackTrace) {
                //print(e.toString());
                return err;
              });
            }
          },
          backgroundColor: Colors.amber,
          child: const Icon(Icons.search),
        ),
      );
}
