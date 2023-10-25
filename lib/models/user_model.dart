class UserModel {
  int? id;
  String? name;
  int? propertyInfoId;
  String? password;
  bool? isActive;
  String? email;
  String? mobileNo;
  bool? isLoggedIn;
  bool? isRegularUser;
  bool? isAdmin;

  UserModel(
      {this.id,
      this.name,
      this.propertyInfoId,
      this.password,
      this.isActive,
      this.email,
      this.mobileNo,
      this.isLoggedIn,
      this.isRegularUser,
      this.isAdmin});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    propertyInfoId = json['propertyInfoId'];
    password = json['password'];
    isActive = json['isActive'];
    email = json['email'];
    mobileNo = json['mobileNo'];
    isLoggedIn = json['isLoggedIn'];
    isRegularUser = json['isRegularUser'];
    isAdmin = json['isAdmin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['propertyInfoId'] = this.propertyInfoId;
    data['password'] = this.password;
    data['isActive'] = this.isActive;
    data['email'] = this.email;
    data['mobileNo'] = this.mobileNo;
    data['isLoggedIn'] = this.isLoggedIn;
    data['isRegularUser'] = this.isRegularUser;
    data['isAdmin'] = this.isAdmin;
    return data;
  }
}
