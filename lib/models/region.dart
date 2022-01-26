import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class Region {

  String? code;
  String? name;

  Region(this.code, this.name);


  Region.fromJson(Map<String, dynamic> json)
      : code = json['CODE'] as String,
        name =json['REGION_NAME'] as String;

}
// key value Pairs
// no sql 
// api Calls
// hive