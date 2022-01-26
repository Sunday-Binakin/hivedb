import 'package:dio/dio.dart';

class HttpService {
  late Dio _dio;

  final baseUrl = "http://45.79.223.192/rsmsp/api/mobile";

  HttpService() {
    Map<String, String> headers = {
      "Content-type": "application/json",
      'Accept': 'application/json',
      'Authorization': 'Bearer EpU4KNeYpAs5vVNRpCiHgajgyqpIiWFMSqt0PKCpTrZF82epHBXAb9ZEPQ1V'
    };
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      headers: headers,
    ));

    initializeInterceptors();
  }

  Future<Response> getRequest(String endPoint) async {
    return _dio.get(endPoint);
  }

  initializeInterceptors() {
    _dio.interceptors
        .add(InterceptorsWrapper(onError: (dioError, errorInterceptorHandler) {
      print(dioError.message.toString());
      return errorInterceptorHandler.next(dioError);
    }, onRequest: (requestOptions, requestInterceptorHandler) {
      print("${requestOptions.method} | ${requestOptions.path}");
      print("No error, request is successful");
      return requestInterceptorHandler.next(requestOptions);
    }, onResponse: (response, responseInterceptorHandler) {
      print(response.data);
      print("We have got the response");
      return responseInterceptorHandler.next(response);
    }));
  }
}


// FutureBuilder(
//             future: getListUser(),
//               builder: (context, snapshot) {
//                 if(!snapshot.hasData) {
//                   return CircularProgressIndicator();
//                 }
//                  final List motors = snapshot.hasData as List;
//               return ListView(
//                 padding:  const EdgeInsets.all(16.0),
//                 children:  <Widget>[
//                   const Text('Vehicles page'),
//                   ...motors.map((e) => const ListTile(
//                     title: Text('Get Vehicles'),

//                   ))
//                 ],
//               );}));