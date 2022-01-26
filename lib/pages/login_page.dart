import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:rescue_app/Pages/home_page.dart';

import 'package:dio/dio.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:rescue_app/utils/endpoints.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController userController = TextEditingController();
  TextEditingController passController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String username = "";
  String userPassword = "";
  bool hiddenPassword = true;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Login Page"),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[Colors.yellowAccent, Colors.yellow])),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Form(
                key: _formKey,
                child: Center(
                  child: Container(
                      width: 200,
                      height: 150,

                      /*decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(50.0)),*/
                      child: Image.asset('assets/images/car_towing.jpg')),
                ),
              ),
            ),
            // ignore: prefer_const_constructors
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: userController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Username',
                    hintText: ' Donny'),
                keyboardType: TextInputType.text,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding:
                  EdgeInsets.only(left: 15.0, right: 15.0, top: 15, bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: passController,
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter secure password'),
                keyboardType: TextInputType.visiblePassword,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            // ElevatedButton(
            //   onPressed: (){
            //     //TODO FORGOT PASSWORD SCREEN GOES HERE
            //   },
            //   child: Text(
            //     'Forgot Password',
            //     style: TextStyle(color: Colors.blue, fontSize: 15),
            //   ),
            // ),
            const SizedBox(
              height: 30,
            ),
            Container(
              height: 70,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.yellow,
                  borderRadius: BorderRadius.circular(20)),
              child: ElevatedButton(
                child: Text('Login'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    showLoaderDialog(context);
                    getUser().then((value) {
                      if (value['status'] == 'ok') {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomePage()));
                        Navigator.pop(context, showLoaderDialog(context));
                      } else {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Login',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    )),
                                content: Text(value['msg'],
                                    style: const TextStyle(
                                      fontSize: 20,
                                    )),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('OK',
                                        style: TextStyle(
                                          fontSize: 18,
                                        )),
                                  )
                                ],
                              );
                            });
                      }
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                    primary: Colors.yellow,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 20),
                    textStyle: const TextStyle(
                        fontSize: 30, fontWeight: FontWeight.bold)),
              ),
              //  ElevatedButton(
              //   style:  ElevatedButton.styleFrom({

              //   }),

              //   onPressed: () {
              //     // Navigator.push(context,
              //   login();
              //     //     MaterialPageRoute(builder: (_) => const HomePage()));
              //   },
              //   child: const Text(

              //     'Login',
              //     style: TextStyle(color: Colors.white, fontSize: 25),
              //   ),
              // ),
            ),
            const SizedBox(
              height: 30,
            ),
            Text('New User? Create Account')
          ],
        ),
      ),
    );
  }

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          Container(
              margin: const EdgeInsets.only(left: 7),
              child: const Text("Loading...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

//   //CREATING FUNCTION TO LOGIN USER
//   Future<void> login() async{
//     if(passController.text.isNotEmpty && userController.text.isNotEmpty){
//    var response =  await http.post(Uri.parse('http://41.204.60.134:8000/rsmsp/api/mobile'),
//     body:({
//       //http://41.204.42.117:3000/rsmsp/api/auth/user/login
//       'username': userController.text,
//        'password':passController.text}) );
//        if (response.statusCode==200){
// Navigator.push(context, MaterialPageRoute(builder: (context)=> HomePage()));
//        }else{
//         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//         content: Text('Invalid Credentials'))
//         );
//        }
//        }else{
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//         content: Text('Field cannot be let empty'))
//         );
//     }

//   }
  Future getUser() async {
    username = userController.text;
    userPassword = passController.text;

    Map<String, String> headers = {
      "Content-type": "application/json",
      'Accept': 'application/json',
      'Authorization': EndPoints.apiToken
    };

    Map data = {"USERNAME": "$username", "PASSWORD": "$userPassword"};
    print(data);

    try {
      final response = await Dio().post(
        EndPoints.loginUserUrl,
        data: data,
        options: Options(headers: headers),
      );
      Map user = response.data;
      print(user);

      return user;
    } on DioError catch (e) {
      print(" 2 ${e.error}");
    }
  }
}
