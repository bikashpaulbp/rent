class IncomeExpenseTransactionModel {
  int? id;
  int? buildingId;
  int? incomeExpenseId;
  DateTime? tranDate;
  String? name;
  double? amount;
  int? rentId;
  int? userId;

  IncomeExpenseTransactionModel(
      {this.id,
      this.buildingId,
      this.incomeExpenseId,
      this.tranDate,
      this.name,
      this.amount,
      this.rentId,
      this.userId});

  IncomeExpenseTransactionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    buildingId = json['buildingId'];
    incomeExpenseId = json['incomeExpenseId'];
    tranDate =
        json['tranDate'] != null ? DateTime.parse(json['tranDate']) : null;
    name = json['name'];
    amount = json['amount'];
    rentId = json['rentId'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['buildingId'] = this.buildingId;
    data['incomeExpenseId'] = this.incomeExpenseId;
    data['tranDate'] = this.tranDate?.toIso8601String();
    data['name'] = this.name;
    data['amount'] = this.amount;
    data['rentId'] = this.rentId;
    data['userId'] = this.userId;
    return data;
  }
}
