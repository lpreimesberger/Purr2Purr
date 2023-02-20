import 'package:intl/intl.dart';

String org2Human(DateTime? thisDate){
  if(thisDate == null){
    return 'Unknown';
  }
  return DateFormat('E H:mm').format(thisDate);
}
String org2HumanShort(DateTime? thisDate){
  if(thisDate == null){
    return 'Unknown';
  }
  return DateFormat('H:mm').format(thisDate);
}
String shortLocation(String? thisString){
  if(thisString == null){
    return '????';
  }
  thisString = thisString.replaceFirst(" & ", "/")
      .replaceFirst(" Portal", "P")
      .replaceFirst("Esplanade", "ES")
      .replaceFirst("Center Camp Plaza @ ", "CC/")
      .replaceFirst("Rod's Ring Road @ ", "RR/");
  if(thisString.contains(" ")){
    print("whoa!");
  }
  return thisString;
}