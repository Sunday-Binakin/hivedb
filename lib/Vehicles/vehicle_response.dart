// import 'package:ghana_issue/motor.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:rescue_app/jose/motor.dart';

part 'motor_response.g.dart';

@JsonSerializable()
class MotorUserResponse {
  MotorUserResponse();

  @JsonKey(name: "status")
  late String status;

  @JsonKey(name: "msg")
  late String message;

  @JsonKey(name: "code")
  late String code;

  @JsonKey(name: "data")
  late List<Motor> motors;

  factory MotorUserResponse.fromJson(Map<String, dynamic> json) =>
      _$MotorUserResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MotorUserResponseToJson(this);
}
