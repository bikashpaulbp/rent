class Deposit {
  int? id;
  int rentID;
  String rentMonth;
  int tenantID;
  String tenantName;
  int flatID;
  String flatName;
  int totalAmount;
  int depositAmount;
  int dueAmount;
  String date;

  Deposit(
      {this.id,
      required this.rentID,
      required this.rentMonth,
      required this.tenantID,
      required this.tenantName,
      required this.flatID,
      required this.flatName,
      required this.totalAmount,
      required this.depositAmount,
      required this.dueAmount,
      required this.date});

  factory Deposit.fromJson(Map<String, dynamic> json) => Deposit(
      id: json['id'],
      rentID: json['rentID'],
      rentMonth: json['rentMonth'],
      tenantID: json['tenantID'],
      tenantName: json['tenantName'],
      flatID: json['flatID'],
      flatName: json['flatName'],
      totalAmount: json['totalAmount'],
      depositAmount: json['depositAmount'],
      dueAmount: json['dueAmount'],
      date: json['date']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'rentID': rentID,
        'rentMonth': rentMonth,
        'tenantID': tenantID,
        'tenantName': tenantName,
        'flatID': flatID,
        'flatName': flatName,
        'totalAmount': totalAmount,
        'depositAmount': depositAmount,
        'dueAmount': dueAmount,
        'date': date
      };
}
