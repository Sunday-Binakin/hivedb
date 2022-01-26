

class AppConstants{
  static final String rsmsl = "Road Safety Management Services Ltd.";


  static final jsStatusKey = "status";
  static final jsCodeKey= "code";
  static final jsDataKey = 'data';
  static final jsMsgKey = "msg";


  // Shared Preferences
  static final String sPCustomerID = "customerID";
  static final String sPUserCode = "userCode";
  static final String sPUsersName = "userName";
  static final String sPUserPassword = "password";
  static final String sPRegions = "regionsJson";
  static final String sPIncidents = "incidentsJson";


  //String resources

//  SignUp Page
  static final String signUP = "Sign Up";
  static final String clientSignUP = "Client $signUP";
  static final String logIn = "LOGIN";
  static final String required = "Required";
  static final String requiredButNullable = "Required- Add/Update Later ";

//  HomePage
  static final String addVehicle = "Add Vehicle";
  static final String changePassword = "Change Password";
  static final String save = "Save";

  // Vehicles Page
  static final String selectVehicle = "Select Vehicle";

  // Transaction Page
  static final String transactionPage = "Transaction Page";
  static final String submitPayment = "Submit Payment";
  static final String source = "RSMSL";

  //tow request page
  static final String requestTow = "Request Tow";
  static final String contactName  = "Contact Name";
  static final String contactPhone = "Contact Phone ";
  static final String locationName = "Location Name";
  static final String destinationName = "Destination Name";
  static final String notSet = "Not Set";

  //RssFeeds Page
  static final String rssFeeds = "Rss Feeds";


  //Report Incident Page
  static final String incidentReport = "Incident Report";
  static final String reportIncident = "Report Incident";

  //Service tracking
  static final String serviceTracking = "Service Tracking";
















}



// import 'dart:io';

// import 'package:connectivity/connectivity.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import 'package:rescue_app/models/vehicle_model.dart';
// import 'package:rescue_app/utils/app_constants.dart';
// import 'package:rescue_app/utils/endpoints.dart';

// class VehiclesPage extends StatefulWidget {
//   const VehiclesPage({
//     Key? key,
//   }) : super(key: key);

//   @override
//   _VehiclesPageState createState() => _VehiclesPageState();
// }

// class _VehiclesPageState extends State<VehiclesPage> {
//   List vehiclesList = [];
//   Future<List>? _vehiclesListFuture;

//   String? customerID;
//   String? noData = "";
//   bool? isConnected;
//   bool isFirstLoad = true;
//   Future<Box> box1 = Hive.openBox('UserDetails');

//   var response;
  
//   //var  box1 =  Hive.openBox('UserDetails');

//   @override
//   void initState() {
//     super.initState();
//     setState(() {
//       customerID = Hive.box('UserDetails').get('CustomerID');
//     });
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();

