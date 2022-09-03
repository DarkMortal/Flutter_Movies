import 'package:flutter/material.dart';
import 'package:desktop_app/ThemeProvider.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle heading = GoogleFonts.notoSans(
        textStyle:
            const TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold)),
    body = GoogleFonts.notoSans(
        textStyle:
            const TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold)),
    search = GoogleFonts.notoSans(
        textStyle:
            const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold));

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) => PopupMenuButton(
      itemBuilder: (context) => [
            PopupMenuItem(
                value: "Theme",
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Icon(
                        (Theme.of(context).brightness == Brightness.light)
                            ? (Icons.light_mode)
                            : (Icons.dark_mode),
                      ),
                    ),
                    const Text("Theme")
                  ],
                )),
            PopupMenuItem(
                value: "About",
                child: Row(
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(right: 10.0),
                      child: Icon(
                        Icons.info,
                      ),
                    ),
                    Text("About")
                  ],
                ))
          ],
      onSelected: (value) {
        if (value == "About") {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => About()));
        }
        if (value == "Theme") {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => ThemeChanger()));
        }
      });
}

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
          title: const Text("About"),
          centerTitle: true,
          backgroundColor: Colors.blue),
      body: const Center(
          child: Text(
        "A simple movie searching desktop app made in Flutter\nDeveloped by Saptarshi Dey",
        style: TextStyle(
          fontSize: 40.0,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      )));
}
