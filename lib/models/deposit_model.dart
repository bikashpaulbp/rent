class DepositeModel {
  int? id;
  int? userId;
  int? totalAmount;
  int? depositeAmount;
  int? dueAmount;
  DateTime? tranDate;
  int? rentId;
  int? tenantId;
  int? flatId;
  int? buildingId;

  DepositeModel(
      {this.id,
      this.userId,
      this.totalAmount,
      this.depositeAmount,
      this.dueAmount,
      this.tranDate,
      this.rentId,
      this.tenantId,
      this.flatId,
      this.buildingId});

  DepositeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    totalAmount = json['totalAmount'];
    depositeAmount = json['depositeAmount'];
    dueAmount = json['dueAmount'];
    tranDate =
        json['tranDate'] != null ? DateTime.parse(json['depositeDate']) : null;
    rentId = json['rentId'];
    tenantId = json['tenantId'];
    flatId = json['flatId'];
    buildingId = json['buildingId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['totalAmount'] = this.totalAmount;
    data['depositeAmount'] = this.depositeAmount;
    data['dueAmount'] = this.dueAmount;
    data['tranDate'] = this.tranDate?.toIso8601String();
    data['rentId'] = this.rentId;
    data['tenantId'] = this.tenantId;
    data['flatId'] = this.flatId;
    data['buildingId'] = this.buildingId;
    return data;
  }
}
