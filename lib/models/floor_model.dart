class FloorModel {
  int? id;
  int? userId;
  int? buildingId;
  String? name;
  bool? isActive;

  FloorModel({this.id, this.userId, this.buildingId, this.name, this.isActive});

  FloorModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    buildingId = json['buildingId'];
    name = json['name'];
    isActive = json['isActive']; 
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['buildingId'] = this.buildingId;
    data['name'] = this.name;
    data['isActive'] = this.isActive;
    return data;
  }
}
