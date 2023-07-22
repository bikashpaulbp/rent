// // ignore_for_file: public_member_api_docs, sort_constructors_first
// // ignore_for_file: use_build_context_synchronously

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// import '../classes/floor_info.dart';
// import '../main.dart';
// import 'login_screen.dart';
// import 'package:firebase_core/firebase_core.dart';

// class AddInformationScreen extends StatefulWidget {
//   String? iconText;
//   AddInformationScreen(this.iconText);

//   @override
//   State<AddInformationScreen> createState() => _AddInformationScreenState();
// }

// class _AddInformationScreenState extends State<AddInformationScreen> {
//   var tapColor = Color.fromARGB(255, 121, 121, 121);

//   //floor part backend
//   TextEditingController floorController = TextEditingController();

//   String id = '';

//   @override
//   void dispose() {
//     floorController.dispose();
//     super.dispose();
//   }

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return 
//                             Container(
//                               height: 500,
//                               child: StreamBuilder(
//                                 stream: FirebaseFirestore.instance
//                                     .collection('floor')
//                                     .snapshots(),
//                                 builder: (BuildContext context,
//                                     AsyncSnapshot<QuerySnapshot>
//                                         streamSnapshot) {
//                                   return streamSnapshot.hasData
//                                       ? ListView.builder(
//                                           padding: EdgeInsets.symmetric(
//                                               vertical: 41),
//                                           itemCount:
//                                               streamSnapshot.data!.docs.length,
//                                           itemBuilder: ((context, index) {
//                                             return Container(
//                                                 margin: EdgeInsets.symmetric(
//                                                         horizontal: 20)
//                                                     .copyWith(bottom: 10),
//                                                 padding: EdgeInsets.symmetric(
//                                                     horizontal: 10,
//                                                     vertical: 10),
//                                                 decoration: BoxDecoration(
//                                                     color: Colors.white,
//                                                     boxShadow: [
//                                                       BoxShadow(
//                                                           color: Colors
//                                                               .grey.shade300,
//                                                           blurRadius: 5,
//                                                           spreadRadius: 1,
//                                                           offset: Offset(2, 2))
//                                                     ]),
//                                                 child: Row(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment
//                                                           .spaceBetween,
//                                                   children: [
//                                                     Row(
//                                                       children: [
//                                                         Icon(
//                                                           Icons.person,
//                                                           size: 31,
//                                                           color: Colors
//                                                               .red.shade300,
//                                                         ),
//                                                         SizedBox(width: 11),
//                                                         Column(
//                                                           crossAxisAlignment:
//                                                               CrossAxisAlignment
//                                                                   .start,
//                                                           children: [
//                                                             Text(
//                                                               streamSnapshot
//                                                                           .data!
//                                                                           .docs[
//                                                                       index]
//                                                                   ['floorName'],
//                                                               style: TextStyle(
//                                                                   fontSize: 16,
//                                                                   fontWeight:
//                                                                       FontWeight
//                                                                           .w500),
//                                                             ),
//                                                           ],
//                                                         ),
//                                                       ],
//                                                     ),
//                                                     Row(
//                                                       children: [
//                                                         GestureDetector(
//                                                           onTap: () {
//                                                             Navigator.of(context).push(
//                                                                 MaterialPageRoute(
//                                                                     builder:
//                                                                         (context) =>
//                                                                             Floor(
//                                                                               floorName: streamSnapshot.data!.docs[index]['floorName'],
//                                                                               id: streamSnapshot.data!.docs[index]['id'],
//                                                                             )));
//                                                           },
//                                                           child: Icon(
//                                                             Icons.edit,
//                                                             color: Colors.blue,
//                                                             size: 21,
//                                                           ),
//                                                         ),
//                                                         SizedBox(
//                                                           width: 10,
//                                                         ),
//                                                         GestureDetector(
//                                                           onTap: () async {
//                                                             final docData =
//                                                                 FirebaseFirestore
//                                                                     .instance
//                                                                     .collection(
//                                                                         'floor')
//                                                                     .doc(streamSnapshot
//                                                                             .data!
//                                                                             .docs[index]
//                                                                         ['id']);
//                                                             await docData
//                                                                 .delete();
//                                                           },
//                                                           child: Icon(
//                                                             Icons.delete,
//                                                             color: Colors
//                                                                 .red.shade900,
//                                                             size: 21,
//                                                           ),
//                                                         )
//                                                       ],
//                                                     ),
//                                                   ],
//                                                 ));
//                                           }))
//                                       : Center(
//                                           child: SizedBox(
//                                               height: 100,
//                                               width: 100,
//                                               child:
//                                                   CircularProgressIndicator()),
//                                         );
//                                 },
//                               ),
//                             )
//                           ],
//                         ),
//                       )
//                     : const SizedBox(height: 20),
//                 widget.iconText == 'flat'
//                     ? Container(
//                         width: 500,
//                         height: 500,
//                         decoration: BoxDecoration(
//                             color: const Color.fromARGB(255, 255, 255, 255),
//                             borderRadius: BorderRadius.circular(10),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: const Color.fromARGB(255, 180, 180, 180)
//                                     .withOpacity(0.5),
//                                 spreadRadius: 5,
//                                 blurRadius: 7,
//                                 offset: const Offset(
//                                     0, 3), // changes the position of the shadow
//                               ),
//                             ]),
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Column(
//                             children: [
//                               Column(
//                                 children: [
//                                   Container(
//                                     decoration: BoxDecoration(
//                                       border: Border.all(
//                                         color: const Color.fromARGB(
//                                             255, 134, 134, 134),
//                                         width: 1.0,
//                                       ),
//                                     ),
//                                     padding: const EdgeInsets.only(
//                                         left: 140.0, right: 140.0),
//                                     child: const Text(
//                                       'Flat',
//                                       style: TextStyle(
//                                         fontSize: 24,
//                                         fontWeight: FontWeight.bold,
//                                         color:
//                                             Color.fromARGB(255, 134, 134, 134),
//                                         fontStyle: FontStyle.normal,
//                                         // Add any other desired text style properties here
//                                       ),
//                                     ),
//                                   ),
//                                   Column(
//                                     children: [
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           const SizedBox(
//                                             child: Text(
//                                               'Name',
//                                               style: TextStyle(
//                                                 fontSize: 16,

//                                                 color: Color.fromARGB(
//                                                     255, 78, 78, 78),
//                                                 fontStyle: FontStyle.normal,
//                                                 // Add any other desired text style properties here
//                                               ),
//                                             ),
//                                           ),
//                                           SizedBox(
//                                             width: 250,
//                                             height: 50,
//                                             child: Padding(
//                                               padding:
//                                                   const EdgeInsets.all(8.0),
//                                               child: TextFormField(
//                                                 decoration: InputDecoration(
//                                                     border: OutlineInputBorder(
//                                                         borderRadius:
//                                                             BorderRadius
//                                                                 .circular(10))),
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           const SizedBox(
//                                             child: Text(
//                                               'Floor',
//                                               style: TextStyle(
//                                                 fontSize: 16,

//                                                 color: Color.fromARGB(
//                                                     255, 78, 78, 78),
//                                                 fontStyle: FontStyle.normal,
//                                                 // Add any other desired text style properties here
//                                               ),
//                                             ),
//                                           ),
//                                           SizedBox(
//                                             width: 250,
//                                             height: 50,
//                                             child: Padding(
//                                               padding:
//                                                   const EdgeInsets.all(8.0),
//                                               child: TextFormField(
//                                                 decoration: InputDecoration(
//                                                     border: OutlineInputBorder(
//                                                         borderRadius:
//                                                             BorderRadius
//                                                                 .circular(10))),
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           const SizedBox(
//                                             child: Text(
//                                               'No. Of Master Bedroom',
//                                               style: TextStyle(
//                                                 fontSize: 8,
//                                                 fontWeight: FontWeight.bold,

//                                                 color: Color.fromARGB(
//                                                     255, 78, 78, 78),
//                                                 fontStyle: FontStyle.normal,
//                                                 // Add any other desired text style properties here
//                                               ),
//                                             ),
//                                           ),
//                                           SizedBox(
//                                             width: 250,
//                                             height: 50,
//                                             child: Padding(
//                                               padding:
//                                                   const EdgeInsets.all(8.0),
//                                               child: TextFormField(
//                                                 decoration: InputDecoration(
//                                                     border: OutlineInputBorder(
//                                                         borderRadius:
//                                                             BorderRadius
//                                                                 .circular(10))),
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           const SizedBox(
//                                             child: Text(
//                                               'No. of Bedroom',
//                                               style: TextStyle(
//                                                 fontSize: 12,

//                                                 color: Color.fromARGB(
//                                                     255, 78, 78, 78),
//                                                 fontStyle: FontStyle.normal,
//                                                 // Add any other desired text style properties here
//                                               ),
//                                             ),
//                                           ),
//                                           SizedBox(
//                                             width: 250,
//                                             height: 50,
//                                             child: Padding(
//                                               padding:
//                                                   const EdgeInsets.all(8.0),
//                                               child: TextFormField(
//                                                 decoration: InputDecoration(
//                                                     border: OutlineInputBorder(
//                                                         borderRadius:
//                                                             BorderRadius
//                                                                 .circular(10))),
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           const SizedBox(
//                                             child: Text(
//                                               'Flat Side',
//                                               style: TextStyle(
//                                                 fontSize: 16,

//                                                 color: Color.fromARGB(
//                                                     255, 78, 78, 78),
//                                                 fontStyle: FontStyle.normal,
//                                                 // Add any other desired text style properties here
//                                               ),
//                                             ),
//                                           ),
//                                           SizedBox(
//                                             width: 250,
//                                             height: 50,
//                                             child: Padding(
//                                               padding:
//                                                   const EdgeInsets.all(8.0),
//                                               child: TextFormField(
//                                                 decoration: InputDecoration(
//                                                     border: OutlineInputBorder(
//                                                         borderRadius:
//                                                             BorderRadius
//                                                                 .circular(10))),
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           const SizedBox(
//                                             child: Text(
//                                               'Rent Amount',
//                                               style: TextStyle(
//                                                 fontSize: 16,

//                                                 color: Color.fromARGB(
//                                                     255, 78, 78, 78),
//                                                 fontStyle: FontStyle.normal,
//                                                 // Add any other desired text style properties here
//                                               ),
//                                             ),
//                                           ),
//                                           SizedBox(
//                                             width: 250,
//                                             height: 50,
//                                             child: Padding(
//                                               padding:
//                                                   const EdgeInsets.all(8.0),
//                                               child: TextFormField(
//                                                 decoration: InputDecoration(
//                                                     border: OutlineInputBorder(
//                                                         borderRadius:
//                                                             BorderRadius
//                                                                 .circular(10))),
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           const SizedBox(
//                                             child: Text(
//                                               'No. of Washroom',
//                                               style: TextStyle(
//                                                 fontSize: 12,

//                                                 color: Color.fromARGB(
//                                                     255, 78, 78, 78),
//                                                 fontStyle: FontStyle.normal,
//                                                 // Add any other desired text style properties here
//                                               ),
//                                             ),
//                                           ),
//                                           SizedBox(
//                                             width: 250,
//                                             height: 50,
//                                             child: Padding(
//                                               padding:
//                                                   const EdgeInsets.all(8.0),
//                                               child: TextFormField(
//                                                 decoration: InputDecoration(
//                                                     border: OutlineInputBorder(
//                                                         borderRadius:
//                                                             BorderRadius
//                                                                 .circular(10))),
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           const SizedBox(
//                                             child: Text(
//                                               'Size (Sqrft)',
//                                               style: TextStyle(
//                                                 fontSize: 16,

//                                                 color: Color.fromARGB(
//                                                     255, 78, 78, 78),
//                                                 fontStyle: FontStyle.normal,
//                                                 // Add any other desired text style properties here
//                                               ),
//                                             ),
//                                           ),
//                                           SizedBox(
//                                             width: 250,
//                                             height: 50,
//                                             child: Padding(
//                                               padding:
//                                                   const EdgeInsets.all(8.0),
//                                               child: TextFormField(
//                                                 decoration: InputDecoration(
//                                                     border: OutlineInputBorder(
//                                                         borderRadius:
//                                                             BorderRadius
//                                                                 .circular(10))),
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.only(right: 3),
//                                     child: Row(
//                                       mainAxisAlignment: MainAxisAlignment.end,
//                                       children: [
//                                         Padding(
//                                           padding: const EdgeInsets.symmetric(
//                                               horizontal: 10),
//                                           child: ElevatedButton(
//                                               style: const ButtonStyle(
//                                                   fixedSize:
//                                                       MaterialStatePropertyAll(
//                                                           Size.fromWidth(80))),
//                                               onPressed: () {},
//                                               child: const Text("Save")),
//                                         ),
//                                         ElevatedButton(
//                                             style: const ButtonStyle(
//                                                 fixedSize:
//                                                     MaterialStatePropertyAll(
//                                                         Size.fromWidth(80))),
//                                             onPressed: () {},
//                                             child: const Text("Cancel")),
//                                       ],
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       )
//                     : const SizedBox(
//                         height: 20,
//                       ),
//                 widget.iconText == 'tenent'
//                     ? Container(
//                         width: 500,
//                         height: 450,
//                         decoration: BoxDecoration(
//                             color: const Color.fromARGB(255, 255, 255, 255),
//                             borderRadius: BorderRadius.circular(10),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: const Color.fromARGB(255, 180, 180, 180)
//                                     .withOpacity(0.5),
//                                 spreadRadius: 5,
//                                 blurRadius: 7,
//                                 offset: const Offset(
//                                     0, 3), // changes the position of the shadow
//                               ),
//                             ]),
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Column(
//                             children: [
//                               Column(
//                                 children: [
//                                   Container(
//                                     decoration: BoxDecoration(
//                                       border: Border.all(
//                                         color: const Color.fromARGB(
//                                             255, 134, 134, 134),
//                                         width: 1.0,
//                                       ),
//                                     ),
//                                     padding: const EdgeInsets.only(
//                                         left: 130.0, right: 130.0),
//                                     child: const Text(
//                                       'Tenent',
//                                       style: TextStyle(
//                                         fontSize: 24,
//                                         fontWeight: FontWeight.bold,
//                                         color:
//                                             Color.fromARGB(255, 134, 134, 134),
//                                         fontStyle: FontStyle.normal,
//                                         // Add any other desired text style properties here
//                                       ),
//                                     ),
//                                   ),
//                                   Column(
//                                     children: [
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           const SizedBox(
//                                             child: Text(
//                                               'Name',
//                                               style: TextStyle(
//                                                 fontSize: 16,

//                                                 color: Color.fromARGB(
//                                                     255, 78, 78, 78),
//                                                 fontStyle: FontStyle.normal,
//                                                 // Add any other desired text style properties here
//                                               ),
//                                             ),
//                                           ),
//                                           SizedBox(
//                                             width: 250,
//                                             height: 50,
//                                             child: Padding(
//                                               padding:
//                                                   const EdgeInsets.all(8.0),
//                                               child: TextFormField(
//                                                 decoration: InputDecoration(
//                                                     border: OutlineInputBorder(
//                                                         borderRadius:
//                                                             BorderRadius
//                                                                 .circular(10))),
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           const SizedBox(
//                                             child: Text(
//                                               'NID No.',
//                                               style: TextStyle(
//                                                 fontSize: 16,

//                                                 color: Color.fromARGB(
//                                                     255, 78, 78, 78),
//                                                 fontStyle: FontStyle.normal,
//                                                 // Add any other desired text style properties here
//                                               ),
//                                             ),
//                                           ),
//                                           SizedBox(
//                                             width: 250,
//                                             height: 50,
//                                             child: Padding(
//                                               padding:
//                                                   const EdgeInsets.all(8.0),
//                                               child: TextFormField(
//                                                 decoration: InputDecoration(
//                                                     border: OutlineInputBorder(
//                                                         borderRadius:
//                                                             BorderRadius
//                                                                 .circular(10))),
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           const SizedBox(
//                                             child: Text(
//                                               'Passport No.',
//                                               style: TextStyle(
//                                                 fontSize: 16,

//                                                 color: Color.fromARGB(
//                                                     255, 78, 78, 78),
//                                                 fontStyle: FontStyle.normal,
//                                                 // Add any other desired text style properties here
//                                               ),
//                                             ),
//                                           ),
//                                           SizedBox(
//                                             width: 250,
//                                             height: 50,
//                                             child: Padding(
//                                               padding:
//                                                   const EdgeInsets.all(8.0),
//                                               child: TextFormField(
//                                                 decoration: InputDecoration(
//                                                     border: OutlineInputBorder(
//                                                         borderRadius:
//                                                             BorderRadius
//                                                                 .circular(10))),
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           const SizedBox(
//                                             child: Text(
//                                               'Birth Certificate No.',
//                                               style: TextStyle(
//                                                 fontWeight: FontWeight.bold,
//                                                 fontSize: 10,

//                                                 color: Color.fromARGB(
//                                                     255, 78, 78, 78),
//                                                 fontStyle: FontStyle.normal,
//                                                 // Add any other desired text style properties here
//                                               ),
//                                             ),
//                                           ),
//                                           SizedBox(
//                                             width: 250,
//                                             height: 50,
//                                             child: Padding(
//                                               padding:
//                                                   const EdgeInsets.all(8.0),
//                                               child: TextFormField(
//                                                 decoration: InputDecoration(
//                                                     border: OutlineInputBorder(
//                                                         borderRadius:
//                                                             BorderRadius
//                                                                 .circular(10))),
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           const SizedBox(
//                                             child: Text(
//                                               'Mobile No.',
//                                               style: TextStyle(
//                                                 fontSize: 16,

//                                                 color: Color.fromARGB(
//                                                     255, 78, 78, 78),
//                                                 fontStyle: FontStyle.normal,
//                                                 // Add any other desired text style properties here
//                                               ),
//                                             ),
//                                           ),
//                                           SizedBox(
//                                             width: 250,
//                                             height: 50,
//                                             child: Padding(
//                                               padding:
//                                                   const EdgeInsets.all(8.0),
//                                               child: TextFormField(
//                                                 decoration: InputDecoration(
//                                                     border: OutlineInputBorder(
//                                                         borderRadius:
//                                                             BorderRadius
//                                                                 .circular(10))),
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           const SizedBox(
//                                             child: Text(
//                                               'Emg. Mobile No.',
//                                               style: TextStyle(
//                                                 fontSize: 12,

//                                                 color: Color.fromARGB(
//                                                     255, 78, 78, 78),
//                                                 fontStyle: FontStyle.normal,
//                                                 // Add any other desired text style properties here
//                                               ),
//                                             ),
//                                           ),
//                                           SizedBox(
//                                             width: 250,
//                                             height: 50,
//                                             child: Padding(
//                                               padding:
//                                                   const EdgeInsets.all(8.0),
//                                               child: TextFormField(
//                                                 decoration: InputDecoration(
//                                                     border: OutlineInputBorder(
//                                                         borderRadius:
//                                                             BorderRadius
//                                                                 .circular(10))),
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           const SizedBox(
//                                             child: Text(
//                                               'No. of Family Member',
//                                               style: TextStyle(
//                                                 fontWeight: FontWeight.bold,
//                                                 fontSize: 9,

//                                                 color: Color.fromARGB(
//                                                     255, 78, 78, 78),
//                                                 fontStyle: FontStyle.normal,
//                                                 // Add any other desired text style properties here
//                                               ),
//                                             ),
//                                           ),
//                                           SizedBox(
//                                             width: 250,
//                                             height: 50,
//                                             child: Padding(
//                                               padding:
//                                                   const EdgeInsets.all(8.0),
//                                               child: TextFormField(
//                                                 decoration: InputDecoration(
//                                                     border: OutlineInputBorder(
//                                                         borderRadius:
//                                                             BorderRadius
//                                                                 .circular(10))),
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.only(right: 3),
//                                     child: Row(
//                                       mainAxisAlignment: MainAxisAlignment.end,
//                                       children: [
//                                         Padding(
//                                           padding: const EdgeInsets.symmetric(
//                                               horizontal: 10),
//                                           child: ElevatedButton(
//                                               style: const ButtonStyle(
//                                                   fixedSize:
//                                                       MaterialStatePropertyAll(
//                                                           Size.fromWidth(80))),
//                                               onPressed: () {},
//                                               child: const Text("Save")),
//                                         ),
//                                         ElevatedButton(
//                                             style: const ButtonStyle(
//                                                 fixedSize:
//                                                     MaterialStatePropertyAll(
//                                                         Size.fromWidth(80))),
//                                             onPressed: () {},
//                                             child: const Text("Cancel")),
//                                       ],
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       )
//                     : const SizedBox(height: 20),
//                 widget.iconText == 'rent'
//                     ? Container(
//                         width: 500,
//                         height: 500,
//                         decoration: BoxDecoration(
//                             color: const Color.fromARGB(255, 255, 255, 255),
//                             borderRadius: BorderRadius.circular(10),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: const Color.fromARGB(255, 180, 180, 180)
//                                     .withOpacity(0.5),
//                                 spreadRadius: 5,
//                                 blurRadius: 7,
//                                 offset: const Offset(
//                                     0, 3), // changes the position of the shadow
//                               ),
//                             ]),
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Column(
//                             children: [
//                               Column(
//                                 children: [
//                                   Container(
//                                     decoration: BoxDecoration(
//                                       border: Border.all(
//                                         color: const Color.fromARGB(
//                                             255, 134, 134, 134),
//                                         width: 1.0,
//                                       ),
//                                     ),
//                                     padding: const EdgeInsets.only(
//                                         left: 60.0, right: 60.0),
//                                     child: const Text(
//                                       'Monthly Rent Entry',
//                                       style: TextStyle(
//                                         fontSize: 24,
//                                         fontWeight: FontWeight.bold,
//                                         color:
//                                             Color.fromARGB(255, 134, 134, 134),
//                                         fontStyle: FontStyle.normal,
//                                         // Add any other desired text style properties here
//                                       ),
//                                     ),
//                                   ),
//                                   Column(
//                                     children: [
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           const SizedBox(
//                                             child: Text(
//                                               'Month',
//                                               style: TextStyle(
//                                                 fontSize: 16,

//                                                 color: Color.fromARGB(
//                                                     255, 78, 78, 78),
//                                                 fontStyle: FontStyle.normal,
//                                                 // Add any other desired text style properties here
//                                               ),
//                                             ),
//                                           ),
//                                           SizedBox(
//                                             width: 250,
//                                             height: 50,
//                                             child: Padding(
//                                               padding:
//                                                   const EdgeInsets.all(8.0),
//                                               child: TextFormField(
//                                                 decoration: InputDecoration(
//                                                     border: OutlineInputBorder(
//                                                         borderRadius:
//                                                             BorderRadius
//                                                                 .circular(10))),
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           const SizedBox(
//                                             child: Text(
//                                               'Tenent',
//                                               style: TextStyle(
//                                                 fontSize: 16,

//                                                 color: Color.fromARGB(
//                                                     255, 78, 78, 78),
//                                                 fontStyle: FontStyle.normal,
//                                                 // Add any other desired text style properties here
//                                               ),
//                                             ),
//                                           ),
//                                           SizedBox(
//                                             width: 250,
//                                             height: 50,
//                                             child: Padding(
//                                               padding:
//                                                   const EdgeInsets.all(8.0),
//                                               child: TextFormField(
//                                                 decoration: InputDecoration(
//                                                     border: OutlineInputBorder(
//                                                         borderRadius:
//                                                             BorderRadius
//                                                                 .circular(10))),
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           const SizedBox(
//                                             child: Text(
//                                               'Flat',
//                                               style: TextStyle(
//                                                 fontSize: 16,

//                                                 color: Color.fromARGB(
//                                                     255, 78, 78, 78),
//                                                 fontStyle: FontStyle.normal,
//                                                 // Add any other desired text style properties here
//                                               ),
//                                             ),
//                                           ),
//                                           SizedBox(
//                                             width: 250,
//                                             height: 50,
//                                             child: Padding(
//                                               padding:
//                                                   const EdgeInsets.all(8.0),
//                                               child: TextFormField(
//                                                 decoration: InputDecoration(
//                                                     border: OutlineInputBorder(
//                                                         borderRadius:
//                                                             BorderRadius
//                                                                 .circular(10))),
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           const SizedBox(
//                                             child: Text(
//                                               'Rent Amount',
//                                               style: TextStyle(
//                                                 fontSize: 16,

//                                                 color: Color.fromARGB(
//                                                     255, 78, 78, 78),
//                                                 fontStyle: FontStyle.normal,
//                                                 // Add any other desired text style properties here
//                                               ),
//                                             ),
//                                           ),
//                                           SizedBox(
//                                             width: 250,
//                                             height: 50,
//                                             child: Padding(
//                                               padding:
//                                                   const EdgeInsets.all(8.0),
//                                               child: TextFormField(
//                                                 decoration: InputDecoration(
//                                                     border: OutlineInputBorder(
//                                                         borderRadius:
//                                                             BorderRadius
//                                                                 .circular(10))),
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           const SizedBox(
//                                             child: Text(
//                                               'Gas Bill',
//                                               style: TextStyle(
//                                                 fontSize: 16,

//                                                 color: Color.fromARGB(
//                                                     255, 78, 78, 78),
//                                                 fontStyle: FontStyle.normal,
//                                                 // Add any other desired text style properties here
//                                               ),
//                                             ),
//                                           ),
//                                           SizedBox(
//                                             width: 250,
//                                             height: 50,
//                                             child: Padding(
//                                               padding:
//                                                   const EdgeInsets.all(8.0),
//                                               child: TextFormField(
//                                                 decoration: InputDecoration(
//                                                     border: OutlineInputBorder(
//                                                         borderRadius:
//                                                             BorderRadius
//                                                                 .circular(10))),
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           const SizedBox(
//                                             child: Text(
//                                               'Water Bill',
//                                               style: TextStyle(
//                                                 fontSize: 16,

//                                                 color: Color.fromARGB(
//                                                     255, 78, 78, 78),
//                                                 fontStyle: FontStyle.normal,
//                                                 // Add any other desired text style properties here
//                                               ),
//                                             ),
//                                           ),
//                                           SizedBox(
//                                             width: 250,
//                                             height: 50,
//                                             child: Padding(
//                                               padding:
//                                                   const EdgeInsets.all(8.0),
//                                               child: TextFormField(
//                                                 decoration: InputDecoration(
//                                                     border: OutlineInputBorder(
//                                                         borderRadius:
//                                                             BorderRadius
//                                                                 .circular(10))),
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           const SizedBox(
//                                             child: Text(
//                                               'Service Charge',
//                                               style: TextStyle(
//                                                 fontWeight: FontWeight.bold,
//                                                 fontSize: 12,

//                                                 color: Color.fromARGB(
//                                                     255, 78, 78, 78),
//                                                 fontStyle: FontStyle.normal,
//                                                 // Add any other desired text style properties here
//                                               ),
//                                             ),
//                                           ),
//                                           SizedBox(
//                                             width: 250,
//                                             height: 50,
//                                             child: Padding(
//                                               padding:
//                                                   const EdgeInsets.all(8.0),
//                                               child: TextFormField(
//                                                 decoration: InputDecoration(
//                                                     border: OutlineInputBorder(
//                                                         borderRadius:
//                                                             BorderRadius
//                                                                 .circular(10))),
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           const SizedBox(
//                                             child: Text(
//                                               'Adjustment Amount',
//                                               style: TextStyle(
//                                                 fontWeight: FontWeight.bold,
//                                                 fontSize: 10,

//                                                 color: Color.fromARGB(
//                                                     255, 78, 78, 78),
//                                                 fontStyle: FontStyle.normal,
//                                                 // Add any other desired text style properties here
//                                               ),
//                                             ),
//                                           ),
//                                           SizedBox(
//                                             width: 250,
//                                             height: 50,
//                                             child: Padding(
//                                               padding:
//                                                   const EdgeInsets.all(8.0),
//                                               child: TextFormField(
//                                                 decoration: InputDecoration(
//                                                     border: OutlineInputBorder(
//                                                         borderRadius:
//                                                             BorderRadius
//                                                                 .circular(10))),
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.only(right: 3),
//                                     child: Row(
//                                       mainAxisAlignment: MainAxisAlignment.end,
//                                       children: [
//                                         Padding(
//                                           padding: const EdgeInsets.symmetric(
//                                               horizontal: 10),
//                                           child: ElevatedButton(
//                                               style: const ButtonStyle(
//                                                   fixedSize:
//                                                       MaterialStatePropertyAll(
//                                                           Size.fromWidth(80))),
//                                               onPressed: () {},
//                                               child: const Text("Save")),
//                                         ),
//                                         ElevatedButton(
//                                             style: const ButtonStyle(
//                                                 fixedSize:
//                                                     MaterialStatePropertyAll(
//                                                         Size.fromWidth(80))),
//                                             onPressed: () {},
//                                             child: const Text("Cancel")),
//                                       ],
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       )
//                     : SizedBox(),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
