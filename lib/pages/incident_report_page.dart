import 'dart:convert';

import 'package:dio/dio.dart';
//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
//import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
import 'package:rescue_app/main.dart';
import 'package:rescue_app/models/Incident_report_type.dart';
import 'package:rescue_app/pages/home_page.dart';
//import 'package:rescue_app/models/incident_type.dart';
//import 'package:rescue_app/pages/homepage.dart';
import 'package:rescue_app/utils/app_constants.dart';
import 'package:rescue_app/utils/endpoints.dart';
import 'package:rescue_app/utils/routes.dart';

class IncidentReportPage extends StatefulWidget {
  const IncidentReportPage({Key? key}) : super(key: key);

  @override
  _IncidentReportPageState createState() => _IncidentReportPageState();
}

class _IncidentReportPageState extends State<IncidentReportPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _onFormChanged = false;
  bool _doAutoValidation = false;
  bool? setUpSpinnerData;

  Position? _currentGeoPosition;
  String latitude = "Not Set";
  String longitude = "Not Set";

  Box box1 = Hive.box('UserDetails');

  String? dropDownValue;
  String? selectedIncidentTypeID;
  IncidentType? incidentTypeDropDownValue;
  List incidentTypes = [];
  Future<List>? incidentTypesFuture;
  var response;

  final incidentTitleController = TextEditingController();
  final incidentDescriptionController = TextEditingController();

  String? userCode,
      selectedIncidentTypeName,
      incidentTitle,
      incidentDescription;

  @override
  void initState() {
    super.initState();

    // setState(() {
    //   userCode = box1.get('UserCode');
    // });
    _determinePosition();
    makeIncidentTypesRequest();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);

            Navigator.pushReplacementNamed(context, Routes.homePage);
          },
        ),
        centerTitle: true,
        title: Text(
          AppConstants.incidentReport,
          style: const TextStyle(color: Colors.white),
        ),
        flexibleSpace: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[Colors.yellowAccent, Colors.yellow]))),
        // leading: IconButton(
        //onPressed: () {
        //  FocusScope.of(context).unfocus();
        //Navigator.of(context).pop();
        // },
        //icon: const Icon(Icons.close),
        // ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.always,
                  onChanged: _onFormChange,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 100,
                        width: MediaQuery.of(context).size.width,
                        child: FutureBuilder(
                          future: incidentTypesFuture,
                          builder: (context, AsyncSnapshot<List> snapshot) {
                            if (snapshot.connectionState !=
                                ConnectionState.done) {
                              return loadingView();
                            } else if (snapshot.connectionState ==
                                    ConnectionState.done &&
                                snapshot.hasError) {
                              return noDataView((snapshot.error).toString());
                            } else {
                              return FormField(
                                builder: (FormFieldState state) {
                                  return InputDecorator(
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 20.0, vertical: 15.0),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0)),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        hint:
                                            const Text("Select Incident Type"),
                                        value: dropDownValue,
                                        elevation: 16,
                                        style: const TextStyle(
                                            color: Colors.black),
                                        underline: Container(
                                          height: 2,
                                          color: Colors.green,
                                        ),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            dropDownValue = newValue!;
                                            selectedIncidentTypeID = newValue;
                                          });
                                        },
                                        items: incidentTypes.map((e) {
                                          return DropdownMenuItem<String>(
                                            child: Text(e['INCIDENT_NAME']),
                                            value: e['ID'].toString(),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  );
                                },
                              );
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 8.0),
                        child: TextFormField(
                            controller: incidentDescriptionController,
                            keyboardType: TextInputType.text,
                            maxLines: 5,
                            decoration: const InputDecoration(
                              helperText: "Required",
                              labelText: "Briefly Describe Incident",
                            ),
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Field cannot be empty";
                              }
                              return null;
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 10.0),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.yellow),
                          ),
                          child: const Text("Get Coordinates"),
                          onPressed: getCoordinates,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 8.0),
                        child: RichText(
                          text: TextSpan(children: <TextSpan>[
                            const TextSpan(
                                text: 'Latitude (X): ',
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: Colors.black)),
                            TextSpan(
                                text: latitude,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.yellow)),
                          ]),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 8.0),
                        child: RichText(
                          text: TextSpan(children: <TextSpan>[
                            const TextSpan(
                                text: 'Longitude (Y): ',
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: Colors.black)),
                            TextSpan(
                                text: longitude,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.yellow)),
                          ]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.yellow)),
                      child: const Text(
                        "REPORT INCIDENT",
                        style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                            fontStyle: FontStyle.italic),
                      ),
                      onPressed: _validateInputs,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  //  If _formChanged is already true, prevent Flutter from re-rendering by preventing that setState from being called.
  void _onFormChange() {
    if (_onFormChanged) return;
    setState(() {
      _onFormChanged = true;
    });
  }

  void makeIncidentTypesRequest() {
    setState(() {
      incidentTypesFuture = incidentsTypeUtils();
    });
  }

  Widget noDataView(String msg) => Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            msg,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
      );

  Widget loadingView() => const Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.white,
        ),
      );

  Future<List> incidentsTypeUtils() async {
    Map<String, String> headers = {
      "Content-type": "application/json",
      'Accept': 'application/json',
      'Authorization': EndPoints.apiToken
    };
    final incidentResponse =
        Hive.box(apiBox).get("vehicleResponse", defaultValue: []);
    if (incidentResponse.isNotEmpty) return incidentResponse;
    try {
      response = await Dio()
          .get(EndPoints.getIncidentsUrl, options: Options(headers: headers));

      if (response.statusCode == 200) {
        //List incidentTypes;
        Map incidentType = response.data;
        Hive.box(apiBox).put("incidentResponse", incidentType);
        setState(() {
          incidentTypes = incidentType['data'];
        });
        print("Number of incident types: " + incidentTypes.length.toString());
      } else {
        print("Can't fetch incident types");
      }
    } on DioError catch (e) {
      print("Error:   $e");
    }
    return incidentTypes;
  }

  void getCoordinates() {
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentGeoPosition = position;
        longitude = _currentGeoPosition!.longitude.toString();
        latitude = _currentGeoPosition!.latitude.toString();
      });
    }).catchError((e) {
      print("Geolocation Error---->> $e");
    });
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelinesaå
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  void _validateInputs() {
    if (_formKey.currentState!.validate()) {
//    If all data are correct then save data to out variables
      _formKey.currentState!.save();
      if (selectedIncidentTypeID == "1") {
        incidentTitle = "Accident";
      } else if (selectedIncidentTypeID == "2") {
        incidentTitle = "Blockage";
      }
      incidentDescription = incidentDescriptionController.text;
      print(incidentTitle);
      print(userCode);
      print(selectedIncidentTypeID);
      print(incidentDescriptionController.text);
      print(longitude);
      print(latitude);

      reportIncidentRequest(userCode!, selectedIncidentTypeID!, incidentTitle!,
          incidentDescriptionController.text, longitude, latitude);
    } else {
//    If all data are not valid then start auto validation.
      setState(() {
        _doAutoValidation = true;
      });
    }
  }

  Future reportIncidentRequest(
      String userCode,
      String incidentTypeID,
      String incidentTitle,
      String incidentDescription,
      String longitude,
      String latitude) async {
    Map<String, String> headers = {
      "Content-type": "application/json",
      'Accept': 'application/json',
      'Authorization': EndPoints.apiToken
    };

    String requestJson =
        '{"USER_CODE": "$userCode", "INCIDENT_ID": "$incidentTypeID", '
        '"TITLE": "$incidentTitle", "DESCRIPTION": "$incidentDescription", "LLT": "$latitude", "LLNT": "$longitude"}';

    final response = await Dio().post(EndPoints.reportIncident,
        options: Options(headers: headers), data: requestJson);

    // 5
    if (response.statusCode == 200) {
      Map responseBody = response.data;

      String status = responseBody[AppConstants.jsStatusKey].toString();
      String msg = responseBody[AppConstants.jsMsgKey].toString();
      if (status == "ok") {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Alert',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    )),
                content: const Text("Incident Reported Successfully",
                    style: TextStyle(
                      fontSize: 20,
                    )),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomePage()));
                    },
                    child: const Text('OK',
                        style: TextStyle(
                          fontSize: 18,
                        )),
                  )
                ],
              );
            });
      } else if (status == "error") {
        print('error msg = $msg');
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Alert',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    )),
                content: Text(msg,
                    style: const TextStyle(
                      fontSize: 20,
                    )),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Close',
                        style: TextStyle(
                          fontSize: 18,
                        )),
                  )
                ],
              );
            });
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Alert',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    )),
                content: Text(
                    "Unable to Report Incident \nError Code" +
                        response.statusCode.toString(),
                    style: const TextStyle(
                      fontSize: 20,
                    )),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Close',
                        style: TextStyle(
                          fontSize: 18,
                        )),
                  )
                ],
              );
            });
      }
      print('Error---> ' + response.statusCode.toString());
    }
  }
}
