import 'dart:async';
import 'package:flutter/material.dart';
import 'package:purr2purr/name.dart';
import 'package:shared_value/shared_value.dart';
import 'package:uuid/uuid.dart';

final SharedValue<double> dbVersion = SharedValue(
  value: 0.0, // initial value
  key: "db_version", // disk storage key for shared_preferences
  autosave: true, // autosave to shared prefs when value changes
);

final SharedValue<String> phoneUUID = SharedValue(
  value: const Uuid().v4(),
  key: "uuid", // disk storage key for shared_preferences
  autosave: true, // autosave to shared prefs when value changes
);

final SharedValue<String> burnerName = SharedValue(
  value: getName(),
  key: "db_version", // disk storage key for shared_preferences
  autosave: true, // autosave to shared prefs when value changes
);

