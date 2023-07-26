import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'classes/flat_info.dart';
import 'classes/floor_info.dart';
import 'classes/rent_info.dart';
import 'classes/tenent_info.dart';

class DBHelper {
  static Future<Database> initDB() async {
    var dpPath = await getDatabasesPath();
    String path = join(dpPath, 'rentmanagement.db');
    return await openDatabase(path, version: 2, onCreate: _onCreate);
  }

  static Future _onCreate(Database db, int version) async {
    await db.execute('''CREATE TABLE floor (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        floorName TEXT)''');

    await db.execute('''CREATE TABLE flat (

      id INTEGER PRIMARY KEY AUTOINCREMENT, 
      floorId INTEGER, 
      floorName TEXT,
      flatName TEXT, 
      noOfMasterbedRoom INTEGER, 
      noOfBedroom INTEGER, 
      flatSide TEXT,  
      noOfWashroom INTEGER, 
      flatSize INTEGER NULL
      )''');

    await db.execute('''CREATE TABLE rent (

      id INTEGER PRIMARY KEY AUTOINCREMENT,
      floorID INTEGER,
      floorName TEXT,
      flatID INTEGER,
      flatName TEXT,
      tenentID INTEGER,
      tenentName TEXT,
      totalAmount DOUBLE,
      month TEXT,
      isPaid INTEGER      
      )''');

    await db.execute('''CREATE TABLE tenent (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      floorID INTEGER,
      floorName TEXT,
      flatID INTEGER,
      flatName TEXT,
      tenentName TEXT,
      nidNo INTEGER NULL,
      passportNo TEXT NULL,
      birthCertificateNo INTEGER NULL,
      mobileNo INTEGER NULL,
      emgMobileNo INTEGER NULL,
      noOfFamilyMem INTEGER NULL,
      dateOfIn TEXT,
      rentAmount DOUBLE,
      gasBill DOUBLE NULL,
      waterBill DOUBLE NULL,
      serviceCharge DOUBLE NULL,
      totalAmount DOUBLE 
      )''');
  }

//floor part
  static Future<int> insertFloorData(Floor floor) async {
    Database db = await DBHelper.initDB();
    return await db.insert('floor', floor.toJson());
  }

  static Future<List<Floor>> readFloorData() async {
    Database db = await DBHelper.initDB();
    var floor = await db.query('floor', orderBy: 'id');
    List<Floor> floorList =
        floor.isNotEmpty ? floor.map((e) => Floor.fromJson(e)).toList() : [];
    return floorList;
  }

  static Future<int> updateFloor(Floor floor) async {
    Database db = await DBHelper.initDB();
    return await db.update('floor', floor.toJson(),
        where: 'id = ?', whereArgs: [floor.id]);
  }

  static Future<int> deleteFloor(int? id) async {
    Database db = await DBHelper.initDB();
    return await db.delete('floor', where: 'id = ?', whereArgs: [id]);
  }

//flat part
  static Future<int> insertFlatData(FlatInfo flat) async {
    Database db = await DBHelper.initDB();
    return await db.insert('flat', flat.toJson());
  }

  static Future<List<FlatInfo>> readFlatData() async {
    Database db = await DBHelper.initDB();
    var flat = await db.query('flat', orderBy: 'id');
    List<FlatInfo> flatList =
        flat.isNotEmpty ? flat.map((e) => FlatInfo.fromJson(e)).toList() : [];
    return flatList;
  }

  static Future<int> updateFlat(FlatInfo flat) async {
    Database db = await DBHelper.initDB();
    return await db
        .update('flat', flat.toJson(), where: 'id = ?', whereArgs: [flat.id]);
  }

  static Future<int> deleteFlat(int? id) async {
    Database db = await DBHelper.initDB();
    return await db.delete('flat', where: 'id = ?', whereArgs: [id]);
  }

//tenent part
  static Future<int> insertTenentData(TenentInfo tenent) async {
    Database db = await DBHelper.initDB();
    return await db.insert('tenent', tenent.toJson());
  }

  static Future<List<TenentInfo>> readTenentData() async {
    Database db = await DBHelper.initDB();
    var tenent = await db.query('tenent');
    List<TenentInfo> tenentList = tenent.isNotEmpty
        ? tenent.map((e) => TenentInfo.fromJson(e)).toList()
        : [];
    return tenentList;
  }

  static Future<int> updateTenent(TenentInfo tenent) async {
    Database db = await DBHelper.initDB();
    return await db.update('tenent', tenent.toJson(),
        where: 'id = ?', whereArgs: [tenent.id]);
  }

  static Future<int> deleteTenent(int? id) async {
    Database db = await DBHelper.initDB();
    return await db.delete('tenent', where: 'id = ?', whereArgs: [id]);
  }

  // rent part

  static Future<int> insertRentData(RentInfo rent) async {
    Database db = await DBHelper.initDB();
    return await db.insert('rent', rent.toJson());
  }

  static Future<List<RentInfo>> readRentData() async {
    Database db = await DBHelper.initDB();
    var rent = await db.query('rent');
    List<RentInfo> rentList =
        rent.isNotEmpty ? rent.map((e) => RentInfo.fromJson(e)).toList() : [];
    return rentList;
  }

  static Future<int> updateRent(RentInfo rent) async {
    Database db = await DBHelper.initDB();
    return await db
        .update('rent', rent.toJson(), where: 'id = ?', whereArgs: [rent.id]);
  }

  static Future<int> deleteRent(int? id) async {
    Database db = await DBHelper.initDB();
    return await db.delete('rent', where: 'id = ?', whereArgs: [id]);
  }
}
