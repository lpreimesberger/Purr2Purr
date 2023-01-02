import 'dart:typed_data';
import 'dart:convert';
import 'package:purr2purr/name.dart';
import 'package:shared_value/shared_value.dart';
import 'package:uuid/uuid.dart';
import 'package:elliptic/elliptic.dart';
import "package:pointycastle/export.dart";

final SharedValue<double> dbVersion = SharedValue(
  value: 0.0, // initial value
  key: "db_version", // disk storage key for shared_preferences
  autosave: true, // autosave to shared prefs when value changes
);

final SharedValue<String> phoneUUID = SharedValue(
  value: const Uuid().v4(),
  key: "phone_uuid", // disk storage key for shared_preferences
  autosave: true, // autosave to shared prefs when value changes
);

final SharedValue<String> burnerName = SharedValue(
  value: getName(),
  key: "burner_name", // disk storage key for shared_preferences
  autosave: true, // autosave to shared prefs when value changes
);

final SharedValue<String> publicKey = SharedValue(
  value: "",
  key: "public_key", // disk storage key for shared_preferences
  autosave: true, // autosave to shared prefs when value changes
);
final SharedValue<String> privateKey = SharedValue(
  value: "",
  key: "public_key", // disk storage key for shared_preferences
  autosave: true, // autosave to shared prefs when value changes
);
final SharedValue<String> address = SharedValue(
  value: "",
  key: "address", // disk storage key for shared_preferences
  autosave: true, // autosave to shared prefs when value changes
);


Uint8List sha256Digest(List<int> dataToDigest) {
  var swap = Uint8List.fromList(dataToDigest);
  final d = SHA256Digest();
  return d.process(swap);
}

Uint8List ripe(Uint8List dataToDigest) {
  final d = RIPEMD160Digest();
  return d.process(dataToDigest);
}




initCrypto() async{
  var t= [59, 88, 175, 102, 235, 134, 165, 122, 232, 47, 128, 74, 202, 229, 228, 31, 132, 148, 174, 199];
  await privateKey.load();
  if(privateKey.$ != ""){
    print('ignoring');
//    return;
  }
  var d = Digest('RIPEMD-160');
  var ds = Digest('SHA-256');
  var ec = getP256();
  var priv = ec.generatePrivateKey();
  var pub = priv.publicKey;
  var theSha = sha256Digest(priv.bytes);
  var address2 = ripe(theSha);
  var readable = "v0" + Base64Encoder().convert(address2);
  privateKey.$ = priv.toHex();
  publicKey.$ = pub.toHex();
  address.$ = readable;
  privateKey.save();
  publicKey.save();
  address.save();
}

