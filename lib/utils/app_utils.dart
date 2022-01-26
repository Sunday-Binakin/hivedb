
// import 'dart:convert';

// //import 'package:connectivity/connectivity.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// //import 'package:http/http.dart';
// //import 'package:progress_dialog/progress_dialog.dart';
// import 'package:rescue_app/main.dart';
// import 'package:rescue_app/models/IncidentType.dart';
// import 'package:rescue_app/models/region.dart';
// import  'package:rescue_app/utils/app_constants.dart';
// import 'package:rescue_app/utils/endpoints.dart';
// //import 'package:shared_preferences/shared_preferences.dart';

// class AppUtils {
//   AppUtils(BuildContext context);

//   String Function(String val) get requiredInputValidator => null;

//   get validateSpinner => null;


//   // BuildContext _buildContext;

//   // // ProgressDialog _progressDialog;

//   // // SharedPreferences prefs;

//   // AppUtils(this._buildContext) {
//   //   _progressDialog = ProgressDialog(_buildContext, isDismissible: false);

//   // }

//   // void showProgress() =>  _progressDialog.show();

//   // void hideProgress() => _progressDialog != null ? _progressDialog.hide(): null ;






//   // Show an alert dialog.
//   void showAlertDialog(String message, String setPositiveBtn ) {
//     showDialog(
//       context: _buildContext,
//       barrierDismissible: false,
//       builder: (_buildContext) {
//         // return object of type Dialog
//         return CupertinoAlertDialog(
//           title: Container(
//             padding: EdgeInsets.all(8.0),
//             height: 72.0,
//             width: 72.0,
//             child: Image.asset('assets/images/logo.png'),
//           ),
//           content: Text(message),
//           actions: <Widget>[
//             CupertinoDialogAction(
//               isDefaultAction: true,
//               child: new Text(setPositiveBtn),
//               onPressed: () {
//                 Navigator.of(_buildContext).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   // Show an alert dialog.
//   void showDialogWithAction(String message, String setPositiveBtn, action() ) {
//     showDialog(
//       context: _buildContext,
//       barrierDismissible: false,
//       builder: (_buildContext) {
//         // return object of type Dialog
//         return CupertinoAlertDialog(
//           title: Container(
//             padding: EdgeInsets.all(8.0),
//             height: 72.0,
//             width: 72.0,
//             child: Image.asset('assets/images/logo.png'),
//           ),
//           content: Text(message),
//           actions: <Widget>[
//             CupertinoDialogAction(
//               isDefaultAction: true,
//               child: new Text(setPositiveBtn),
//               onPressed: action,
//             ),

//             CupertinoDialogAction(
//               isDefaultAction: true,
//               child: new Text("Cancel"),
//               onPressed: () {
//                 Navigator.of(_buildContext).pop();
//               },
//             ),

//           ],
//         );
//       },
//     );
//   }

//   // check connectivity
//  Future<bool> isNetworkAvailable()async{
//    bool isConnected;
//    var connectivityResult = await(Connectivity().checkConnectivity());

// //   Connectivity().checkConnectivity().then((connectivityResultVal){
// //     connectivityResult = connectivityResultVal; });

//      if(connectivityResult == ConnectivityResult.none){

//        isConnected = false;
//        print("What the fuck is this $isConnected");
//     return isConnected;
//      }else{
//        isConnected = true;

//        return isConnected;
//      }

//  }

//   Future getAppSetupData(String dropDownsUrl) async {

//     prefs =  await SharedPreferences.getInstance() ;

//     Map<String, String> headers = {"Content-type": "application/json", 'Accept': 'application/json',
//       'Authorization': EndPoints.apiToken };

//     final response = await get(dropDownsUrl, headers: headers);

//     // 5
//     if (response.statusCode == 200) {

//       Map<String, dynamic> regionsJson = jsonDecode(response.body);

//       String status = regionsJson[AppConstants.jsStatusKey].toString();
//       String msg = regionsJson[AppConstants.jsMsgKey].toString();


//       if(status == "ok" ){

//         if(msg == "Region Found Successfully"){

//           String regionsJson = response.body.toString();
//          // prefs.setString(AppConstants.sPRegions, regionsJson);

//           print('These are regions L= $regionsJson');

//         }else if(msg == "Incident Found Successfully"){

//           String incidentsJson = response.body.toString();
//          // prefs.setString(AppConstants.sPIncidents, incidentsJson);

//           print('These are incidents L= $incidentsJson');

//         }


//       }else if(status == "error" ){

//         print('error msg = $msg');

//       }

//     } else {

//       print('Error---> ' + response.statusCode.toString());

//     }

//   }


// //  Future<List<String>> regionsUtils() async{

//   Future<List<Region>> regionsUtils() async{

//     prefs =  await SharedPreferences.getInstance() ;

//     List regionsList;
//     String regionsJson;
//     List<Region> regions = [];

//     sPrefs.containsKey(AppConstants.sPRegions) ?
//      regionsJson = sPrefs.getString(AppConstants.sPRegions) : regions =[] ;

//     Map<String, dynamic> regionsJsonMap = jsonDecode(regionsJson);
//     regionsList = regionsJsonMap[AppConstants.jsDataKey];

//     for (var region in regionsList) {
//       regions.add(Region(region["ID"], region["REGION_NAME"].toString()));

//     }

//     print('These are regions = $regions');

//     String myRegin = (regions[3]).name;

//     print('These is a region3 = $myRegin');

//     return regions;

//   }

//   Future<List<IncidentType>> incidentsTypeUtils() async{

//     prefs =  await SharedPreferences.getInstance() ;

//     List incidentTypesList;
//     String incidentTypesJson;
//     List<IncidentType> incidentTypes = [];

//     sPrefs.containsKey(AppConstants.sPIncidents) ?
//     incidentTypesJson = sPrefs.getString(AppConstants.sPIncidents) : incidentTypes =[] ;

//     Map<String, dynamic> incidentTypesJsonMap = jsonDecode(incidentTypesJson);
//     incidentTypesList = incidentTypesJsonMap[AppConstants.jsDataKey];

//     for (var incidentType in incidentTypesList) {
//       incidentTypes.add(IncidentType(incidentType["ID"], incidentType["INCIDENT_NAME"].toString()));

//     }

//     print('These are incidentTypes = $incidentTypes');

//     String myIncident = (incidentTypes[0]).name;

//     print('These is a incidentType = $myIncident');

//     return incidentTypes;

//   }


//   Widget formTextInput(TextEditingController controller, TextInputType textInputType,
//       String validate(String val), String helperText,
//       String labelText, IconData icon) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: TextFormField(
//         controller: controller,
//           keyboardType: textInputType,
//         decoration: InputDecoration(
//           border: OutlineInputBorder(),
//           helperText: helperText,
//           labelText: labelText,
//           prefixIcon: Icon(icon),
//         ),
//         validator: validate,
// //        onSaved: ,

//       ),
//     );
//   }

//   // String requiredInputValidator(value) =>
//   //     value.isEmpty ? 'Field cannot be left blank' : null;

//   // String optionalInputValidator(value) =>
//   //     value.isEmpty ? null : null;

//   // String validateSpinner(value) => value == null ? 'Please select an option' : null;

















// }

// class ConnectivityResult {
// }

// class _buildContext {
// }