import 'dart:async';
import 'package:flutter/material.dart';
import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rent_management/models/rent_model.dart';
import 'package:rent_management/screens/current_date_rent.dart';
import 'package:rent_management/services/rent_service.dart';

// ignore: must_be_immutable
class PrintingPage extends StatefulWidget {
  RentModel rent;
  String? tenantName;
  String? flatName;
  String? floorName;
  String? buildingAddress;
  void Function() refresh;
  PrintingPage({required this.rent, required this.refresh, required this.tenantName, required this.flatName, required this.floorName, required this.buildingAddress, super.key});
  @override
  State<PrintingPage> createState() => _PrintingPageState();
}

class _PrintingPageState extends State<PrintingPage> {
  DateTime printingDate = DateTime.now();
  BluetoothPrint bluetoothPrint = BluetoothPrint.instance;
  NumberFormat formatter = NumberFormat("###,###");
  bool _connected = false;
  BluetoothDevice? _device;
  String tips = 'no device connected';

  DateTime date = DateTime.now();

  RentApiService rentApiService = RentApiService();

  CurrentMonthRentState currentMonthRentState = CurrentMonthRentState();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => initBluetooth());
  }

  Future<void> initBluetooth() async {
    bluetoothPrint.startScan(timeout: const Duration(seconds: 5));

    bool isConnected = await bluetoothPrint.isConnected ?? false;

    bluetoothPrint.state.listen((state) {
      print('******************* cur device status: $state');

      switch (state) {
        case BluetoothPrint.CONNECTED:
          setState(() {
            _connected = true;
            tips = 'connect success';
          });
          break;
        case BluetoothPrint.DISCONNECTED:
          setState(() {
            _connected = false;
            tips = 'disconnect success';
          });
          break;
        default:
          break;
      }
    });

    if (!mounted) return;

    if (isConnected) {
      setState(() {
        _connected = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            widget.refresh;
            Get.back();
          },
        ),
        title: const Text('Print Receipt'),
      ),
      body: RefreshIndicator(
        onRefresh: () => bluetoothPrint.startScan(timeout: const Duration(seconds: 4)),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: _connected == true ? const Text("Device Connected") : Text(tips),
                  ),
                ],
              ),
              const Divider(),
              StreamBuilder<List<BluetoothDevice>>(
                stream: bluetoothPrint.scanResults,
                initialData: [],
                builder: (c, snapshot) => Column(
                  children: snapshot.data!
                      .map((d) => ListTile(
                            title: _connected == true ? Text(d.name!) : Text(d.name ?? ''),
                            subtitle: _connected == true ? Text(d.address!) : Text(d.address ?? ''),
                            onTap: () async {
                              setState(() {
                                _device = d;
                              });
                            },
                            trailing: _device != null && _device!.address == d.address
                                ? const Icon(
                                    Icons.check,
                                    color: Colors.green,
                                  )
                                : null,
                          ))
                      .toList(),
                ),
              ),
              const Divider(),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 5, 20, 10),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        OutlinedButton(
                          child: const Text('connect'),
                          onPressed: _connected
                              ? null
                              : () async {
                                  if (_device != null && _device!.address != null) {
                                    setState(() {
                                      tips = 'connecting...';
                                    });
                                    await bluetoothPrint.connect(_device!);
                                  } else {
                                    setState(() {
                                      tips = 'please select device';
                                    });
                                    print('please select device');
                                  }
                                },
                        ),
                        const SizedBox(width: 10.0),
                        OutlinedButton(
                          child: const Text('disconnect'),
                          onPressed: _connected
                              ? () async {
                                  setState(() {
                                    tips = 'disconnecting...';
                                  });
                                  await bluetoothPrint.disconnect();
                                }
                              : null,
                        ),
                      ],
                    ),
                    const Divider(),
                    OutlinedButton(
                      child: const Text('print receipt'),
                      onPressed: _connected
                          ? () async {
                              Map<String, dynamic> config = Map();
                              // config['width'] = 80;
                              config['height'] = 130;
                              config['gap'] = 2;
                              List<LineText> list = [];

                              // ByteData data =
                              //     await rootBundle.load("assets/hold.png");
                              // List<int> imageBytes = data.buffer.asUint8List(
                              //     data.offsetInBytes, data.lengthInBytes);
                              // String base64Image = base64Encode(imageBytes);
                              // list.add(LineText(
                              //     type: LineText.TYPE_IMAGE,
                              //     content: base64Image,
                              //     size: 2,
                              //     align: LineText.ALIGN_CENTER,
                              //     linefeed: 1));
                              list.add(LineText(type: LineText.TYPE_TEXT, content: "Bill Receipt", align: LineText.ALIGN_CENTER, height: 1, width: 1, linefeed: 1, underline: 1));
                              list.add(LineText(linefeed: 1));
                              list.add(LineText(type: LineText.TYPE_TEXT, content: "Holding No: ${widget.buildingAddress}", align: LineText.ALIGN_CENTER, linefeed: 1, underline: 1));
                              list.add(LineText(linefeed: 1));

                              list.add(LineText(type: LineText.TYPE_TEXT, content: "Receipt No", size: 5, weight: 30, align: LineText.ALIGN_CENTER, linefeed: 1, underline: 1));
                              list.add(LineText(type: LineText.TYPE_TEXT, content: "${widget.rent.reciptNo}", weight: 30, align: LineText.ALIGN_CENTER, linefeed: 1, underline: 1));
                              list.add(LineText(linefeed: 1));
                              list.add(LineText(type: LineText.TYPE_TEXT, content: " Tenant Name   :  ${widget.tenantName}", relativeX: 2, weight: 30, align: LineText.ALIGN_LEFT, linefeed: 1, underline: 1));
                              list.add(LineText(type: LineText.TYPE_TEXT, content: " Floor Name    :  ${widget.floorName}", weight: 30, align: LineText.ALIGN_LEFT, linefeed: 1, underline: 1));
                              list.add(LineText(type: LineText.TYPE_TEXT, content: " Flat Name     :  ${widget.flatName}", weight: 30, align: LineText.ALIGN_LEFT, linefeed: 1, underline: 1));
                              list.add(LineText(type: LineText.TYPE_TEXT, content: " Rent Amount   :  ${formatter.format(widget.rent.rentAmount)} BDT", weight: 30, align: LineText.ALIGN_LEFT, linefeed: 1, underline: 1));
                              list.add(LineText(type: LineText.TYPE_TEXT, content: " Water Bill    :  ${formatter.format(widget.rent.waterBill)} BDT", weight: 30, align: LineText.ALIGN_LEFT, linefeed: 1, underline: 1));
                              list.add(LineText(type: LineText.TYPE_TEXT, content: " Gas Bill      :  ${formatter.format(widget.rent.gasBill)} BDT", weight: 30, align: LineText.ALIGN_LEFT, linefeed: 1, underline: 1));
                              list.add(LineText(type: LineText.TYPE_TEXT, content: " Service Charge:  ${formatter.format(widget.rent.serviceCharge)} BDT", weight: 30, align: LineText.ALIGN_LEFT, linefeed: 1, underline: 1));
                              list.add(LineText(type: LineText.TYPE_TEXT, content: " Total Amount  :  ${formatter.format(widget.rent.totalAmount)} BDT", weight: 30, align: LineText.ALIGN_LEFT, linefeed: 1, underline: 1));
                              list.add(LineText(linefeed: 1));
                              list.add(LineText(type: LineText.TYPE_TEXT, content: "Rent Month : ${DateFormat(' MMM yyy').format(widget.rent.rentMonth!)}", weight: 30, align: LineText.ALIGN_CENTER, linefeed: 1, underline: 1));

                              list.add(LineText(linefeed: 1));
                              list.add(LineText(type: LineText.TYPE_TEXT, content: "Printing Date", weight: 30, align: LineText.ALIGN_CENTER, linefeed: 1, underline: 2));
                              list.add(LineText(type: LineText.TYPE_TEXT, content: "${DateFormat('E d MMM y hh:mm a').format(date)}", weight: 30, align: LineText.ALIGN_CENTER, linefeed: 1, underline: 2));
                              list.add(LineText(linefeed: 1));
                              list.add(LineText(
                                type: LineText.TYPE_TEXT,
                                content: "This is a computer-generated document",
                                weight: 30,
                                align: LineText.ALIGN_CENTER,
                                linefeed: 1,
                              ));
                              list.add(LineText(type: LineText.TYPE_TEXT, content: "No signature is required", weight: 30, align: LineText.ALIGN_CENTER, linefeed: 1, underline: 1));
                              list.add(LineText(linefeed: 1));
                              list.add(LineText(
                                type: LineText.TYPE_TEXT,
                                content: "App Developed By Bikash Paul",
                                weight: 30,
                                align: LineText.ALIGN_RIGHT,
                                linefeed: 2,
                              ));
                              list.add(LineText(linefeed: 1));
                              list.add(LineText(linefeed: 1));
                              await bluetoothPrint.printReceipt(config, list);
                              RentModel updatedRent =
                                  RentModel(buildingId: widget.rent.buildingId, flatId: widget.rent.flatId, tenantId: widget.rent.tenantId, userId: widget.rent.userId, id: widget.rent.id, isPrinted: true, dueAmount: widget.rent.dueAmount, gasBill: widget.rent.gasBill, isPaid: widget.rent.isPaid, rentAmount: widget.rent.rentAmount, rentMonth: widget.rent.rentMonth, serviceCharge: widget.rent.serviceCharge, waterBill: widget.rent.waterBill, totalAmount: widget.rent.totalAmount);

                              await rentApiService.updateRent(id: widget.rent.id!, rent: updatedRent);

                              currentMonthRentState.initState();
                            }
                          : null,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: StreamBuilder<bool>(
        stream: bluetoothPrint.isScanning,
        initialData: false,
        builder: (c, snapshot) {
          if (snapshot.data == true) {
            return FloatingActionButton(
              child: const Icon(Icons.stop),
              onPressed: () => bluetoothPrint.stopScan(),
              backgroundColor: Colors.red,
            );
          } else {
            return FloatingActionButton(child: const Icon(Icons.search), onPressed: () => bluetoothPrint.startScan(timeout: const Duration(seconds: 4)));
          }
        },
      ),
    );
  }
}
