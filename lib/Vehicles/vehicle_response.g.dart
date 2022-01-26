// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'motor_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MotorUserResponse _$MotorUserResponseFromJson(Map<String, dynamic> json) =>
    MotorUserResponse()
      ..status = json['status'] as String
      ..message = json['msg'] as String
      ..code = json['code'] as String
      ..motors = (json['data'] as List<dynamic>)
          .map((e) => Motor.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$MotorUserResponseToJson(MotorUserResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'msg': instance.message,
      'code': instance.code,
      'data': instance.motors,
    };
