class RentInfo {
  int? id;
  // int floorID;
  // String floorName;
  int flatID;
  String flatName;
  int tenentID;
  String tenentName;
  double totalAmount;
  String month;
  int? isPaid;

  RentInfo({
    this.id,
    // required this.floorID,
    // required this.floorName,
    required this.flatID,
    required this.flatName,
    required this.tenentID,
    required this.tenentName,
    required this.totalAmount,
    required this.month,
    required this.isPaid,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      // 'floorID': floorID,
      // 'floorName': floorName,
      'flatID': flatID,
      'flatName': flatName,
      'tenentID': tenentID,
      'tenentName': tenentName,
      'totalAmount': totalAmount,
      'month': month,
      'isPaid': isPaid,
    };
  }

  factory RentInfo.fromJson(Map<String, dynamic> json) => RentInfo(
        id: json['id'],
        // floorID: json['floorID'],
        // floorName: json['floorName'],
        flatID: json['flatID'],
        flatName: json['flatName'],
        tenentID: json['tenentID'],
        tenentName: json['tenentName'],
        month: json['month'],
        totalAmount: json['totalAmount'],
        isPaid: json['isPaid'],
      );
}
