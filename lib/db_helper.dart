// import 'package:sqflite/sqflite.dart';
// import 'package:moor/moor.dart';

// import 'package:sql_conn/sql_conn.dart';

// import 'classes/deposit.dart';
// import 'classes/flat_info.dart';
// import 'classes/floor_info.dart';
// import 'classes/rent_info.dart';
// import 'classes/tenent_info.dart';


   
//     final conn = await SqlConn.connect(
//       ip: "192.168.1.1",
//       port: "1433",
//       databaseName: "MyDatabase",
//       username: "admin",
//       password: "password",
//     );
   


// Future<void> insertFloor(Floor floor) async {
//   // Get the connection to the database.
//   var conn = await DBHelper.initDB();

//   // Convert the floor object to a map.
//   var data = floor.toJson();

//   // Insert the floor into the database.
//   await SqlConn.writeData(
//     conn.connectionString,
//     query: "INSERT INTO floor (floorName) VALUES (?)",
//     values: [data['floorName']],
//   );
// }
// //floor part
//   Future<int> insertFloorData(Floor floor) async {
//     Database db = await DBHelper.initDB();
//     return await db.insert('floor', floor.toJson());
//   }

//   static Future<List<Floor>> readFloorData() async {
//     Database db = await DBHelper.initDB();
//     var floor = await db.query('floor', orderBy: 'id');
//     List<Floor> floorList =
//         floor.isNotEmpty ? floor.map((e) => Floor.fromJson(e)).toList() : [];
//     return floorList;
//   }

//   static Future<int> updateFloor(Floor floor) async {
//     Database db = await DBHelper.initDB();
//     return await db.update('floor', floor.toJson(),
//         where: 'id = ?', whereArgs: [floor.id]);
//   }

//   static Future<int> deleteFloor(int? id) async {
//     Database db = await DBHelper.initDB();
//     return await db.delete('floor', where: 'id = ?', whereArgs: [id]);
//   }

// //flat part
//   static Future<int> insertFlatData(FlatInfo flat) async {
//     Database db = await DBHelper.initDB();
//     return await db.insert('flat', flat.toJson());
//   }

//   static Future<List<FlatInfo>> readFlatData() async {
//     Database db = await DBHelper.initDB();
//     var flat = await db.query('flat', orderBy: 'id');
//     List<FlatInfo> flatList =
//         flat.isNotEmpty ? flat.map((e) => FlatInfo.fromJson(e)).toList() : [];
//     return flatList;
//   }

//   static Future<int> updateFlat(FlatInfo flat) async {
//     Database db = await DBHelper.initDB();
//     return await db
//         .update('flat', flat.toJson(), where: 'id = ?', whereArgs: [flat.id]);
//   }

//   static Future<int> deleteFlat(int? id) async {
//     Database db = await DBHelper.initDB();
//     return await db.delete('flat', where: 'id = ?', whereArgs: [id]);
//   }

// //tenent part
//   static Future<int> insertTenentData(TenentInfo tenent) async {
//     Database db = await DBHelper.initDB();
//     return await db.insert('tenent', tenent.toJson());
//   }

//   static Future<List<TenentInfo>> readTenentData() async {
//     Database db = await DBHelper.initDB();
//     var tenent = await db.query('tenent', orderBy: 'id');
//     List<TenentInfo> tenentList = tenent.isNotEmpty
//         ? tenent.map((e) => TenentInfo.fromJson(e)).toList()
//         : [];
//     return tenentList;
//   }

//   static Future<int> updateTenent(TenentInfo tenent) async {
//     Database db = await DBHelper.initDB();
//     return await db.update('tenent', tenent.toJson(),
//         where: 'id = ?', whereArgs: [tenent.id]);
//   }

//   static Future<int> deleteTenent(int? id) async {
//     Database db = await DBHelper.initDB();
//     return await db.delete('tenent', where: 'id = ?', whereArgs: [id]);
//   }

//   // rent part

//   static Future<int> insertRentData(RentInfo rent) async {
//     Database db = await DBHelper.initDB();
//     return await db.insert('rent', rent.toJson());
//   }

//   static Future<List<RentInfo>> readRentData() async {
//     Database db = await DBHelper.initDB();
//     var rent = await db.query('rent', orderBy: 'id');
//     List<RentInfo> rentList =
//         rent.isNotEmpty ? rent.map((e) => RentInfo.fromJson(e)).toList() : [];
//     return rentList;
//   }

//   static Future<int> updateRent(RentInfo rent) async {
//     Database db = await DBHelper.initDB();
//     return await db
//         .update('rent', rent.toJson(), where: 'id = ?', whereArgs: [rent.id]);
//   }

//   static Future<int> deleteRent(int? id) async {
//     Database db = await DBHelper.initDB();
//     return await db.delete('rent', where: 'id = ?', whereArgs: [id]);
//   }

//   // deposit part
//   static Future<int> insertDepositData(Deposit deposit) async {
//     Database db = await DBHelper.initDB();
//     return await db.insert('deposit', deposit.toJson());
//   }

//   static Future<List<Deposit>> readDepositData() async {
//     Database db = await DBHelper.initDB();
//     var deposit = await db.query('deposit', orderBy: 'id, flatID, tenantID');
//     List<Deposit> depositList = deposit.isNotEmpty
//         ? deposit.map((e) => Deposit.fromJson(e)).toList()
//         : [];
//     return depositList;
//   }

//   static Future<int> updateDeposit(Deposit deposit) async {
//     Database db = await DBHelper.initDB();
//     return await db.update('deposit', deposit.toJson(),
//         where: 'id = ?', whereArgs: [deposit.id]);
//   }

//   static Future<int> deleteDeposit(int? id) async {
//     Database db = await DBHelper.initDB();
//     return await db.delete('deposit', where: 'id = ?', whereArgs: [id]);
//   }
// }
