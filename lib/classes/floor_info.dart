class Floor {
  int? id;
  String floorName;

  Floor({required this.floorName, this.id});

  factory Floor.fromJson(Map<String, dynamic> json) =>
      Floor(floorName: json['floorName'], id: json['id']);

  Map<String, dynamic> toJson() => {'id': id, 'floorName': floorName};
}
