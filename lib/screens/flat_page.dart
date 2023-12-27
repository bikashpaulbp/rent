import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rent_management/models/flat_model.dart';
import 'package:rent_management/models/floor_model.dart';
import 'package:rent_management/models/tenant_model.dart';
import 'package:rent_management/models/user_model.dart';
import 'package:rent_management/screens/login_screen.dart';
import 'package:rent_management/services/flat_service.dart';
import 'package:rent_management/services/floor_service.dart';

import 'package:provider/provider.dart';
import 'package:rent_management/services/tenant_service.dart';
import 'package:rent_management/shared_data/floor_data.dart';
import 'package:rent_management/shared_data/tenent_data.dart';
import 'package:velocity_x/velocity_x.dart';

import '../insert_data/flat.dart';

class FlatPage extends StatefulWidget {
  const FlatPage({Key? key}) : super(key: key);

  @override
  State<FlatPage> createState() => _FlatPageState();
}

class _FlatPageState extends State<FlatPage> {
  FlatApiService flatApiService = FlatApiService();
  FloorApiService floorApiService = FloorApiService();
  TenantApiService tenantApiService = TenantApiService();
  List<FloorModel> floorList = [];
  List<TenantModel> tenantList = [];
  String? floorName;
  String? tenantName;
  late Stream<List<FlatModel>> flatStream = const Stream.empty();

  final _newFlatNameController = TextEditingController();
  final _newNoOfMasterbedRoomController = TextEditingController();
  final _newNoOfBedroomController = TextEditingController();
  final _newFlatSideController = TextEditingController();

  final _newNoOfWashroomController = TextEditingController();
  final _newFlatSizeController = TextEditingController();
  final _rentAmountController = TextEditingController();
  final _gasBillController = TextEditingController();
  final _waterBillController = TextEditingController();
  final _serviceChargeController = TextEditingController();
  int? selectedTenantId;
  int? selectedFloorId;

  int? buildingId;

  bool isLoading = false;
  UserModel user = UserModel();
  AuthStateManager authStateManager = AuthStateManager();
  bool isActive = true;

  @override
  void initState() {
    getLocalInfo();
    _fetchData();
    super.initState();
  }

  void refresh() {
    setState(() {
      flatStream = flatApiService.getAllFlats().asStream();
    });
  }

  Future<void> getLocalInfo() async {
    buildingId = await authStateManager.getBuildingId();
    user = (await authStateManager.getLoggedInUser())!;
  }

