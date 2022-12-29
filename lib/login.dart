import 'package:flutter/material.dart';

import 'name.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

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
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the LoginPage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text("Purr2Purr 'Login'"),
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
              Container(color: Colors.white70, height: 400, width: 400, child: Column(children: [
                 const Text("Greetings Burner!"),
                 const Text("Purr2Purr uses a 'username' to let you interact with camps and artwork.  We have chosen a random playa name for you.  Use it or another one - doesn't matter a bit.  We like you just as you are."),
                 const Text("Your phone has a unique ID you can see under settings that is your real identity."),
                 const Text("Just want the schedule?  Forget about it.  Punch Login and get on with it."),
                TextFormField(
                  initialValue: getName(),
style: const TextStyle(backgroundColor: Colors.grey),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter a Playa Name',
                  ),
                ),
                OutlinedButton(
                  onPressed: (){},
                  child: const Text('Login'),
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
