class IncidentType {

  int id;
  String name;

  IncidentType(this.id, this.name);

  

  IncidentType.fromJson(Map<String, dynamic> json)
      : id = json['ID'] as int,
        name =json['INCIDENT_NAME'] as String;


}