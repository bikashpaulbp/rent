class IncomeExpenseModel {
  int? id;
  int? incomeExpenseType;
  String? name;
  int? userId;
  int? buildingId;

  IncomeExpenseModel(
      {this.id,
      this.incomeExpenseType,
      this.name,
      this.userId,
      this.buildingId});

  IncomeExpenseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    incomeExpenseType = json['incomeExpenseType'];
    name = json['name'];
    userId = json['userId'];
    buildingId = json['buildingId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['incomeExpenseType'] = this.incomeExpenseType;
    data['name'] = this.name;
    data['userId'] = this.userId;
    data['buildingId'] = this.buildingId;
    return data;
  }
}
