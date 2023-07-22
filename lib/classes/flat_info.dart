class FlatInfo {
  int? id;
  int floorId;
  String floorName;
  String flatName;
  int noOfMasterbedRoom;
  int noOfBedroom;
  String flatSide;

  int noOfWashroom;
  int flatSize; 

  FlatInfo({
    this.id,
    required this.floorId,
    required this.floorName,
    required this.flatName,
    required this.noOfMasterbedRoom,
    required this.noOfBedroom,
    required this.flatSide,
    required this.noOfWashroom,
    required this.flatSize,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'floorId': floorId,
      'floorName': floorName,
      'flatName': flatName,
      'noOfMasterbedRoom': noOfMasterbedRoom,
      'noOfBedroom': noOfBedroom,
      'flatSide': flatSide,
      'noOfWashroom': noOfWashroom,
      'flatSize': flatSize,
    };
  }

  factory FlatInfo.fromJson(Map<String, dynamic> json) => FlatInfo(
        id: json['id'],
        floorId: json['floorId'],
        floorName: json['floorName'],
        flatName: json['flatName'],
        noOfMasterbedRoom: json['noOfMasterbedRoom'],
        noOfBedroom: json['noOfBedroom'],
        flatSide: json['flatSide'],
        noOfWashroom: json['noOfWashroom'],
        flatSize: json['flatSize'],
      );
}
