class FlatModel {
  int? id;
  String? name;
  int? masterbedRoom;
  int? bedroom;
  int? washroom;
  int? flatSize;
  String? flatSide;
  int? floorId;

  FlatModel(
      {this.id,
      this.name,
      this.masterbedRoom,
      this.flatSize,
      this.flatSide,
      this.floorId,
      this.bedroom,
      this.washroom});

  FlatModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    masterbedRoom = json['masterbedRoom'];
    flatSize = json['flatSize'];
    flatSide = json['flatSide'];
    floorId = json['floorId'];
    washroom = json['washroom'];
    bedroom = json['bedroom'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['masterbedRoom'] = this.masterbedRoom;
    data['flatSize'] = this.flatSize;
    data['flatSide'] = this.flatSide;
    data['floorId'] = this.floorId;
    data['washroom'] = this.washroom;
    data['bedroom'] = this.bedroom;
    return data;
  }
}
