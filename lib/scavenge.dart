import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:convert/convert.dart';
import 'package:shared_preferences/shared_preferences.dart';

/*
  this is the pokemon page - we want to let people 'capture' other
  hoomans or artwork in their 2023 purrse

 */
class ScavengePage extends StatefulWidget {
  const ScavengePage({super.key, required this.title});

  final String title;

  @override
  State<ScavengePage> createState() => _ScavengePageState();
}

class _ScavengePageState extends State<ScavengePage> {
  late SharedPreferences prefs;
  ValueNotifier<dynamic> result = ValueNotifier(null);
  List<String> found = [];

  init() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      var x = prefs.getStringList('found2023');
      if (x != null) {
        found = x;
      }
    });
  }

  _ScavengePageState() {
    init();
  }

  Widget _myListView(BuildContext context) {
    return ListView.separated(
      itemCount: found.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(found[index]),
          tileColor:
              found[index].contains('hooman') ? Colors.grey : Colors.deepPurple,
          leading: found[index].contains('hooman')
              ? const Icon(Icons.person)
              : const Icon(Icons.house_outlined),
        );
      },
      separatorBuilder: (context, index) {
        return const Divider();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            title: const Text('Your Purrse'), backgroundColor: Colors.black),
        backgroundColor: Colors.black,
        body: SafeArea(
          child: FutureBuilder<bool>(
            future: NfcManager.instance.isAvailable(),
            builder: (context, ss) => ss.data != true
                ? const Center(child: Text('Oops - no NFC scanner found :('))
                : Flex(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    direction: Axis.vertical,
                    children: [
                      Flexible(
                        flex: 10,
                        child: _myListView(context),
                      ),
                      Flexible(
                        flex: 3,
                        child: GridView.count(
                          padding: const EdgeInsets.all(4),
                          crossAxisCount: 1,
                          childAspectRatio: 6,
                          crossAxisSpacing: 4,
                          mainAxisSpacing: 1,
                          children: [
                            ElevatedButton(
                                onPressed: _tagRead,
                                child: const Text('Read Chip')),
                            ElevatedButton(
                                onPressed: _reset,
                                child: const Text('Clear database')),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  void _tagRead() {
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      // process this soup into something sensible
      result.value = tag.data;
      Ndef? ndef = Ndef.from(tag);
      if (ndef == null) {
        result.value = 'Tag is not compatible with NDEF';
        return;
      }
      var hooman = hex.encode(ndef.additionalData['identifier']);
      var poi = '';
      var loi = '';
      if (ndef.cachedMessage != null) {
        ndef.cachedMessage?.records.forEach((element) {
          // there are code/byte markers in front
          var swapBack = String.fromCharCodes(element.payload).substring(3);
          if (swapBack.startsWith("xnm:")) {
            poi = swapBack.substring(4);
          }
          if (swapBack.startsWith("loi:")) {
            loi = swapBack.substring(4);
          }
        });
      }
      result.value = "xid:$hooman\npoi:$poi\nloi:$loi\n";
      NfcManager.instance.stopSession();
      if (poi != '') {
        remember('hooman:$poi');
        popup('Woot!  You captured a wild $poi!');
      }
      if (loi != '') {
        remember('location:$loi');
        popup('Fuck yeah! $loi is yours!');
      }
    });
  }

  void remember(String thisMessage) async {
    if (found.contains(thisMessage)) {
      print("already found");
      return;
    }
    found.add(thisMessage);
    prefs.setStringList("found2023", found);
    setState(() {
      found = prefs.getStringList('found2023')!;
    });
    print(thisMessage);
  }

  Future<void> popup(String thisMessage) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('OMFG!'),
          content: SingleChildScrollView(
            child: ListBody(children: <Widget>[
              Text(thisMessage),
            ]),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Woo!'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _reset() async {
    found.clear();
    prefs.setStringList("found2023", []);
    setState(() {
      found = prefs.getStringList('found2023')!;
    });
  }
}
