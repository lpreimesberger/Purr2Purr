import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:purr2purr/name.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:purr2purr/login.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Purr2Purr',
      theme: ThemeData(
        primarySwatch: Colors.green,
        brightness: Brightness.dark,
        fontFamily: 'Courier',
//        colorScheme: ColorScheme.fromSwatch().copyWith(
          //secondary: Colors.green,
        //),

        textTheme: const TextTheme(
          headline1: TextStyle(fontSize: 42.0, fontWeight: FontWeight.bold,color: Colors.purple),
          headline6: TextStyle(fontSize: 16.0, fontStyle: FontStyle.italic,color: Colors.purple),
          bodyText2: TextStyle(fontSize: 14.0, color: Colors.black),
        ),
      ),
      home: const MyHomePage(title: 'Purr2Purr Console'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var uuid = "";        // global phone id - reset on reinstall
  var name = "";

  startupCheck() async {
    // see if the luser is 'logged in' or not
    final prefs = await SharedPreferences.getInstance();
    final String? savedID = prefs.getString("uuid");
    String? savedName = prefs.getString("name");
    // if we have no saved info - create and generate
    // this doesn't need interaction - let it go
    if(savedID == null){
      uuid = const Uuid().v4();
      prefs.setString("uuid", uuid);
    }
    // let them fix their name if it's bad by jumping to 'login'
    if(savedName == null){
      savedName = getName();
      prefs.setString("name", savedName!).then((value) => { toLogin() });
    }
  }

  @override
  void initState() {
    // in flutter - this is called once on initial page load
    super.initState();
    startupCheck();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            OutlinedButton(
              onPressed: toLogin,
              child: Text('Login'),
            ),
            MaterialButton(onPressed: toLogin, ),
          ],
        ),
      ),
    );
  }
  toLogin(){
    Navigator.push(context,
        PageTransition(
            alignment: Alignment.bottomCenter,
            curve: Curves.easeInOut,
            duration: Duration(milliseconds: 600),
            reverseDuration: Duration(milliseconds: 600),
            type: PageTransitionType.rightToLeftWithFade,
            child: LoginPage(title: '',),
            ));

  }
}


