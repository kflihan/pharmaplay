import 'package:freezed_annotation/freezed_annotation.dart';
//import 'package:flutter/foundation.dart';

part 'drug.freezed.dart';
part 'drug.g.dart';

@freezed
class Drug with _$Drug {
  factory Drug(
      {required final int drugID,
      required final String drugNo,
      required final String brandName,
      required final String caliber,
      required final int genericDrugID,
      required final int chemicalDrugID,
      required final int manufactoryID,
      required final int dosageFormID,
      required final int drugClassID,
      required final int drugFamilyID,
      required final String licenseNumber,
      required final String licenseDate,
      required final int drugPrice,
      required final String drugRating}) = _Drug;

  factory Drug.fromJson(Map<String, dynamic> json) => _$DrugFromJson(json);

  factory Drug.blank() => Drug(
      drugID: 0,
      drugNo: '',
      brandName: '',
      caliber: '',
      genericDrugID: 0,
      chemicalDrugID: 0,
      manufactoryID: 0,
      dosageFormID: 0,
      drugClassID: 0,
      drugFamilyID: 0,
      licenseNumber: '',
      licenseDate: '',
      drugPrice: 0,
      drugRating: '');
}
