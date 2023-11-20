class RentModel {
  int? id;
  DateTime? rentMonth;
  int? rentAmount;
  int? gasBill;
  int? waterBill;
  int? serviceCharge;
  int? totalAmount;
  int? dueAmount;
  bool? isPaid;
  int? flatId;
  int? buildingId;
  int? userId;
  int? tenantId;
  bool? isPrinted;
  String? reciptNo;

  RentModel(
      {this.id,
      this.rentMonth,
      this.rentAmount,
      this.gasBill,
      this.waterBill,
      this.serviceCharge,
      this.totalAmount,
      this.dueAmount,
      this.isPaid,
      this.flatId,
      this.buildingId,
      this.userId,
      this.tenantId,
      this.isPrinted,
      this.reciptNo});

  RentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    rentMonth =
        json['rentMonth'] != null ? DateTime.parse(json['rentMonth']) : null;
    rentAmount = json['rentAmount'];
    gasBill = json['gasBill'];
    waterBill = json['waterBill'];
    serviceCharge = json['serviceCharge'];
    totalAmount = json['totalAmount'];
    dueAmount = json['dueAmount'];
    isPaid = json['isPaid'];
    flatId = json['flatId'];
    buildingId = json['buildingId'];
    userId = json['userId'];
    tenantId = json['tenantId'];
    isPrinted = json['isPrinted'];
    reciptNo = json['reciptNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['rentMonth'] = this.rentMonth?.toIso8601String();
    data['rentAmount'] = this.rentAmount;
    data['gasBill'] = this.gasBill;
    data['waterBill'] = this.waterBill;
    data['serviceCharge'] = this.serviceCharge;
    data['totalAmount'] = this.totalAmount;
    data['dueAmount'] = this.dueAmount;
    data['isPaid'] = this.isPaid;
    data['flatId'] = this.flatId;
    data['buildingId'] = this.buildingId;
    data['userId'] = this.userId;
    data['tenantId'] = this.tenantId;
    data['isPrinted'] = this.isPrinted;
    data['reciptNo'] = this.reciptNo;
    return data;
  }
}
