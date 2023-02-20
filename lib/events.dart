import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:purr2purr/event.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:developer' as trace;
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:intl/intl.dart';

import 'common.dart';

class EventsDataSource extends DataGridSource {


  /// Creates the employee data source class with required details.
  EventsDataSource({required List<EventObject> eventData}) {
    _eventData = eventData
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<String>(columnName: 'start', value: org2Human(DateTime.tryParse(e.start.replaceFirst("-07:00", "")))),
              DataGridCell<String>(columnName: 'end', value: org2HumanShort(DateTime.tryParse(e.end.replaceFirst("-07:00", "")))),
      DataGridCell<String>(
          columnName: 'location', value: shortLocation(e.campLocation)),
              DataGridCell<String>(columnName: 'name', value: e.name),
//              DataGridCell<String>(
//                  columnName: 'designation', value: e.description),
              DataGridCell<String>(columnName: 'what', value: e.camp),
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
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.all(8.0),
        child: Text(e.value.toString(), overflow: TextOverflow.ellipsis, style: const TextStyle(fontFamily: "SpaceMono"),),
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
  var busy = true;
  final gateOpen = DateTime(2022, 08, 29, 0, 0);
  final List<String> items = [
    'Gate Open',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Man Burn',
    'Temple Burn',
    'Teardown Monday',
    'Immediacy'
  ];

  String? selectedValue = "Immediacy";

  playaPrint(DateTime d) {
    // org uses ISO but PST for reasons - 2022-09-02T15:00:00-07:00
    // d is GMT - fix is
    d = d.subtract(const Duration(hours: 7));
    var f = NumberFormat("00", "en_US");
    var year = d.year;
    var day = f.format(d.day);
    var mon = f.format(d.month);
    var h = f.format(d.hour);
    var m = f.format(d.minute);
    //baby steps so flutter does it right
    var rv = "$year-$mon-$day";
    return "${rv}T$h:$m:00-07:00";
  }

  fetchEvents() async {
    var start = "2022-09-02T15:00:00-07:00";
    var end = "2022-09-03T15:00:00-07:00";
    var window = DateTime.now();
    if (selectedValue == "Immediacy") {
      if (kDebugMode) {
        // pretend
        trace.log("setting time to default since we are debugging");
        start = "2022-09-02T15:00:00-07:00";
      } else {
        start = playaPrint(DateTime.now());
      }
      var temp = DateTime.parse(start);
      var endWindow = temp.add(const Duration(hours: 3));
      end = playaPrint(endWindow);
    } else {
      switch (selectedValue) {
        case 'Gate Open':
          window = gateOpen;
          break;
        case 'Monday':
          window = gateOpen.add(const Duration(days: 1));
          break;
        case 'Tuesday':
          window = gateOpen.add(const Duration(days: 2));
          break;

        case 'Wednesday':
          window = gateOpen.add(const Duration(days: 3));
          break;

        case 'Thursday':
          window = gateOpen.add(const Duration(days: 4));
          break;

        case 'Friday':
          window = gateOpen.add(const Duration(days: 5));
          break;

        case 'Man Burn':
          window = gateOpen.add(const Duration(days: 6));
          break;

        case 'Temple Burn':
          window = gateOpen.add(const Duration(days: 7));
          break;

        case 'Teardown Monday':
          window = gateOpen.add(const Duration(days: 8));
          break;
      }
      var endWindow = window.add(const Duration(hours: 24));
      start = playaPrint(window);
      end = playaPrint(endWindow);

    }

    final mahPath = await getDatabasesPath();
    WidgetsFlutterBinding.ensureInitialized();
    var database = openDatabase(
      join(mahPath, 'p2p.db'),
    );
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        'select event_id, title, events.description as the_desc, camps.name as cname, location_string, start_time, end_time from camps, events where camps.uid = events.hosted_by_camp and start_time >= ? and end_time <= ? ORDER BY start_time',
        [start, end]);
    setState(() {
      busy = true;
      events.clear();
      for (var e in maps) {
        // flutter is picky about bad data now - don't trust org feed
        var id = int.parse(e['event_id'].toString());
        var title = e['title'];
        var desc = e['the_desc'];
        var camp = e['cname'];
        var campLocation = e['location_string'];
        var start = e['start_time'].toString();
        //if (start.length > 14) {
//          start = start.substring(11, 16);
  //      }
//        var end = e['end_time'];
//        if (end.length > 14) {
//          end = end.substring(11, 16);
//        }
        if (camp == null || campLocation == null) {
          continue;
        }
        events
            .add(EventObject(id, title, desc, camp, campLocation, start, end));
      }
      eventDataSource = EventsDataSource(eventData: events);
      eventDataSource.sortedColumns.add(const SortColumnDetails(
          name: 'start', sortDirection: DataGridSortDirection.ascending));
      eventDataSource.sort();
      busy = false;
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
    const skinnyColumn = 100.0;
    double fatColumn = MediaQuery.of(context).size.width - skinnyColumn;
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Events @ ${kDebugMode ? "(Pretending to be gate open)" : DateTime.now().toString()}"),
        ),
        backgroundColor: Colors.black38,
        body: busy ? const LoadingIndicator(
            indicatorType: Indicator.ballPulse, /// Required, The loading type of the widget
            colors: [Colors.white],       /// Optional, The color collections
            strokeWidth: 2,                     /// Optional, The stroke of the line, only applicable to widget which contains line
            backgroundColor: Colors.black,      /// Optional, Background of the widget
            pathBackgroundColor: Colors.black,   /// Optional, the stroke backgroundColor

        ) : Stack(
          children: <Widget>[
            Center(
                child: Column(

              children: [
                Container(
                    color: Colors.black,
                    height: MediaQuery.of(context).size.height*.9,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
    Container(
    color: Colors.black38,
    height: MediaQuery.of(context).size.height*.80,
    width: MediaQuery.of(context).size.width,
    child:                SfDataGrid(
      source: eventDataSource,
      allowSorting: true,
      allowFiltering: true,
      shrinkWrapRows: true, // grow to row# (misnamed)
      columnWidthMode: ColumnWidthMode.auto,
      onCellTap: (details) {
        if (details.rowColumnIndex.rowIndex != 0) {
          final record = events[details.rowColumnIndex.rowIndex - 1];
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => EventDetailPage(record)));
        }
      },
      columns: <GridColumn>[
        GridColumn(
            columnName: 'start',
            label: Container(
                padding: const EdgeInsets.all(16.0),
                width: skinnyColumn,
                alignment: Alignment.topLeft,
                child: const Text(
                  '@PST',
                ))),
        GridColumn(
            columnName: 'end',
            visible: false,
            width: skinnyColumn,
            label: Container(
                padding: const EdgeInsets.all(16.0),
                alignment: Alignment.center,
                child: const Text(
                  'End/PST',
                ))),
        GridColumn(
            columnName: 'what',
            width: skinnyColumn,
            label: Container(
                padding: const EdgeInsets.all(8.0),
                width: skinnyColumn,
                alignment: Alignment.topLeft,
                child: const Text('@'))),
        GridColumn(
            columnName: 'name',
            label: Container(
                width: 500,
                padding: const EdgeInsets.all(8.0),
                alignment: Alignment.topLeft,
                child: const Text('Event Name'))),
/*        GridColumn(
            columnName: 'designation',
            label: Container(
                padding: const EdgeInsets.all(8.0),
                alignment: Alignment.center,
                child: const Text(
                  '@',
                  overflow: TextOverflow.ellipsis,
                ))),
*/
        GridColumn(
            columnName: 'location',
            visible: false,
            label: Container(
                padding: const EdgeInsets.all(8.0),
                alignment: Alignment.center,
                child: const Text('Camp'))),
      ],
    ),
    ),
                        DropdownButtonHideUnderline(
                          child: DropdownButton2(
                            hint: Text(
                              'Change filter from "now"',
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                            items: items
                                .map((item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ))
                                .toList(),
                            value: selectedValue,
                            onChanged: (value) {
                              setState(() {
                                selectedValue = value as String;
                                fetchEvents();
                              });
                            },
                            buttonHeight: 20,
                            buttonWidth: MediaQuery.of(context).size.width*.5,
                            itemHeight: 20,
                          ),
                        ),

                      ],
                    )),

              ],
            ))
          ],
        ));
  }
}

toLogin() {} // state

class EventObject {
  EventObject(this.id, this.name, this.description, this.camp,
      this.campLocation, this.start, this.end);

  final int id;
  final String name;
  final String description;
  final String camp;
  final String campLocation;
  final String start;
  final String end;
}
