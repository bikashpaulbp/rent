class RentModel {
  int? id;
  DateTime? rentMonth;
  double? totalAmount;
  bool? isPaid;
  int? flatId;
  int? tenantId;

  RentModel(
      {this.id,
      this.rentMonth,
      this.totalAmount, 
      this.isPaid,
      this.flatId,
      this.tenantId});

  RentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    rentMonth =
        json['rentMonth'] != null ? DateTime.parse(json['rentMonth']) : null;
    totalAmount = json['totalAmount']?.toDouble() ?? 0.0;
    isPaid = json['isPaid'];
    flatId = json['flatId'];
    tenantId = json['tenantId'];
  }
 
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['rentMonth'] = this.rentMonth?.toIso8601String();
    data['totalAmount'] = this.totalAmount;
    data['isPaid'] = this.isPaid;
    data['flatId'] = this.flatId;
    data['tenantId'] = this.tenantId;
    return data;
  }
}
