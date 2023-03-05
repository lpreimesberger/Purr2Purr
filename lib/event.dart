import 'package:flutter/material.dart';
import 'package:purr2purr/common.dart';
import 'package:purr2purr/events.dart';
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:get_storage/get_storage.dart';


class EventDetailPage extends StatefulWidget {
  const EventDetailPage(this.record, {Key? key}) : super(key: key);

  final EventObject record;

  @override
  EventDetailPageState createState() => EventDetailPageState(record);
}

class EventDetailPageState extends State<EventDetailPage> {
  final box = GetStorage();
  late var seen = false;
  EventDetailPageState(this.record) : super();
  final EventObject record;

  @override
  void initState() {
    super.initState();
    if(null != box.read("2022-${record.id}")){
      seen = true;
    }
    print(seen);
  }

  DateTime fixOrgDates(thisDate){
    var d = DateTime.tryParse(thisDate)!;
    d = d.subtract(const Duration(hours: 7));
    return d;
  }


  @override
  Widget build(BuildContext context) {

    return Center(
      child: Card(
        margin: const EdgeInsets.all(50.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.album),
              title: Text(record.name),
              subtitle: Text(record.campLocation),

            ),
            Column(

              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text("Starts: ${org2Human(fixOrgDates(record.start))}", style: const TextStyle(color: Colors.white),),
                Text("Ends: ${org2Human(fixOrgDates(record.end))}", style: const TextStyle(color: Colors.white),),
                Text(record.camp, style: const TextStyle(color: Colors.white),),
                Padding(
                  padding: const EdgeInsets.all(15), //apply padding to all four sides
                  child: TextFormField(
                    readOnly: true,
                    style: const TextStyle(color: Colors.white),
                    initialValue: record.description,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                  ),
                ),
                TextButton(
                  child: const Text('Back'),
                  onPressed: () { Navigator.pop(context, true);},
                ),
                ! seen ? TextButton(
                  child: const Text('Add to calendar'),
                  onPressed: () {
                    var st = DateTime.tryParse(record.start);
                    Add2Calendar.addEvent2Cal(
                      Event(
                        title: record.name,
                        description: record.description,
                        location: record.campLocation,
                        startDate: fixOrgDates(record.start).add(Duration(hours: 7)),
                        endDate: fixOrgDates(record.end).add(Duration(hours: 7)),
                        allDay: false,
                      ),
                    );
                  },
                ) : TextButton(
                  style: ButtonStyle(),
                    child: const Text('Added'),
                    onPressed: () { },
                ),
                const SizedBox(width: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
