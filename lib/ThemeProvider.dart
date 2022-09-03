import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeBuilder extends StatefulWidget{
  late Widget Function(BuildContext,ThemeMode) widgetBuilder;
  ThemeBuilder({required this.widgetBuilder});
  @override
  ThemeState createState() => ThemeState();
  static ThemeState? of (BuildContext context){
    return context.findAncestorStateOfType<ThemeState>();
  }
}

class ThemeState extends State<ThemeBuilder>{
  ThemeMode theme = ThemeMode.system;
  int? themeValue = 0;

  void getTheme() async{
    final SharedPreferences pref = await SharedPreferences.getInstance();
    setState((){
      themeValue = pref.getInt("Theme");
      if(themeValue == 1) theme = ThemeMode.light;
      if(themeValue == 2) theme = ThemeMode.dark;
      if(themeValue == 3) theme = ThemeMode.system;
    });
  }

  @override void initState() {
    super.initState();
    getTheme();
  }
  void changeTheme(ThemeMode value){
    setState((){
      theme = value;
      if(value == ThemeMode.light) themeValue = 1;
      else if(value == ThemeMode.dark) themeValue = 2;
      else if(value == ThemeMode.system) themeValue = 3;
    });
  }
  @override
  Widget build(BuildContext context) =>
      widget.widgetBuilder(context,theme);
}

class ThemeChanger extends StatefulWidget{
  @override
  ThemeChangeState createState() => ThemeChangeState();
}

class ThemeChangeState extends State<ThemeChanger> {
  int? _value = 0;
  @override void initState(){
    super.initState();
    _value = ThemeBuilder.of(context)?.themeValue;
  }
  @override
  Widget build(BuildContext context) =>
      Scaffold(
          appBar: AppBar(
              title: const Text("Choose a Theme"),
              centerTitle: true,
              backgroundColor: Colors.blue),
          body: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Radio(
                          value: 1,
                          groupValue: _value,
                          onChanged: (value){
                            ThemeBuilder.of(context)?.changeTheme(ThemeMode.light);
                            setState((){
                              _value = (value == 1)?1:_value;
                            });
                          }
                      ),
                      const SizedBox(width: 5.0,),
                      const Text("Light", style: TextStyle(fontSize: 17.0))
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                          value: 2,
                          groupValue: _value,
                          onChanged: (value){
                            ThemeBuilder.of(context)?.changeTheme(ThemeMode.dark);
                            setState((){
                              _value = (value == 2)?2:_value;
                            });
                          }
                      ),
                      const SizedBox(width: 5.0,),
                      const Text("Dark", style: TextStyle(fontSize: 17.0))
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                          value: 3,
                          groupValue: _value,
                          onChanged: (value){
                            ThemeBuilder.of(context)?.changeTheme(ThemeMode.system);
                            setState((){
                              _value = (value == 3)?3:_value;
                            });
                          }
                      ),
                      const SizedBox(width: 5.0,),
                      const Text("System", style: TextStyle(fontSize: 17.0))
                    ],
                  ),
                  Center(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.blue.shade500,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            textStyle: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold)
                        ),
                        onPressed: () async {
                          //TODO: Save the theme in Shared Preferences
                          int? x = ThemeBuilder.of(context)?.themeValue;
                          final SharedPreferences pref = await SharedPreferences.getInstance();
                          pref.setInt("Theme",(x != null)?x:0);
                          Fluttertoast.showToast(
                            msg: "Theme Preferences Saved",
                            fontSize: 18,
                          );
                        },
                        child: const Text("Save")
                    ),
                  )
                ],
              )
          )
      );
}