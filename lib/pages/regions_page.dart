import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:rescue_app/main.dart';
import 'package:rescue_app/utils/endpoints.dart';
import 'package:dio/dio.dart';
import 'package:connectivity/connectivity.dart';
import 'package:rescue_app/utils/routes.dart';

class RegionsPage extends StatefulWidget {
  const RegionsPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<RegionsPage> createState() => _RegionsPageState();
}

class _RegionsPageState extends State<RegionsPage> {
  List regions = [];
  Future<List>? _regionsListFuture;

  String noData = "No Data";
  bool? isConnected;
  bool isFirstLoad = true;

  var response;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    makeRegionsRequest();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // leading: IconButton (icon:Icon(Icons.arrow_back)
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);

              Navigator.pushReplacementNamed(context, Routes.homePage);
            },
          ),
          title: Text(widget.title),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[Colors.yellowAccent, Colors.yellow]),
            ),
          ),
        ),
        body: SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: FutureBuilder(
              future: _regionsListFuture,
              builder: (context, AsyncSnapshot<List> snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return loadingView();
                } else if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasError) {
                  return noDataView((snapshot.error).toString());
                } else if (snapshot.connectionState == ConnectionState.done) {
                  return ListView.builder(
                    itemBuilder: (context, position) {
                      return Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        color: Colors.amber[100],
                        child: ListTile(
                            leading: Text(snapshot.data![position]['CODE']),
                            title:
                                Text(snapshot.data![position]['REGION_NAME']),
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    backgroundColor: Colors.lightGreen,
                                    content: Text(
                                      snapshot.data![position]['REGION_NAME'] +
                                          " Region.",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )),
                              );
                            }),
                      );
                    },
                    itemCount: regions.length,
                  );
                } else {
                  return loadingView();
                }
              },
            ),
          ),
        ));
  }

  Future<bool> isNetworkAvailable() async {
    bool isConnected;
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.none) {
      isConnected = false;
      print("Connection: $isConnected");
      return isConnected;
    } else {
      isConnected = true;
      return isConnected;
    }
  }

  // View to empty data message
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

  // Progress indicator widget to show loading.
  Widget loadingView() => const Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.white,
        ),
      );

  void makeRegionsRequest() {
    isNetworkAvailable().then((onInternet) {
      if (onInternet) {
        setState(() {
          _regionsListFuture = regionsRequest();
        });
      } else {
        setState(() {
          _regionsListFuture = Future.error("No Internet");
        });
      }
    });
  }

  Future<List> regionsRequest() async {
    // final regionData = Hive.box(apiBox).get("regionData", defaultValue:[]);
    // if(regionData.isNotEmpty) return regionData;
    Map<String, String> headers = {
      "Content-type": "application/json",
      'Accept': 'application/json',
      'Authorization': EndPoints.apiToken
    };
    // final regionResponseBox =
    //     Hive.box(apiBox).get("vehicleResponse", defaultValue: []);
    // if (regionResponseBox.isNotEmpty) return regionResponseBox;

    //check to see if there is data  or not
    final regionData = Hive.box(apiBox).get("regionData", defaultValue:[]);
    if(regionData.isNotEmpty) return regionData;
    Response response;

    try {
      response = await Dio().get(
        EndPoints.getRegionsUrl,
        options: Options(headers: headers),
      );

      if (response.statusCode == 200) {
        Map regionResponse = response.data;
        Hive.box(apiBox).put("regionData", regionData);
        regions = regionResponse['data'];
        print("Number of regions: " + regions.length.toString());
      } else {
        print('Error ' + response.statusCode.toString());
        noData = response.statusCode.toString();
        return Future.error("Error: $noData");
      }
    } on SocketException {
      //this is a specific exception being caught
      // if server cannot be reached socket exception is thrown
      return Future.error(
          "SocketException: Sorry We Couldn't Connect to the Server");
    } on DioError catch (exception) {
      // only executed if error is of type Exception i.e the dart Exception Class
      print('Exception Errors---> $exception');
      return Future.error("Oops!! Something went wrong: $exception");
    } catch (error) {
      print('Errors---> $error');
    }
    return regions;
  }
}
