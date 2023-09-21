class TenantModel {
  int? id;
  String? name;
  String? nid;
  String? passportNo;
  String? birthCertificateNo;
  String? mobileNo;
  String? emgMobileNo;
  int? noofFamilyMember;
  DateTime? arrivalDate;
  double? rentAmount;
  double? utilityBill; 
  double? gasBill;
  double? waterBill;
  double? totalAmount;
  int? flatId;

  TenantModel(
      {this.id,
      this.name,
      this.nid,
      this.passportNo,
      this.birthCertificateNo,
      this.mobileNo,
      this.emgMobileNo,
      this.noofFamilyMember,
      this.arrivalDate,
      this.rentAmount,
      this.utilityBill,
      this.gasBill,
      this.waterBill,
      this.totalAmount,
      this.flatId});

  TenantModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'].toString();
    nid = json['nid'].toString();
    passportNo = json['passportNo'].toString();
    birthCertificateNo = json['birthCertificateNo'].toString();
    mobileNo = json['mobileNo'].toString();
    emgMobileNo = json['emgMobileNo'].toString();
    noofFamilyMember = json['noofFamilyMember'];
    arrivalDate = json['arrivalDate'] != null
        ? DateTime.parse(json['arrivalDate'])
        : null;
    rentAmount = json['rentAmount']?.toDouble() ?? 0.0;
    utilityBill = json['utilityBill']?.toDouble() ?? 0.0;
    gasBill = json['gasBill']?.toDouble() ?? 0.0;
    waterBill = json['waterBill']?.toDouble() ?? 0.0;
    totalAmount = json['totalAmount']?.toDouble() ?? 0.0;
    flatId = json['flatId'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['nid'] = this.nid;
    data['passportNo'] = this.passportNo;
    data['birthCertificateNo'] = this.birthCertificateNo;
    data['mobileNo'] = this.mobileNo;
    data['emgMobileNo'] = this.emgMobileNo;
    data['noofFamilyMember'] = this.noofFamilyMember;
    data['arrivalDate'] = this.arrivalDate?.toIso8601String();
    data['rentAmount'] = this.rentAmount;
    data['utilityBill'] = this.utilityBill;
    data['gasBill'] = this.gasBill;
    data['waterBill'] = this.waterBill;
    data['totalAmount'] = this.totalAmount;
    data['flatId'] = this.flatId;
    return data;
  }
}
