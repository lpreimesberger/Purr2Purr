import 'package:flutter/material.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';

class DateTimePickerBottomSheet extends StatefulWidget {
  DateTimePickerBottomSheet({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DateTimePickerBottomSheetState();
}

const String MIN_DATETIME = '2023-08-27 00:00:00';
const String MAX_DATETIME = '2023-09-04 23:00:00';
const String INIT_DATETIME = '2023-09-01 23:00:00';

class _DateTimePickerBottomSheetState extends State<DateTimePickerBottomSheet> {
  bool? _showTitle = true;
  String _format = 'M-d  H:m:s';
  TextEditingController _formatCtrl = TextEditingController();
  DateTimePickerLocale? _locale = DateTimePickerLocale.en_us;
  List<DateTimePickerLocale> _locales = DateTimePickerLocale.values;
  late DateTime _dateTime;

  @override
  void initState() {
    super.initState();
    _formatCtrl.text = _format;
    _dateTime = DateTime.parse(INIT_DATETIME);
  }

  /// Display time picker.
  void _showDateTimePicker() {
    DatePicker.showDatePicker(
      context,
      minDateTime: DateTime.parse(MIN_DATETIME),
      maxDateTime: DateTime.parse(MAX_DATETIME),
      initialDateTime: _dateTime,
      dateFormat: _format,
      locale: _locale!,
      pickerTheme: DateTimePickerTheme(
        showTitle: _showTitle!,
      ),
      pickerMode: DateTimePickerMode.datetime, // show TimePicker
      onCancel: () {
        debugPrint('onCancel');
      },
      onChange: (dateTime, List<int> index) {
        setState(() {
          _dateTime = dateTime;
        });
      },
      onConfirm: (dateTime, List<int> index) {
        setState(() {
          _dateTime = dateTime;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> radios = [];


    TextStyle hintTextStyle =
    Theme.of(context).textTheme.subtitle1!.apply(color: Color(0xFF999999));
    return Scaffold(
      appBar: AppBar(title: Text('DateTimePicker Bottom Sheet')),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[

          ],
        ),
      ),
      // display DateTimePicker floating action button
      floatingActionButton: FloatingActionButton(
        onPressed: _showDateTimePicker,
        tooltip: 'Show DateTimePicker',
        child: Icon(Icons.access_time),
      ),
    );
  }
}