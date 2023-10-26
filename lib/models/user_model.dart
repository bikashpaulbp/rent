class UserModel {
  int? id;
  String? name;

  String? password;

  String? email;
  String? mobileNo;

  UserModel({this.id, this.name, this.password, this.email, this.mobileNo});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];

    password = json['password'];

    email = json['email'];
    mobileNo = json['mobileNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;

    data['password'] = this.password;

    data['email'] = this.email;
    data['mobileNo'] = this.mobileNo;

    return data;
  }
}
