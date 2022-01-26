// import 'dart:convert';
// import 'dart:js';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class Cars extends StatefulWidget {
//   const Cars({ Key? key }) : super(key: key);

//   @override
//   _CarsState createState() => _CarsState();
// }

// class _CarsState extends State<Cars> {

//   Future getVehicleData() async {
//    //var response = await http.get(Uri.https('http://41.204.60.134:8000/rsmsp/api/mobile','/client/vehicles/'));
//     //var response = await http.get(Uri.http('http://41.204.60.134:8000/rsmsp/api/mobile','/client/vehicles/'));

//     var response = await http.get(Uri.parse('http://41.204.60.134:8000/rsmsp/api/mobile/client/vehicles/1901167283'));

   
//     var jsonData = jsonDecode(response.body);
//     List<Vehicle> vehicles = [];

//     for (var u in jsonData){
//         Vehicle vehicle = Vehicle(u['id'],u["referenceNumber"],u["customerId"],u["VehicleType"],u["registeredNumber"],
//      u["chassisNumber"],u["make"]);
//         vehicles.add(vehicle);
//     }
//     print(" this is vehicle length =${vehicles.length}");
//     return vehicles;
// }
//   @override
//   Widget build(BuildContext context) {
//     return Card(child: FutureBuilder(future: getVehicleData(),
//     builder: (context, AsyncSnapshot snapshot){
//       print("${snapshot.error}");
//       if(snapshot.data == null){
//         return const Center(child: Text("Loading.."),);
//       }
//       else {
//         return ListView.builder(itemCount: snapshot.data.length,
//         //builder: (context, AsyncSnapshot snapshot)
//       itemBuilder: (context, int i){
//         return ListTile(title:Text(snapshot.data[i].id),
//          subtitle: Text(snapshot.data[i].make),
//          trailing: Text(snapshot.data[i].customerId),);
//       });
//       }
//     },),);
//   }
  
// }
// // class Vehicle{
// // int? id;
// //     String? referenceNumber,
// //      customerId,
// //      vehicleType,
// //     registeredNumber,
// //      chassisNumber,
// //      make;
// //      Vehicle( 
// //         this.id,this.referenceNumber,this.customerId,this.vehicleType,this.registeredNumber,this.chassisNumber,
// //      this.make);

// //   static fromJson(item) {}
// //      }