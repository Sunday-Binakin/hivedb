

class EndPoints{

  static final apiToken = 'Bearer EpU4KNeYpAs5vVNRpCiHgajgyqpIiWFMSqt0PKCpTrZF82epHBXAb9ZEPQ1V';

  static const apiBaseUrl = "http://45.79.223.192/rsmsp/api/mobile";
  static const loginUserUrl= EndPoints.apiBaseUrl+"/auth/user/login";
  static const getRegionsUrl= EndPoints.apiBaseUrl+"/regions";
  static const String getIncidentsUrl = EndPoints.apiBaseUrl + "/rss/incidents";
 


  static const changePasswordUrl= EndPoints.apiBaseUrl+"/auth/user/passReset";
  static const addVehicleUrl= EndPoints.apiBaseUrl+"/client/vehicles";

  // Vehicles page
  static const getClientVehicles= EndPoints.apiBaseUrl+"/client/vehicles/";

//  Transactions Page
  // static final momoPayUrl = EndPoints.apiBaseUrl + "/payments/momo";

  // // Request Tow Page
  // static final  callout= EndPoints.apiBaseUrl + "/callouts";

  // REPORT INCIDENT page
  static final String reportIncident= EndPoints.apiBaseUrl + "/rss/incidentReports";

  // //Service Tracking Activity
  // static final String getServiceTracking = EndPoints.apiBaseUrl + "/clients/callouts/";

  // //RSS Feeds Activity
  // static final String getRssFeeds = EndPoints.apiBaseUrl + "/rss/incidentReports";






}