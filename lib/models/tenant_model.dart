import 'dart:convert';
import 'dart:typed_data';

class TenantModel {
  int? id;
  int? buildingId;
  int? userId;
  String? name;
  String? nid;
  String? passportNo;
  String? birthCertificateNo;
  String? mobileNo;
  String? emgMobileNo;
  int? noofFamilyMember;
  DateTime? arrivalDate;
  int? advanceAmount;
  bool? isActive;
  Uint8List? tenantImage;
  Uint8List? tenantNidImage;
  DateTime? rentAmountChangeDate;

  TenantModel({
    this.id,
    this.buildingId,
    this.userId,
    this.name,
    this.nid,
    this.passportNo,
    this.birthCertificateNo,
    this.mobileNo,
    this.emgMobileNo,
    this.noofFamilyMember,
    this.arrivalDate,
    this.advanceAmount,
    this.isActive,
    this.tenantImage,
    this.tenantNidImage,
    this.rentAmountChangeDate,
  });

  factory TenantModel.fromJson(Map<String, dynamic> json) {
    var tenantImageBytes =
        json['tenantImage'] != null ? base64Decode(json['tenantImage']) : null;
    var tenantNidImageBytes = json['tenantNidImage'] != null
        ? base64Decode(json['tenantNidImage'])
        : null;

    return TenantModel(
      id: json['id'],
      buildingId: json['buildingId'],
      userId: json['userId'],
      name: json['name'],
      nid: json['nid'],
      passportNo: json['passportNo'],
      birthCertificateNo: json['birthCertificateNo'],
      mobileNo: json['mobileNo'],
      emgMobileNo: json['emgMobileNo'],
      noofFamilyMember: json['noofFamilyMember'],
      arrivalDate: json['arrivalDate'] != null
          ? DateTime.parse(json['arrivalDate'])
          : null,
      advanceAmount: json['advanceAmount'],
      isActive: json['isActive'],
      tenantImage: tenantImageBytes,
      tenantNidImage: tenantNidImageBytes,
      rentAmountChangeDate: json['rentAmountChangeDate'] != null
          ? DateTime.parse(json['rentAmountChangeDate'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['buildingId'] = this.buildingId;
    data['userId'] = this.userId;
    data['name'] = this.name;
    data['nid'] = this.nid;
    data['passportNo'] = this.passportNo;
    data['birthCertificateNo'] = this.birthCertificateNo;
    data['mobileNo'] = this.mobileNo;
    data['emgMobileNo'] = this.emgMobileNo;
    data['noofFamilyMember'] = this.noofFamilyMember;
    data['arrivalDate'] = this.arrivalDate?.toIso8601String();
    data['advanceAmount'] = this.advanceAmount;
    data['isActive'] = this.isActive;
    data['tenantImage'] =
        this.tenantImage != null ? base64Encode(this.tenantImage!) : null;
    data['tenantNidImage'] =
        this.tenantNidImage != null ? base64Encode(this.tenantNidImage!) : null;
    data['rentAmountChangeDate'] = this.rentAmountChangeDate?.toIso8601String();
    return data;
  }
}
