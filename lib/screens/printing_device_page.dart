import 'dart:async';
import 'package:flutter/material.dart';
import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:intl/intl.dart';
import 'package:rent_management/models/rent_model.dart';

// ignore: must_be_immutable
class PrintingPage extends StatefulWidget {
  RentModel rent;
  String? tenantName;
  String? flatName;
  String? floorName;
  void Function() refresh;
  PrintingPage(
      {required this.rent,
      required this.refresh,
      required this.tenantName,
      required this.flatName,
      required this.floorName,
      super.key});
  @override
  State<PrintingPage> createState() => _PrintingPageState();
}

class _PrintingPageState extends State<PrintingPage> {
  DateTime printingDate = DateTime.now();
  bool isLoading = false;
  BluetoothPrint bluetoothPrint = BluetoothPrint.instance;
  List<BluetoothDevice> _devices = [];
  String _deviceMsg = "";
  StreamSubscription<List<BluetoothDevice>>? scanSubscription;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => initPrinter());
  }

  Future<void> initPrinter() async {
    setState(() {
      isLoading = true;
    });
    try {
      await BluetoothPrint.instance.startScan(timeout: Duration(seconds: 5));
      scanSubscription = BluetoothPrint.instance.scanResults.listen((event) {
        if (!mounted) return;
        setState(() {
          _devices = event;
          isLoading = false;
        });
        if (_devices.isEmpty) {
          setState(() {
            _deviceMsg = "No Devices";
            isLoading = false;
          });
        }
      }, onDone: () async {
        await BluetoothPrint.instance.stopScan();
        await scanSubscription?.cancel();
      });
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Select Printer"),
        ),
        body: _devices.isEmpty
            ? Center(
                child: isLoading == false
                    ? Text(_deviceMsg ?? "")
                    : CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: _devices.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(Icons.print),
                    title: Text(_devices[index].name!),
                    subtitle: Text(_devices[index].address!),
                    onTap: () {
                      _startPrint(_devices[index], widget.rent, printingDate);
                    },
                  );
                },
              ));
  }

  // Future<List<int>> _startPrint(
  //     BluetoothDevice device, RentModel rent, DateTime date) async {
  //   List<int> bytes = [];
  //   if (device != null && device.address != null) {
  //     await bluetoothPrint.connect(device);
  //     final profile = await CapabilityProfile.load();
  //     final generator = Generator(PaperSize.mm80, profile);

  //     bytes += generator.text("Rent Management",
  //         linesAfter: 1,
  //         styles: PosStyles(
  //           align: PosAlign.center,
  //           underline: true,
  //           width: PosTextSize.size3,
  //           height: PosTextSize.size3,
  //         ));
  //     bytes += generator.text("Receipt No. ${rent.reciptNo}",
  //         linesAfter: 1,
  //         styles: PosStyles(
  //           align: PosAlign.center,
  //           underline: false,
  //           width: PosTextSize.size1,
  //           height: PosTextSize.size1,
  //         ));
  //     bytes += generator.text("${rent.reciptNo}",
  //         linesAfter: 1,
  //         styles: PosStyles(
  //           align: PosAlign.center,
  //           underline: true,
  //           width: PosTextSize.size1,
  //           height: PosTextSize.size1,
  //         ));
  //     bytes += generator.text("Tenant Name:      ${widget.tenantName}",
  //         linesAfter: 1,
  //         styles: PosStyles(
  //           align: PosAlign.left,
  //           underline: true,
  //         ));

  //     bytes += generator.text("Floor Name:      ${widget.floorName}",
  //         linesAfter: 1,
  //         styles: PosStyles(
  //           align: PosAlign.left,
  //           underline: true,
  //         ));
  //     bytes += generator.text("Flat Name:      ${widget.flatName}",
  //         linesAfter: 1,
  //         styles: PosStyles(
  //           align: PosAlign.left,
  //           underline: true,
  //         ));
  //     bytes += generator.text("Rent Amount:     BDT- ${rent.rentAmount}",
  //         linesAfter: 1,
  //         styles: PosStyles(
  //           align: PosAlign.left,
  //           underline: true,
  //         ));
  //     bytes += generator.text("Water Bill:      BDT- ${rent.waterBill}",
  //         linesAfter: 1,
  //         styles: PosStyles(
  //           align: PosAlign.left,
  //           underline: true,
  //         ));
  //     bytes += generator.text("Gas Bill:     BDT- ${rent.gasBill}",
  //         linesAfter: 1,
  //         styles: PosStyles(
  //           align: PosAlign.left,
  //           underline: true,
  //         ));
  //     bytes += generator.text("Service Charge:     BDT- ${rent.serviceCharge}",
  //         linesAfter: 1,
  //         styles: PosStyles(
  //           align: PosAlign.left,
  //           underline: true,
  //         ));
  //     bytes += generator.text("Total Amount:      BDT- ${rent.totalAmount}",
  //         linesAfter: 1,
  //         styles: PosStyles(
  //           align: PosAlign.left,
  //           underline: true,
  //         ));
  //     bytes += generator.text(
  //         "Rent Month:     ${DateFormat(' MMM yyy').format(rent.rentMonth!)}",
  //         linesAfter: 1,
  //         styles: PosStyles(
  //           align: PosAlign.left,
  //           underline: true,
  //         ));
  //     bytes += generator.text(
  //         "Printing Date:      ${DateFormat('E d MMM y hh:mm a').format(date)}",
  //         linesAfter: 1,
  //         styles: PosStyles(
  //           align: PosAlign.left,
  //           underline: true,
  //         ));
  //     bytes += generator.text("This is a computer-generated document.",
  //         linesAfter: 1,
  //         styles: PosStyles(
  //           align: PosAlign.center,
  //           underline: false,
  //         ));
  //     bytes += generator.text("No signature is required.",
  //         linesAfter: 1,
  //         styles: PosStyles(
  //           align: PosAlign.center,
  //           underline: true,
  //         ));
  //     bytes += generator.text("App Developed By Bikash Paul",
  //         linesAfter: 1,
  //         styles: PosStyles(
  //           align: PosAlign.right,
  //           underline: false,
  //         ));

  //     bytes += generator.feed(2);
  //     bytes += generator.cut();

  //   }

  //   return bytes;
  // }

  Future<void> _startPrint(
      BluetoothDevice device, RentModel rent, DateTime date) async {
    if (device != null && device.address != null) {
      await bluetoothPrint.connect(device);
      Map<String, dynamic> config = Map();
      config['paperWidth'] = 800;
      List<LineText> list = [];
      list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: "Rent Management",
          weight: 2,
          width: 2,
          height: 2,
          align: LineText.ALIGN_CENTER,
          linefeed: 2,
          underline: 2));
      list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: "Receipt No. ${rent.reciptNo}",
          weight: 2,
          width: 2,
          height: 2,
          align: LineText.ALIGN_CENTER,
          linefeed: 1,
          underline: 1));
      list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: "Tenant Name:      ${widget.tenantName}",
          weight: 2,
          width: 2,
          height: 2,
          align: LineText.ALIGN_LEFT,
          linefeed: 1,
          underline: 1));
      list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: "Floor Name:     ${widget.floorName}",
          weight: 2,
          width: 2,
          height: 2,
          align: LineText.ALIGN_LEFT,
          linefeed: 1,
          underline: 1));
      list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: "Flat Name:      ${widget.flatName}",
          weight: 2,
          width: 2,
          height: 2,
          align: LineText.ALIGN_LEFT,
          linefeed: 1,
          underline: 1));
      list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: "Rent Amount:     BDT- ${rent.rentAmount}",
          weight: 2,
          width: 2,
          height: 2,
          align: LineText.ALIGN_LEFT,
          linefeed: 1,
          underline: 1));
      list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: "Water Bill:      BDT- ${rent.waterBill}",
          weight: 2,
          width: 2,
          height: 2,
          align: LineText.ALIGN_LEFT,
          linefeed: 1,
          underline: 1));
      list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: "Gas Bill:     BDT- ${rent.gasBill}",
          weight: 2,
          width: 2,
          height: 2,
          align: LineText.ALIGN_LEFT,
          linefeed: 1,
          underline: 1));
      list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: "Service Charge:     BDT- ${rent.serviceCharge}",
          weight: 2,
          width: 2,
          height: 2,
          align: LineText.ALIGN_LEFT,
          linefeed: 1,
          underline: 1));
      list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: "Total Amount:      BDT- ${rent.totalAmount}",
          weight: 2,
          width: 2,
          height: 2,
          align: LineText.ALIGN_LEFT,
          linefeed: 1,
          underline: 1));
      list.add(LineText(
          type: LineText.TYPE_TEXT,
          content:
              "Rent Month:     ${DateFormat(' MMM yyy').format(rent.rentMonth!)}",
          weight: 2,
          width: 2,
          height: 2,
          align: LineText.ALIGN_LEFT,
          linefeed: 1,
          underline: 1));
      list.add(LineText(
          type: LineText.TYPE_TEXT,
          content:
              "Printing Date:      ${DateFormat('E d MMM y hh:mm a').format(date)}",
          weight: 2,
          width: 2,
          height: 2,
          align: LineText.ALIGN_RIGHT,
          linefeed: 3,
          underline: 2));
      list.add(LineText(
          type: LineText.TYPE_TEXT,
          content:
              "This is a computer-generated document.\nNo signature is required. ",
          weight: 2,
          width: 2,
          height: 2,
          align: LineText.ALIGN_CENTER,
          linefeed: 2,
          underline: 1));
      list.add(LineText(
        type: LineText.TYPE_TEXT,
        content: "App Developed By Bikash Paul",
        weight: 2,
        width: 2,
        height: 2,
        align: LineText.ALIGN_RIGHT,
        linefeed: 2,
      ));

      await bluetoothPrint.printLabel(config, list);
      
      await bluetoothPrint.disconnect();
    }
  }
}
