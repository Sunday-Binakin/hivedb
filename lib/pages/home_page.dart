import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rescue_app/jose/motor_page.dart';
//import 'package:http/http.dart';
import 'package:rescue_app/main.dart';
import 'package:rescue_app/pages/client_vehicles_page.dart';
import 'package:rescue_app/pages/incident_report_page.dart';
import 'package:rescue_app/pages/login_page.dart';
import 'package:rescue_app/pages/regions_page.dart';


import 'package:rescue_app/utils/app_constants.dart';
import 'package:rescue_app/utils/app_utils.dart';
import 'package:rescue_app/utils/colors.dart';
import 'package:rescue_app/utils/endpoints.dart';
import 'package:rescue_app/utils/image_paths.dart';
import 'package:rescue_app/utils/routes.dart';
//import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {


  const HomePage({Key? key, }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
      centerTitle: true,
        title: const Text('Home'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
              Colors.yellowAccent,
              Colors.yellow
            ])  ,        
         ),        
     ),      
 ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget> [
             ListTile(  
              leading: Icon(Icons.home), title: Text("Settings"),  
              onTap: () {  
                Navigator.pop(context);  
              },),
              const Divider() ,
              ListTile(  
              leading: Icon(Icons.logout), title: Text("Logout"),  
              onTap: () {  
                //Navigator.pop(context);  
                 Navigator.push(
                            context, 
                   MaterialPageRoute(builder: (context) => const LoginPage()));
              },),
         
          ],
    )),
    body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Image.asset(
                'assets/images/car_towing.jpg',
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              height: 60,
              //margin: EdgeInsets.only(top: 32, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: InkWell(
                      child: Image.asset('assets/images/tow_vehicle.jpg', fit: BoxFit.contain,),
                      onTap: () {
                        //Navigator.pushNamed(context, Routes.vehiclesPage);
                        Navigator.push(
                           context,
                           MaterialPageRoute(builder: (context) => const MotorPage()));
                      },
                    ),
                  ),
                  SizedBox(
                     width: 100,
                    height: 100,
                    child: InkWell(
                      child: Image.asset('assets/images/incident_report.jpg', fit: BoxFit.contain,),
                      onTap: () {
                        // Navigator.pushNamed(context, Routes.incidentReportPage);
                         Navigator.push(
                           context,
                           MaterialPageRoute(builder: (context) => const IncidentReportPage()));},
                  ),
                  ),
                  SizedBox(
                     width: 100,
                    height: 100,
                    child: InkWell(
                      child: Image.asset('assets/images/region.jpg', fit: BoxFit.contain,),
                      onTap: () {
                       // Navigator.pushNamed(context, Routes.incidentReportPage);
                     Navigator.push(
                           context,
                           MaterialPageRoute(builder: (context) => const RegionsPage(title: 'Regions Page',)));
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

        ],
      )
    );
  }
}
