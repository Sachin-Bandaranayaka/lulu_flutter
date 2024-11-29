import 'package:flutter/foundation.dart';
import 'package:lulu/models/invoice.dart';
import 'package:lulu/services/firebase_service.dart';

class InvoiceProvider extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  List<Invoice> _invoices = [];
  bool _isLoading = false;

  List<Invoice> get invoices => _invoices;
  bool get isLoading => _isLoading;

  Future<void> loadInvoices() async {
    _isLoading = true;
    notifyListeners();

    try {
      _firebaseService.getInvoices().listen((invoices) {
        _invoices = invoices;
        _isLoading = false;
        notifyListeners();
      });
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> createInvoice(Invoice invoice) async {
    await _firebaseService.createInvoice(invoice);
  }

  Future<void> updateInvoiceStatus(String invoiceId, String status) async {
    await _firebaseService.updateInvoiceStatus(invoiceId, status);
  }
} 