// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'motor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Motor _$MotorFromJson(Map<String, dynamic> json) => Motor(
      make: json['MAKE'] as String,
      registrationNumber: json['REGISTERED_NUMBER'] as String,
      vehicleType: json['VEHICLE_TYPE'] as String,
    );

Map<String, dynamic> _$MotorToJson(Motor instance) => <String, dynamic>{
      'VEHICLE_TYPE': instance.vehicleType,
      'MAKE': instance.make,
      'REGISTERED_NUMBER': instance.registrationNumber,
    };
