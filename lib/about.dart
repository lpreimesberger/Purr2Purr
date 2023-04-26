import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build (BuildContext ctxt) {
    const st = TextStyle(color: Colors.white, fontSize: 20, overflow: TextOverflow.visible, );
    return Scaffold(
        appBar: AppBar(
          title: const Text("About"),
        ),
        body: Column(  crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.start,

          children:  [
          SizedBox(
            height: 50,
          ),
  Center(
    child:Text(style: st, "We are not permitted to preannounce events before gate open."),
  ),

          SizedBox(
            height: 50,
          ),

          Text(style: st, "This is an open source product."),
          Text(style: st, "Commercial use is forbidden and all code is GPLv3"),

        ],)
    );
  }
}