//     if (isFirstLoad) {
//       isFirstLoad = false;
//       isNetworkAvailable().then((onInternet) {
//         if (onInternet) {
//           setState(() {
//             _vehiclesListFuture = clientVehiclesRequest() as Future<List>?;
//           });
//         } else {
//           setState(() {
//             _vehiclesListFuture = Future.error("No Internet");
//           });
//         }
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text(AppConstants.selectVehicle),
//           actions: <Widget>[
//             Padding(
//                 padding: const EdgeInsets.only(right: 20.0),
//                 child: GestureDetector(
//                   onTap: () {
//                     makeClientVehiclesRequest();
//                   },
//                   child: const Icon(
//                     Icons.sync,
//                     size: 26.0,
//                   ),
//                 )),
//           ],
//         ),
//         body: Container(
//           child: SafeArea(
//             child: SizedBox(
//               height: MediaQuery.of(context).size.height,
//               width: MediaQuery.of(context).size.width,
//               child: FutureBuilder(
//                 future: _vehiclesListFuture,
//                 builder: (context, AsyncSnapshot<List> snapshot) {
//                   if (snapshot.connectionState != ConnectionState.done) {
//                     return loadingView();
//                   } else if (snapshot.connectionState == ConnectionState.done &&
//                       snapshot.hasError) {
//                     return noDataView((snapshot.error).toString());
//                   } else {
//                     return ListView.builder(
//                       itemBuilder: (context, position) {
//                         return Card(
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10)),
//                           color: Colors.amber[100],
//                           child: ListTile(
//                               leading: Icon(
//                                 Icons.directions_car,
//                                 color:
//                                     snapshot.data![position]['IS_ACTIVE'] == "Y"
//                                         ? Colors.green
//                                         : Colors.red,
//                               ),
//                               title: Text(snapshot.data![position]
//                                       ['REGISTERED_NUMBER']
//                                   .toUpperCase()),
//                               subtitle: Text(snapshot.data![position]['MAKE'] +
//                                   "\n" +
//                                   snapshot.data![position]['VEHICLE_TYPE']),
//                               trailing: Text("Active?" +
//                                   "\n" +
//                                   snapshot.data![position]['IS_ACTIVE']),
//                               isThreeLine: true,
//                               onTap: () {
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   SnackBar(
//                                       backgroundColor: Colors.lightGreen,
//                                       content: Text(
//                                         snapshot.data![position]['MAKE'] +
//                                             " " +
//                                             snapshot.data![position]
//                                                 ['VEHICLE_TYPE'] +
//                                             " selected.",
//                                         style: const TextStyle(
//                                             fontWeight: FontWeight.bold),
//                                       )),
//                                 );
//                                 //box1.put('SelectedVehicle', snapshot.data![position]['REGISTERED_NUMBER']);
//                               }),
//                         );
//                       },
//                       itemCount: vehiclesList.length,
//                     );
//                   }
//                 },
//               ),
//             ),
//           ),
//         ));
//   }

//   Future<bool> isNetworkAvailable() async {
//     bool isConnected;
//     var connectivityResult = await (Connectivity().checkConnectivity());

//     if (connectivityResult == ConnectivityResult.none) {
//       isConnected = false;
//       print("Connection: $isConnected");
//       return isConnected;
//     } else {
//       isConnected = true;
//       return isConnected;
//     }
//   }

//   // View to empty data message
//   Widget noDataView(String msg) => Center(
//         child: Padding(
//           padding: const EdgeInsets.all(10.0),
//           child: Text(
//             msg,
//             style: const TextStyle(
//                 fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
//           ),
//         ),
//       );

//   // Progress indicator widget to show loading.
//   Widget loadingView() => const Center(
//         child: CircularProgressIndicator(
//           backgroundColor: Colors.white,
//         ),
//       );

//   void makeClientVehiclesRequest() {
//     isNetworkAvailable().then((onInternet) {
//       if (onInternet) {
//         setState(() {
//           _vehiclesListFuture = clientVehiclesRequest() as Future<List>?;
//         });
//       } else {
//         setState(() {
//           _vehiclesListFuture = Future.error("No Internet");
//         });
//       }
//     });
//   }

//   Future<List> clientVehiclesRequest() async {
//     Map<String, String> headers = {
//       "Content-type": "application/json",
//       'Accept': 'application/json',
//       'Authorization': EndPoints.apiToken
//     };

//     try {
//       response = await Dio().get(
//         EndPoints.getClientVehicles + customerID!,
//         options: Options(headers: headers),
//       );

//       if (response.statusCode == 200) {
//         Map vehicleLists = response.data;
//         vehiclesList = vehicleLists['data'];
//         print("Number of Vehicles: " + vehiclesList.length.toString());
//       } else {
//         print('Error---> ' + response.statusCode.toString());
//         noData = response.statusCode.toString();
//         return Future.error("Error: $noData");
//       }
//     } on SocketException {
//       //this is a specific exception being caught
//       // if server cannot be reached socket exception is thrown
//       return Future.error(
//           "SocketException: Sorry We Couldn't Connect to the Server");
//     } on DioError catch (exception) {
//       // only executed if error is of type Exception i.e the dart Exception Class
//       print('Exception Errors---> $exception');
//       return Future.error("Oooops!! Something went wrong: $exception");
// //     } catch (error) {
// //       // executed for errors of all types other than Exception. hence catch any other crazy exception
// //       print('Exception Errors---> $error');
// // //      return Future.error("SocketException: Sorry We Couldn't Connect to the Servers");
// //     }
// //     return  vehiclesList;
//   }
//   }}
