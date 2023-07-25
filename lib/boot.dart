import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'events.dart';
import 'name.dart';

class BootPage extends StatefulWidget {
  const BootPage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<BootPage> createState() => _BootPageState();
}

class _BootPageState extends State<BootPage> {

  Widget bottomWidget(double screenWidth) {
    return Container(
      width: 1.5 * screenWidth,
      height: 1.5 * screenWidth,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment(0.6, -1.1),
          end: Alignment(0.7, 0.8),
          colors: [
            Color(0xDB4BE8CC),
            Color(0x005CDBCF),
          ],
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    const st = TextStyle(color: Colors.white, fontSize: 20, overflow: TextOverflow.visible, );
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the LoginPage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text("Woot 2023!"),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(image: AssetImage("assets/dust.png"), fit: BoxFit.cover,),
            ),
          ),
          Center(

            child: Column( children: [
              Container(color: Colors.black, height: 400, width: 400, margin: EdgeInsets.all(50.0), child: const Column( children: [
                 Text(style: st,"Greetings Burner!"),
                Align(
                  alignment: Alignment.center, // Align however you like (i.e .centerRight, centerLeft)
                  child: Text(style: st, "Per da rulez - we cannot break embargo on 2023 events until gate open.  The app will unlock WHEN THE GATE OPENS."),
                ),


              ],)),

            ],
     )
          )
        ],
      )
    );
  }
}

toLogin(){

}
