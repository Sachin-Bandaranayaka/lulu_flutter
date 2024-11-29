import 'package:flutter/foundation.dart';
import 'package:flutter_bluetooth_basic/flutter_bluetooth_basic.dart';
import 'package:lulu/services/printer_service.dart';
import 'package:lulu/models/invoice.dart';

class PrinterProvider extends ChangeNotifier {
  final PrinterService _printerService = PrinterService();
  bool _isScanning = false;
  String? _error;

  bool get isScanning => _isScanning;
  String? get error => _error;
  BluetoothDevice? get selectedPrinter => _printerService.selectedPrinter;

  Stream<List<PrinterBluetooth>> get discoveredDevices =>
      _printerService.discoveredDevices;

  Future<void> startScan() async {
    _error = null;
    _isScanning = true;
    notifyListeners();

    try {
      await _printerService.startScan();
    } catch (e) {
      _error = e.toString();
    }

    _isScanning = false;
    notifyListeners();
  }

  Future<void> stopScan() async {
    await _printerService.stopScan();
    _isScanning = false;
    notifyListeners();
  }

  Future<void> selectPrinter(BluetoothDevice printer) async {
    _error = null;
    try {
      await _printerService.selectPrinter(printer);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> printInvoice(Invoice invoice) async {
    _error = null;
    try {
      await _printerService.printInvoice(invoice);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  void dispose() {
    _printerService.dispose();
    super.dispose();
  }
} 