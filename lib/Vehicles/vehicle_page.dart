import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rescue_app/main.dart';
import 'package:rescue_app/pages/home_page.dart';
// import 'package:ghana_issue/http_service.dart';
// import 'package:ghana_issue/motor.dart';
// import 'package:ghana_issue/motor_response.dart';

import 'http_service.dart';
import 'motor.dart';
import 'motor_response.dart';

class MotorPage extends StatefulWidget {
  const MotorPage({Key? key}) : super(key: key);

  @override
  _MotorPageState createState() => _MotorPageState();
}

class _MotorPageState extends State<MotorPage> {
// late Box box;
// Future openBox() async{
// var dir = await getApplicationDocumentsDirectory();
// Hive.init(dir.path);
// box = await Hive.openBox('data');
// return;
// }
  
  bool isLoading = false;

  late HttpService http;

  late MotorUserResponse motorUserResponse;

  List<Motor> motors = [];

  Future getListUser() async {
    final vehicleResponse = Hive.box(apiBox).get("vehicleResponse", defaultValue: []);
    if(vehicleResponse.isNotEmpty) return vehicleResponse;
    Response response;
    try {
      setState(() => isLoading = true);

      response = await http.getRequest("/client/vehicles/1901167283");

      if (response.statusCode == 200) {
        setState(
          () {
            motorUserResponse = MotorUserResponse.fromJson(response.data);
            Hive.box(apiBox).put("vehicleResponse", motorUserResponse);
            motors = motorUserResponse.motors;
            isLoading = false;
          },
        );
        //await putUserList(motorUserResponse);
      } else {
        setState(() => isLoading = false);
        print("There is some problem status code not 200");
      }
    } on Exception catch (e) {
      setState(() => isLoading = false);
      print(e);
    }

    //get data from database
    //var mymap = box.toMap().values.toList();
    
  }

  // @override
  // Widget build(BuildContext context) {
  //   // TODO: implement build
  //   throw UnimplementedError();
  // }

  // Future putUserList(data) async{
  //   //wait for box to clear itself , will be called everytime
  //   //the box pdate the data
  //   //await box.clear();
  //   //insert the data
  //   for ( var datafromAPi  in data){
  //     box.add(datafromAPi);
    //}//

  //}

  @override
  void initState() {
    http = HttpService();

    Future.delayed(const Duration(seconds: 1), () => getListUser());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          },
        ),
        title: Text("Client Vehicle Page"),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[Colors.yellowAccent, Colors.yellow])),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemBuilder: (context, index) {
                final userMotor = motors[index];
                return GestureDetector(
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: Colors.yellowAccent[100],
                    child: ListTile(
                      title: Text(userMotor.make),
                      onTap: () {
                         //var snackBar =
                            //SnackBar(content: Text(userMotor.registrationNumber));

                        ScaffoldMessenger.of(context).showSnackBar(SnackBar( content:  Text(userMotor.registrationNumber), duration: const Duration(milliseconds: 300),),);

                        // title: Text(userMotor.vehicleType),
                        //subtitle: Text(userMotor.registrationNumber),
                      },
                    ),
                  ),
                );
              },
              itemCount: motors.length,
            ),
    );
  }
}
