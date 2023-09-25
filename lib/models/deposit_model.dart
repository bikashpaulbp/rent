class DepositeModel {
  int? id;
  double? totalAmount;
  double? depositeAmount;
  double? dueAmount;
  DateTime? depositeDate;
  int? rentId;

  DepositeModel(
      {this.id,
      this.totalAmount,
      this.depositeAmount,
      this.dueAmount,
      this.depositeDate,
      this.rentId});

  DepositeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    totalAmount = json['totalAmount']?.toDouble() ?? 0.0;
    depositeAmount = json['depositeAmount']?.toDouble() ?? 0.0;
    dueAmount = json['dueAmount']?.toDouble() ?? 0.0;
    depositeDate = json['depositeDate'] != null
        ? DateTime.parse(json['depositeDate'])
        : null;
    rentId = json['rentId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['totalAmount'] = this.totalAmount;
    data['depositeAmount'] = this.depositeAmount;
    data['dueAmount'] = this.dueAmount;
    data['depositeDate'] = this.depositeDate?.toIso8601String();
    data['rentId'] = this.rentId;
    return data;
  }
}
