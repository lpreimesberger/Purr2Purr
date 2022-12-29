import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:developer' as trace;

class EventsDataSource extends DataGridSource {
  /// Creates the employee data source class with required details.
  EventsDataSource({required List<EventObject> eventData}) {
    _eventData = eventData
        .map<DataGridRow>((e) => DataGridRow(cells: [
      DataGridCell<int>(columnName: 'id', value: e.id),
      DataGridCell<String>(columnName: 'name', value: e.name),
      DataGridCell<String>(
          columnName: 'designation', value: e.description),
      DataGridCell<String>(columnName: 'salary', value: e.camp),
    ]))
        .toList();
  }

  List<DataGridRow> _eventData = [];

  @override
  List<DataGridRow> get rows => _eventData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
          return Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8.0),
            child: Text(e.value.toString()),
          );
        }).toList());
  }

}

class EventsPage extends StatefulWidget {
  const EventsPage({super.key, required this.title});
  final String title;
  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  List<EventObject> events = <EventObject>[];
  late EventsDataSource eventDataSource;


  fetchEvents() async {
    var start = "2022-09-02T15:00:00-07:00";
    var end = "2022-09-03T15:00:00-07:00";
    final mahPath = await getDatabasesPath();
    WidgetsFlutterBinding.ensureInitialized();
    var database = openDatabase(join(mahPath, 'p2p.db'),);
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('select event_id, title, events.description as the_desc, camps.name as cname, location_string, start_time, end_time from camps, events where camps.uid = events.hosted_by_camp and start_time >= ? and end_time <= ?', [start, end]);
    setState(() {
      events.clear();
      for(var e in maps){
        // flutter is picky about bad data now - don't trust org feed
        var id = int.parse(e['event_id'].toString());
        var title = e['title'];
        var desc = e['the_desc'];
        var camp = e['cname'];
        var campLocation = e['location_string'];
        var start = e['start_time'];
        var end = e['end_time'];
        if(camp == null || campLocation == null){ continue;}
        events.add(EventObject(
            id,
            title,
            desc,
            camp,
            campLocation,
        start, end));
      }
      eventDataSource = EventsDataSource(eventData: events);
    });

  }

  @override
  void initState() {
    super.initState();
    events = getPlaceHolderData();
    eventDataSource = EventsDataSource(eventData: events);
    fetchEvents();
  }

  List<EventObject> getPlaceHolderData() {
    return [
      EventObject(10010, 'Placeholder', 'Developer', "", "", "", "15000")
    ];
  }


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
        // Here we take the value from the EventsPage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text("Events"),
      ),
      body: Stack(
        children: <Widget>[
          Center(
            child: Column( children: [
              Container(color: Colors.white70, height: 400, width: MediaQuery. of(context). size. width, child: Column(children: [
                 const Text("Events page"),
                SfDataGrid(
                  source: eventDataSource,
                  columnWidthMode: ColumnWidthMode.fill,
                  columns: <GridColumn>[
                    GridColumn(
                        columnName: 'id',
                        label: Container(
                            padding: const EdgeInsets.all(16.0),
                            alignment: Alignment.center,
                            child: const Text(
                              'ID',
                            ))),
                    GridColumn(
                        columnName: 'name',
                        label: Container(
                            padding: const EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: const Text('Name'))),
                    GridColumn(
                        columnName: 'designation',
                        label: Container(
                            padding: const EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: const Text(
                              'Designation',
                              overflow: TextOverflow.ellipsis,
                            ))),
                    GridColumn(
                        columnName: 'salary',
                        label: Container(
                            padding: const EdgeInsets.all(8.0),
                            alignment: Alignment.center,
                            child: const Text('Salary'))),
                  ],
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

} // state


class EventObject {
  EventObject(this.id, this.name, this.description, this.camp, this.campLocation, this.start, this.end);
  final int id;
  final String name;
  final String description;
  final String camp;
  final String campLocation;
  final String start;
  final String end;
}

