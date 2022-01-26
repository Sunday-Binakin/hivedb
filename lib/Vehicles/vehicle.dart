import 'package:json_annotation/json_annotation.dart';

part 'vehicle.g.dart';

@JsonSerializable()
class Motor {
  @JsonKey(name: "VEHICLE_TYPE")
  String vehicleType;

  @JsonKey(name: "MAKE")
  String make;

  @JsonKey(name: "REGISTERED_NUMBER")
  String registrationNumber;

  Motor({
    required this.make,
    required this.registrationNumber,
    required this.vehicleType,
  });

  factory Motor.fromJson(Map<String, dynamic> json) => _$MotorFromJson(json);

  Map<String, dynamic> toJson() => _$MotorToJson(this);
}
