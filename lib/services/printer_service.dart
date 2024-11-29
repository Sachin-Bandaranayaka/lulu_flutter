import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter_bluetooth_basic/flutter_bluetooth_basic.dart';
import 'package:lulu/models/invoice.dart';

class PrinterService {
  final PrinterBluetoothManager _printerManager = PrinterBluetoothManager();
  BluetoothDevice? _selectedPrinter;

  Stream<List<PrinterBluetooth>> get discoveredDevices => 
      _printerManager.scanResults;

  Future<void> startScan() async {
    await _printerManager.startScan(Duration(seconds: 4));
  }

  Future<void> stopScan() async {
    await _printerManager.stopScan();
  }

  Future<void> selectPrinter(BluetoothDevice printer) async {
    _selectedPrinter = printer;
  }

  BluetoothDevice? get selectedPrinter => _selectedPrinter;

  Future<void> printInvoice(Invoice invoice) async {
    if (_selectedPrinter == null) {
      throw Exception('No printer selected');
    }

    // Get profile for your printer
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);
    List<int> bytes = [];

    // Add business info
    bytes += generator.text('Lulu Enterprises',
        styles: const PosStyles(align: PosAlign.center, bold: true));
    bytes += generator.text('Sales Invoice',
        styles: const PosStyles(align: PosAlign.center));
    bytes += generator.text('--------------------------------');

    // Add invoice details
    bytes += generator.text('Invoice #: ${invoice.id}');
    bytes += generator.text('Date: ${invoice.createdAt.toString().split('.')[0]}');
    bytes += generator.text('Customer: ${invoice.customerName}');
    bytes += generator.text('Address: ${invoice.customerAddress}');
    bytes += generator.text('--------------------------------');

    // Add items
    bytes += generator.text('Items:',
        styles: const PosStyles(bold: true));
    for (var item in invoice.items) {
      bytes += generator.text(
          '${item.product.name} x ${item.quantity}');
      bytes += generator.text(
          '${item.price.toStringAsFixed(2)} x ${item.quantity} = ${item.total.toStringAsFixed(2)}',
          styles: const PosStyles(align: PosAlign.right));
    }

    bytes += generator.text('--------------------------------');
    bytes += generator.text(
        'Total: ${invoice.total.toStringAsFixed(2)}',
        styles: const PosStyles(bold: true, align: PosAlign.right));

    // Add footer
    bytes += generator.text('--------------------------------');
    bytes += generator.text('Thank you for your business!',
        styles: const PosStyles(align: PosAlign.center));
    
    bytes += generator.feed(2);
    bytes += generator.cut();

    // Print
    await _printerManager.selectPrinter(_selectedPrinter!);
    final result = await _printerManager.printTicket(bytes);
    return result;
  }

  void dispose() {
    _printerManager.stopScan();
  }
} 