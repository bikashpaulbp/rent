// import 'package:flutter/material.dart';
// import 'package:rent_management/classes/floor_info.dart';

// import '../db_helper.dart';

// class test extends StatefulWidget {
//   test({super.key});

//   @override
//   State<test> createState() => _testState();
// }

// class _testState extends State<test> {
//   late Future<List<Floor>> floorStream;

//   @override
//   void initState() {
//     DBHelper.initDB();
//     floorStream = DBHelper.readFloorData();
//     setState(() {});
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         color: Colors.amber,
//         constraints: BoxConstraints(
//           maxHeight: MediaQuery.of(context).size.height * 0.5,
//         ),
//         child: FutureBuilder<List<Floor>>(
//           future: floorStream, // Stream of floor data
//           builder: (context, snapshot) {
//             if (snapshot.hasData) {
//               List<Floor> floorList = snapshot.data!;

//               return ListView.builder(
//                 itemCount: floorList.length,
//                 itemBuilder: (context, index) {
//                   Floor floor = floorList[index];

//                   return ListTile(
//                     title: Text(
//                       floor.floorName.toString(),
//                       style: TextStyle(color: Colors.black),
//                     ),
//                   );
//                 },
//               );
//             } else if (snapshot.hasError) {
//               return Text('Error: ${snapshot.error}');
//             } else {
//               return const CircularProgressIndicator();
//             }
//           },
//         ),
//       ),
//     );
//   }
// }
