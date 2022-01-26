import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rescue_app/pages/home_page.dart';
import 'package:rescue_app/pages/incident_report_page.dart';
import 'package:rescue_app/pages/login_page.dart';
import 'package:rescue_app/pages/vehicles_page.dart';
import 'package:rescue_app/pages/regions_page.dart';
import 'package:rescue_app/utils/app_constants.dart';
import 'package:rescue_app/utils/app_utils.dart';
import 'package:rescue_app/utils/colors.dart';
import 'package:rescue_app/utils/endpoints.dart';
import 'package:rescue_app/utils/routes.dart';

const String apiBox = 'apiCaheData';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('UserDetails');
  await Hive.openBox(apiBox);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RESCUE APP',
      theme: ThemeData(
        primaryColor: AppColors.colorPrimary,
        primaryColorDark: AppColors.colorPrimary,
      ),

      home:
          //const MotorPage(),
          // ClientVehiclePage(),
          // const  VcPage(),
          //PostsPage(),
          // const Cars(),
          //const RegionsPage(title: 'Regions Page'),
          // const VehiclesPage(),
          //const IncidentReportPage()
          const LoginPage(),
      //const HomePage(),
    );
  }
}
