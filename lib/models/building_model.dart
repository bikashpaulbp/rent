class BuildingModel {
  int? id;
  String? name;
  String? address;
  int? userId;
  bool? isActive;

  BuildingModel({this.id, this.name, this.address, this.userId, this.isActive});

  BuildingModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    userId = json['userId'];
    isActive = json['isActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['address'] = this.address;
    data['userId'] = this.userId;
    data['isActive'] = this.isActive;
    return data;
  }
}
