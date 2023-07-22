class TenentInfo {
  int? id;
  int floorID;
  String floorName;
  int flatID;
  String flatName;
  String tenentName;
  int nidNo;
  String? passportNo;
  int birthCertificateNo;
  int mobileNo;
  int emgMobileNo;
  int noOfFamilyMem;
  double rentAmount;
  double gasBill;
  double waterBill;
  double serviceCharge;
  double totalAmount;
  String dateOfIn;

  TenentInfo(
      {this.id,
      required this.floorID,
      required this.floorName,
      required this.flatID,
      required this.flatName,
      required this.tenentName,
      required this.nidNo,
      this.passportNo,
      required this.birthCertificateNo,
      required this.mobileNo,
      required this.emgMobileNo,
      required this.noOfFamilyMem,
      required this.rentAmount,
      required this.gasBill,
      required this.waterBill,
      required this.serviceCharge,
      required this.totalAmount,
      required this.dateOfIn});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'floorID': floorID,
      'floorName': floorName,
      'flatID': flatID,
      'flatName': flatName,
      'tenentName': tenentName,
      'nidNo': nidNo,
      'passportNo': passportNo,
      'birthCertificateNo': birthCertificateNo,
      'mobileNo': mobileNo,
      'emgMobileNo': emgMobileNo,
      'noOfFamilyMem': noOfFamilyMem,
      'dateOfIn': dateOfIn,
      'rentAmount': rentAmount,
      'gasBill': gasBill,
      'waterBill': waterBill,
      'serviceCharge': serviceCharge,
      'totalAmount': totalAmount,
    };
  }

  factory TenentInfo.fromJson(Map<String, dynamic> json) => TenentInfo(
        id: json['id'],
        floorID: json['floorID'],
        floorName: json['floorName'],
        flatID: json['flatID'],
        flatName: json['flatName'],
        tenentName: json['tenentName'],
        nidNo: json['nidNo'],
        passportNo: json['passportNo'],
        birthCertificateNo: json['birthCertificateNo'],
        mobileNo: json['mobileNo'],
        emgMobileNo: json['emgMobileNo'],
        noOfFamilyMem: json['noOfFamilyMem'],
        dateOfIn: json['dateOfIn'],
        rentAmount: json['rentAmount'],
        gasBill: json['gasBill'],
        waterBill: json['waterBill'],
        serviceCharge: json['serviceCharge'],
        totalAmount: json['totalAmount'],
      );
}
