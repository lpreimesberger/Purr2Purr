import 'package:flutter/foundation.dart';
const productionHost = 'https://spacecow0.spacecow.app';
const testHost = 'http://192.168.68.159:8000';
const kVersion = 1.9999;
//const activeHost = testHost;
const currentIntroVersion = 1;
String activeHost(){
    if(kReleaseMode && ! kDebugMode){
      return productionHost;
    }
    print("Warning - running in debug mode and using local services...");
      return testHost;
}

int daysUntil(DateTime to) {
  var from = DateTime.now();
  from = DateTime(from.year, from.month, from.day);
  to = DateTime(to.year, to.month, to.day);
  return (to.difference(from).inHours / 24).round();
}