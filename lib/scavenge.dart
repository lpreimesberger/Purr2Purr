import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:convert/convert.dart';

class ScavengePage extends StatefulWidget {
  const ScavengePage({super.key, required this.title});

  final String title;

  @override
  State<ScavengePage> createState() => _ScavengePageState();
}

class _ScavengePageState extends State<ScavengePage> {

  ValueNotifier<dynamic> result = ValueNotifier(null);
  final _formKey = GlobalKey<FormState>();
  String playaName = '';
  String emailAddress = '';

  var pattern = '[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}';


  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Purr2Purr NFC Helper')),
        body: SafeArea(
          child: FutureBuilder<bool>(
            future: NfcManager.instance.isAvailable(),
            builder: (context, ss) => ss.data != true
                ? Center(child: Text('NfcManager.isAvailable(): ${ss.data}'))
                : Flex(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              direction: Axis.vertical,
              children: [
                Form(
                    key: _formKey,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            // The validator receives the text that the user has entered.
                            decoration: const InputDecoration(
                              icon: Icon(Icons.person),
                              hintText: 'Playa Name?',
                              labelText: 'Playa Name *',
                            ),
                            onChanged: (value) {
                              setState(() {
                                playaName = value;
                              });


                            },
                            onSaved: (String? value) {
                              if(value != null){
                                playaName = value;
                              }
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            // The validator receives the text that the user has entered.
                            decoration: const InputDecoration(
                              icon: Icon(Icons.email),
                              hintText: 'Optional email',
                              labelText: 'Email *',
                            ),
                            onChanged: (value) {
                              final regex = RegExp(pattern);
                              if(regex.hasMatch(value)){
                                emailAddress = value;
                              }
                            },
                            onSaved: (String? value) {
                              final regex = RegExp(pattern);
                              if(value != null && regex.hasMatch(value)){
                                emailAddress = value;
                              }
                            },
                            validator: (value) {
                              final regex = RegExp(pattern);
                              if (value != null && regex.hasMatch(value)) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                          ),

                          Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  // Validate returns true if the form is valid, or false otherwise.
                                  if (_formKey.currentState!.validate() && playaName.isNotEmpty ) {
                                    // If the form is valid, display a snackbar. In the real world,
                                    // you'd often call a server or save the information in a database.
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Processing Data')),
                                    );
                                  }
                                },
                                child: const Text('Arm'),
                              )),
                        ])

                ),

                Flexible(
                  flex: 2,
                  child: Container(
                    margin: EdgeInsets.all(4),
                    constraints: BoxConstraints.expand(),
                    decoration: BoxDecoration(border: Border.all()),
                    child: SingleChildScrollView(
                      child: ValueListenableBuilder<dynamic>(
                        valueListenable: result,
                        builder: (context, value, _) =>
                            Text('${value ?? ''}'),
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 3,
                  child: GridView.count(
                    padding: EdgeInsets.all(4),
                    crossAxisCount: 2,
                    childAspectRatio: 4,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                    children: [
                      ElevatedButton(
                          child: Text('Read Chip'), onPressed: _tagRead),
                      playaName.isNotEmpty ? ElevatedButton(
                          child: Text('Burn Chip'),
                          onPressed: _ndefWrite) : Spacer(),
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
      var xnm = '';
      var xyr = '2023';
      var xis = 'losers';
      if(ndef.cachedMessage != null){
        ndef.cachedMessage?.records.forEach((element) {
          // there are code/byte markers in front
          var swapBack = String.fromCharCodes(element.payload).substring(3);
          if(swapBack.startsWith("xnm:")){
            xnm = swapBack.substring(4);
          }
          if(swapBack.startsWith("xis:")){
            xis = swapBack.substring(4);
          }
          if(swapBack.startsWith("xyr:")){
            xyr = swapBack.substring(4);
          }
        });
      }
      result.value = "xid:$hooman\nxnm:$xnm\nxis:$xis\nxyr:$xyr";
      NfcManager.instance.stopSession();
    });
  }

  void _ndefWrite() {
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      var ndef = Ndef.from(tag);
      if (ndef == null || !ndef.isWritable) {
        result.value = 'Tag is not ndef writable';
        NfcManager.instance.stopSession(errorMessage: result.value);
        return;
      }

      NdefMessage message = NdefMessage([
        NdefRecord.createText('xnm:$playaName'),
        NdefRecord.createText('xyr:2023'),
        NdefRecord.createText('xis:pussy_avalanche'),
      ]);

      try {
        await ndef.write(message);
        result.value = 'Success to "Ndef Write"';
        NfcManager.instance.stopSession();
      } catch (e) {
        result.value = e;
        NfcManager.instance.stopSession(errorMessage: result.value.toString());
        return;
      }
    });
  }


}