  Future<void> _fetchData() async {
    flatStream = flatApiService.getAllFlats().asStream();
    floorList = await floorApiService.getAllFloors();
    tenantList = await tenantApiService.getAllTenants();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 49, 49, 49)),
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Center(
            child: Text(
          "Flats",
          style: TextStyle(color: Colors.black),
        )),
      ),
      floatingActionButton: CircleAvatar(
        backgroundColor: const Color.fromARGB(255, 66, 129, 247),
        child: IconButton(
          onPressed: () {
            Get.to(FlatDataPage(
              refresh: refresh,
            ));
          },
          icon: const Icon(Icons.add),
          color: const Color.fromARGB(255, 255, 255, 255),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Container(
                    width: 400,
                    height: 580,
                    child: StreamBuilder<List<FlatModel>>(
                      stream: flatStream,
                      builder: (BuildContext context,
                          AsyncSnapshot<List<FlatModel>> snapshot) {
                        getLocalInfo();
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasData &&
                            snapshot.data != null &&
                            snapshot.data!.isNotEmpty) {
                          List<FlatModel> flatList = snapshot.data!
                              .where(
                                  (element) => element.buildingId == buildingId)
                              .toList();

                          return ListView.builder(
                            itemCount: flatList.length,
                            itemBuilder: (BuildContext context, int index) {
                              FlatModel flat = flatList[index];
                              List<TenantModel> tenants =
                                  context.watch<TenantData>().tenantList;
                              if (floorList.isNotEmpty) {
                                floorName = floorList
                                    .firstWhere((e) => e.id == flat.floorId)
                                    .name;
                              } else {
                                floorName = "floor not found";
                              }
                              if (tenants.isNotEmpty) {
                                try {
                                  tenantName = tenants
                                      .firstWhere((e) => e.id == flat.tenantId)
                                      .name;
                                } catch (_) {}
                              } else {
                                tenantName = "tenant not found";
                              }
                              return ListTile(
                                title: Card(
                                  elevation: 10,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Container(
                                          width: 240,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Text(
                                                  'Flat Name: ${flat.name.toString()}',
                                                  style: const TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 0, 0, 0),
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Text(
                                                  'Floor Name: $floorName',
                                                  style: const TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 0, 0, 0),
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Text(
                                                  'Tenant Name: $tenantName',
                                                  style: const TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 0, 0, 0),
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Text(
                                                  'No. Of Master Bedroom: ${flat.masterbedRoom.toString()}',
                                                  style: const TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 0, 0, 0),
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Text(
                                                  'No. Of Bedroom: ${flat.bedroom.toString()}',
                                                  style: const TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 0, 0, 0),
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Text(
                                                  'No. Of Washroom: ${flat.washroom.toString()}',
                                                  style: const TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 0, 0, 0),
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Text(
                                                  'Flat Side: ${flat.flatSide!.isEmpty ? "" : flat.flatSide.toString()}',
                                                  style: const TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 0, 0, 0),
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Text(
                                                  'Flat Size(Sqf): ${flat.flatSize == null ? 0.0 : flat.flatSize.toString()}',
                                                  style: const TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 0, 0, 0),
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Text(
                                                  'Rent Amount: ${flat.rentAmount.toString()}',
                                                  style: const TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 0, 0, 0),
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Text(
                                                  'Water Bill: ${flat.waterBill.toString()}',
                                                  style: const TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 0, 0, 0),
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Text(
                                                  'Gas Bill: ${flat.gasBill.toString()}',
                                                  style: const TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 0, 0, 0),
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Text(
                                                  'Service Charge: ${flat.serviceCharge.toString()}',
                                                  style: const TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 0, 0, 0),
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: CircleAvatar(
                                          radius: 15,
                                          backgroundColor: const Color.fromARGB(
                                              255, 255, 221, 0),
                                          child: IconButton(
                                              iconSize: 15,
                                              color: Colors.white,
                                              onPressed: () {
                                                _newFlatNameController.text =
                                                    flat.name.toString();
                                                _newNoOfMasterbedRoomController
                                                        .text =
                                                    flat.masterbedRoom
                                                        .toString();
                                                _newNoOfBedroomController.text =
                                                    flat.bedroom.toString();
                                                _newNoOfWashroomController
                                                        .text =
                                                    flat.washroom.toString();

                                                _newFlatSideController.text =
                                                    flat.flatSide.toString();

                                                _newFlatSizeController.text =
                                                    flat.flatSize.toString();
                                                _rentAmountController.text =
                                                    flat.rentAmount.toString();
                                                _waterBillController.text =
                                                    flat.waterBill.toString();
                                                _gasBillController.text =
                                                    flat.gasBill.toString();
                                                _serviceChargeController.text =
                                                    flat.serviceCharge
                                                        .toString();
                                                selectedFloorId = flat.floorId;
                                                selectedTenantId =
                                                    flat.tenantId;
                                                showModalBottomSheet<void>(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return SingleChildScrollView(
                                                      child: StatefulBuilder(
                                                        builder: (context,
                                                                setState) =>
                                                            Container(
                                                          height: 900,
                                                          color: const Color
                                                              .fromARGB(255,
                                                              255, 255, 255),
                                                          child: Center(
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: <Widget>[
                                                                const Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              20.0),
                                                                  child: Text(
                                                                      'Update Your Information'),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          14.0),
                                                                  child: Column(
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          const SizedBox(
                                                                            child:
                                                                                Text(
                                                                              'Flat Name',
                                                                              style: TextStyle(
                                                                                fontSize: 16,
                                                                                color: Color.fromARGB(255, 78, 78, 78),
                                                                                fontStyle: FontStyle.normal,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          const SizedBox(
                                                                              height: 8),
                                                                          SizedBox(
                                                                            width:
                                                                                250,
                                                                            height:
                                                                                50,
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: TextFormField(
                                                                                keyboardType: TextInputType.name,
                                                                                controller: _newFlatNameController,
                                                                                decoration: InputDecoration(
                                                                                  border: OutlineInputBorder(
                                                                                    borderRadius: BorderRadius.circular(10),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                          height:
                                                                              10),
                                                                      SizedBox(
                                                                        height:
                                                                            60,
                                                                        child: Consumer<
                                                                            FloorData>(
                                                                          builder: (context,
                                                                              floorData,
                                                                              child) {
                                                                            getLocalInfo();
                                                                            floorData.getFloorList();

                                                                            List<FloorModel>
                                                                                floorList =
                                                                                floorData.floorList.where((e) => e.buildingId == buildingId).toList();

                                                                            return DropdownButtonFormField<int>(
                                                                              isExpanded: true,
                                                                              decoration: InputDecoration(
                                                                                labelText: 'Floor',
                                                                                border: OutlineInputBorder(
                                                                                  borderRadius: BorderRadius.circular(10),
                                                                                ),
                                                                              ),
                                                                              disabledHint: const Text('Add Floor First'),
                                                                              value: selectedFloorId,
                                                                              onChanged: (int? value) {
                                                                                setState(() {
                                                                                  selectedFloorId = value!;
                                                                                  // selectedFloorName = floorList
                                                                                  //     .firstWhere((floor) => floor.id == selectedFloorId)
                                                                                  //     .name;
                                                                                });
                                                                              },
                                                                              items: floorList.map<DropdownMenuItem<int>>((FloorModel floor) {
                                                                                return DropdownMenuItem<int>(
                                                                                  value: floor.id,
                                                                                  child: Text(floor.name!),
                                                                                );
                                                                              }).toList(),
                                                                            );
                                                                          },
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                          height:
                                                                              10),
                                                                      SizedBox(
                                                                        height:
                                                                            60,
                                                                        child: Consumer<
                                                                            TenantData>(
                                                                          builder: (context,
                                                                              tenant,
                                                                              child) {
                                                                            getLocalInfo();

                                                                            tenant.returnTenantList();
                                                                            List<TenantModel>
                                                                                tenantList =
                                                                                tenant.tenantList.where((element) => element.buildingId == buildingId).toList();
                                                                            return DropdownButtonFormField<int>(
                                                                              isExpanded: true,
                                                                              decoration: InputDecoration(
                                                                                labelText: 'Tenant',
                                                                                border: OutlineInputBorder(
                                                                                  borderRadius: BorderRadius.circular(10),
                                                                                ),
                                                                              ),
                                                                              disabledHint: const Text('Add Tenant First'),
                                                                              value: selectedTenantId,
                                                                              onChanged: (int? value) {
                                                                                setState(() {
                                                                                  selectedTenantId = value!;
                                                                                  // selectedFloorName = floorList
                                                                                  //     .firstWhere((floor) => floor.id == selectedFloorId)
                                                                                  //     .name;
                                                                                });
                                                                              },
                                                                              items: tenantList.map<DropdownMenuItem<int>>((TenantModel tenant) {
                                                                                return DropdownMenuItem<int>(
                                                                                  value: tenant.id,
                                                                                  child: Text(tenant.name!),
                                                                                );
                                                                              }).toList(),
                                                                            );
                                                                          },
                                                                        ),
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          const SizedBox(
                                                                            child:
                                                                                Text(
                                                                              'No. Of Master \nBedroom',
                                                                              style: TextStyle(
                                                                                fontSize: 16,
                                                                                color: Color.fromARGB(255, 78, 78, 78),
                                                                                fontStyle: FontStyle.normal,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                250,
                                                                            height:
                                                                                50,
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: TextFormField(
                                                                                keyboardType: TextInputType.number,
                                                                                controller: _newNoOfMasterbedRoomController,
                                                                                decoration: InputDecoration(
                                                                                  border: OutlineInputBorder(
                                                                                    borderRadius: BorderRadius.circular(10),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          const SizedBox(
                                                                            child:
                                                                                Text(
                                                                              'No. Of \nBedroom',
                                                                              style: TextStyle(
                                                                                fontSize: 16,
                                                                                color: Color.fromARGB(255, 78, 78, 78),
                                                                                fontStyle: FontStyle.normal,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                250,
                                                                            height:
                                                                                50,
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: TextFormField(
                                                                                keyboardType: TextInputType.number,
                                                                                controller: _newNoOfBedroomController,
                                                                                decoration: InputDecoration(
                                                                                  border: OutlineInputBorder(
                                                                                    borderRadius: BorderRadius.circular(10),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          const SizedBox(
                                                                            child:
                                                                                Text(
                                                                              'No. Of \nWashroom',
                                                                              style: TextStyle(
                                                                                fontSize: 16,
                                                                                color: Color.fromARGB(255, 78, 78, 78),
                                                                                fontStyle: FontStyle.normal,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                250,
                                                                            height:
                                                                                50,
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: TextFormField(
                                                                                keyboardType: TextInputType.number,
                                                                                controller: _newNoOfWashroomController,
                                                                                decoration: InputDecoration(
                                                                                  border: OutlineInputBorder(
                                                                                    borderRadius: BorderRadius.circular(10),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          const SizedBox(
                                                                            child:
                                                                                Text(
                                                                              'Flat Side',
                                                                              style: TextStyle(
                                                                                fontSize: 16,
                                                                                color: Color.fromARGB(255, 78, 78, 78),
                                                                                fontStyle: FontStyle.normal,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                250,
                                                                            height:
                                                                                50,
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: TextFormField(
                                                                                keyboardType: TextInputType.name,
                                                                                controller: _newFlatSideController,
                                                                                decoration: InputDecoration(
                                                                                  border: OutlineInputBorder(
                                                                                    borderRadius: BorderRadius.circular(10),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          const SizedBox(
                                                                            child:
                                                                                Text(
                                                                              'Flat Size',
                                                                              style: TextStyle(
                                                                                fontSize: 16,
                                                                                color: Color.fromARGB(255, 78, 78, 78),
                                                                                fontStyle: FontStyle.normal,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                250,
                                                                            height:
                                                                                50,
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: TextFormField(
                                                                                keyboardType: TextInputType.number,
                                                                                controller: _newFlatSizeController,
                                                                                decoration: InputDecoration(
                                                                                  border: OutlineInputBorder(
                                                                                    borderRadius: BorderRadius.circular(10),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          const SizedBox(
                                                                            child:
                                                                                Text(
                                                                              'Rent Amount',
                                                                              style: TextStyle(
                                                                                fontSize: 16,
                                                                                color: Color.fromARGB(255, 78, 78, 78),
                                                                                fontStyle: FontStyle.normal,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                250,
                                                                            height:
                                                                                50,
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: TextFormField(
                                                                                keyboardType: TextInputType.number,
                                                                                controller: _rentAmountController,
                                                                                decoration: InputDecoration(
                                                                                  border: OutlineInputBorder(
                                                                                    borderRadius: BorderRadius.circular(10),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          const SizedBox(
                                                                            child:
                                                                                Text(
                                                                              'Water Bill',
                                                                              style: TextStyle(
                                                                                fontSize: 16,
                                                                                color: Color.fromARGB(255, 78, 78, 78),
                                                                                fontStyle: FontStyle.normal,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                250,
                                                                            height:
                                                                                50,
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: TextFormField(
                                                                                keyboardType: TextInputType.number,
                                                                                controller: _waterBillController,
                                                                                decoration: InputDecoration(
                                                                                  border: OutlineInputBorder(
                                                                                    borderRadius: BorderRadius.circular(10),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          const SizedBox(
                                                                            child:
                                                                                Text(
                                                                              'Gas Bill',
                                                                              style: TextStyle(
                                                                                fontSize: 16,
                                                                                color: Color.fromARGB(255, 78, 78, 78),
                                                                                fontStyle: FontStyle.normal,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                250,
                                                                            height:
                                                                                50,
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: TextFormField(
                                                                                keyboardType: TextInputType.number,
                                                                                controller: _gasBillController,
                                                                                decoration: InputDecoration(
                                                                                  border: OutlineInputBorder(
                                                                                    borderRadius: BorderRadius.circular(10),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          const SizedBox(
                                                                            child:
                                                                                Text(
                                                                              'Service Charge',
                                                                              style: TextStyle(
                                                                                fontSize: 16,
                                                                                color: Color.fromARGB(255, 78, 78, 78),
                                                                                fontStyle: FontStyle.normal,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                250,
                                                                            height:
                                                                                50,
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: TextFormField(
                                                                                keyboardType: TextInputType.number,
                                                                                controller: _serviceChargeController,
                                                                                decoration: InputDecoration(
                                                                                  border: OutlineInputBorder(
                                                                                    borderRadius: BorderRadius.circular(10),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          8.0),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      isLoading ==
                                                                              false
                                                                          ? ElevatedButton(
                                                                              child: const Text('update'),
                                                                              onPressed: () async {
                                                                                setState(() {
                                                                                  isLoading = true;
                                                                                });
                                                                                getLocalInfo();

                                                                                int? flatId = flat.id;

                                                                                String updatedflatName = _newFlatNameController.text;
                                                                                int updatedNoOfMasterBedroom = int.parse(_newNoOfMasterbedRoomController.text);

                                                                                int updatedNoOfBedroom = int.parse(_newNoOfBedroomController.text);

                                                                                int updatedNoOfWashroom = int.parse(_newNoOfWashroomController.text);

                                                                                String updatedFlatSide = _newFlatSideController.text;

                                                                                int updatedFlatSize = int.parse(_newFlatSizeController.text);

                                                                                FlatModel updatedFlat = FlatModel(id: flat.id, name: updatedflatName, masterbedRoom: updatedNoOfMasterBedroom, bedroom: updatedNoOfBedroom, washroom: updatedNoOfWashroom, flatSide: updatedFlatSide, flatSize: updatedFlatSize, floorId: selectedFloorId ?? flat.floorId, buildingId: flat.buildingId, isActive: isActive, tenantId: selectedTenantId ?? flat.tenantId, userId: flat.userId, gasBill: int.parse(_gasBillController.text), rentAmount: int.parse(_rentAmountController.text), serviceCharge: int.parse(_serviceChargeController.text), waterBill: int.parse(_waterBillController.text));
                                                                                await flatApiService.updateFlat(flat: updatedFlat, id: flatId!);
                                                                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("updated successfully")));
                                                                                refresh();
                                                                                setState(() {
                                                                                  isLoading = false;

                                                                                  Navigator.pop(context);
                                                                                });
                                                                              },
                                                                            )
                                                                          : const CircularProgressIndicator(),
                                                                      const SizedBox(
                                                                        width:
                                                                            20,
                                                                      ),
                                                                      ElevatedButton(
                                                                        child: const Text(
                                                                            'Cancel'),
                                                                        onPressed:
                                                                            () =>
                                                                                Navigator.pop(context),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                              icon: const Icon(Icons.edit)),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 1,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: CircleAvatar(
                                          radius: 15,
                                          backgroundColor: const Color.fromARGB(
                                              222, 255, 0, 0),
                                          child: IconButton(
                                              iconSize: 15,
                                              color: Colors.white,
                                              onPressed: () async {
                                                int? id = flat.id;
                                                await flatApiService
                                                    .deleteFlat(id!);
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(const SnackBar(
                                                        content: Text(
                                                            "deleted successfully")));
                                                setState(() {
                                                  _fetchData();
                                                });
                                              },
                                              icon: const Icon(Icons.delete)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          return const Center(
                              child: Text('No flats available.'));
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
