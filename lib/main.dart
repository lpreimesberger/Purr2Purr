import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:purr2purr/events.dart';
import 'package:purr2purr/login.dart';
import 'package:purr2purr/state.dart';
import 'package:shared_value/shared_value.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;
import 'package:loading_indicator/loading_indicator.dart';

void main() {

  runApp(SharedValue.wrapApp(
    const MyApp(),
  ),);
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
  bool loading = true;

  startupCheck() async {
    // see if the user is 'logged in' or not
    io.Directory applicationDirectory = await getApplicationDocumentsDirectory();
    String openableDatabase = path.join(applicationDirectory.path, "p2p.db");
    bool openableDatabaseExists = await io.File(openableDatabase).exists();
    // load prefs/globals
    dbVersion.load();
    burnerName.load();
    phoneUUID.load();
    String data = await DefaultAssetBundle.of(context).loadString("assets/purr.json");
    final jsonResult = jsonDecode(data); //latest Dart
    // one of the oddities of mobile is we cant open the database directly from
    // assets, since it's a vfs inside the signed application zip
    if(
          dbVersion.$ < (jsonResult["db_version"] as double) || // cached db old
              ! openableDatabaseExists ){ // or just not there
        ByteData data = await rootBundle.load(path.join("assets", "p2p.db"));
        List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
        await io.File(openableDatabase).writeAsBytes(bytes, flush: true);
        dbVersion.$ = (jsonResult["db_version"] as double);
        dbVersion.save();

    }
    setState(() {
      loading = false;
    });
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
        child: loading ? const LoadingIndicator(
            indicatorType: Indicator.ballPulse, /// Required, The loading type of the widget
            colors: const [Colors.white],       /// Optional, The color collections
            strokeWidth: 2,                     /// Optional, The stroke of the line, only applicable to widget which contains line
            backgroundColor: Colors.black,      /// Optional, Background of the widget
            pathBackgroundColor: Colors.black   /// Optional, the stroke backgroundColor
        ) : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            OutlinedButton(
              onPressed: toLogin,
              child: const Text('Login'),
            ),
            MaterialButton(onPressed: toLogin, ),
            OutlinedButton(
              onPressed: toEvents,
              child: const Text('Events'),
            ),
            MaterialButton(onPressed: toEvents, ),

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
            duration: const Duration(milliseconds: 600),
            reverseDuration: const Duration(milliseconds: 600),
            type: PageTransitionType.rightToLeftWithFade,
            child: const LoginPage(title: '',),
            ));

  }

  toEvents(){
    Navigator.push(context,
        PageTransition(
          alignment: Alignment.bottomCenter,
          curve: Curves.easeInOut,
          duration: const Duration(milliseconds: 600),
          reverseDuration: const Duration(milliseconds: 600),
          type: PageTransitionType.rightToLeftWithFade,
          child: const EventsPage(title: '',),
        ));

  }

}


