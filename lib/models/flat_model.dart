class FlatModel {
  int? id;
  String? name;
  int? masterbedRoom;
  int? bedroom;
  int? washroom;
  int? flatSize;
  String? flatSide;
  int? floorId;
  int? userId;
  int? tenantId;
  bool? isActive;
  int? rentAmount;
  int? gasBill;
  int? waterBill;
  int? serviceCharge;
  int? buildingId;

  FlatModel(
      {this.id,
      this.name,
      this.masterbedRoom,
      this.bedroom,
      this.washroom,
      this.flatSize,
      this.flatSide,
      this.floorId,
      this.userId,
      this.tenantId,
      this.isActive,
      this.rentAmount,
      this.gasBill,
      this.waterBill,
      this.serviceCharge,
      this.buildingId});

  FlatModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    masterbedRoom = json['masterbedRoom'];
    bedroom = json['bedroom'];
    washroom = json['washroom'];
    flatSize = json['flatSize'];
    flatSide = json['flatSide'];
    floorId = json['floorId'];
    userId = json['userId'];
    tenantId = json['tenantId'];
    isActive = json['isActive'];
    rentAmount = json['rentAmount'];
    gasBill = json['gasBill'];
    waterBill = json['waterBill'];
    serviceCharge = json['serviceCharge'];
    buildingId = json['buildingId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['masterbedRoom'] = this.masterbedRoom;
    data['bedroom'] = this.bedroom;
    data['washroom'] = this.washroom;
    data['flatSize'] = this.flatSize;
    data['flatSide'] = this.flatSide;
    data['floorId'] = this.floorId;
    data['userId'] = this.userId;
    data['tenantId'] = this.tenantId;
    data['isActive'] = this.isActive;
    data['rentAmount'] = this.rentAmount;
    data['gasBill'] = this.gasBill;
    data['waterBill'] = this.waterBill;
    data['serviceCharge'] = this.serviceCharge;
    data['buildingId'] = this.buildingId;
    return data;
  }
}
