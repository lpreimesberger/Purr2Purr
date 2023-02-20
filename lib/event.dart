import 'package:flutter/material.dart';
import 'package:purr2purr/common.dart';
import 'package:purr2purr/events.dart';
class EventDetailPage extends StatefulWidget {
  const EventDetailPage(this.record, {Key? key}) : super(key: key);

  final EventObject record;

  @override
  EventDetailPageState createState() => EventDetailPageState(record);
}

class EventDetailPageState extends State<EventDetailPage> {

  EventDetailPageState(this.record) : super();
  final EventObject record;

  @override
  Widget build(BuildContext context) {

    return Center(
      child: Card(
        margin: const EdgeInsets.all(50.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.album),
              title: Text(record.name),
              subtitle: Text(record.campLocation),

            ),
            Column(

              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text("Starts: " + org2Human(DateTime.tryParse(record.start)), style: TextStyle(color: Colors.white),),
                Text("Ends: " + org2Human(DateTime.tryParse(record.end)), style: TextStyle(color: Colors.white),),
                Text(record.camp, style: TextStyle(color: Colors.white),),
                Padding(
                  padding: EdgeInsets.all(15), //apply padding to all four sides
                  child: TextFormField(
                    readOnly: true,
                    style: TextStyle(color: Colors.white),
                    initialValue: record.description,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                  ),
                ),

                TextButton(
                  child: const Text('Back'),
                  onPressed: () { Navigator.pop(context, true);},
                ),
                const SizedBox(width: 8),
              ],
            ),
          ],
        ),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Details'),
      ),
      body: Center(
        child: Text('Employee salary: ${this.record.id}'),
      ),
    );
  }
}
