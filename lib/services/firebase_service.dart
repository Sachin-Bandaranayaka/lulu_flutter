import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lulu/models/product.dart';
import 'package:lulu/models/invoice.dart';
import 'package:lulu/models/expense.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Products Collection Reference
  CollectionReference<Map<String, dynamic>> get _productsRef => 
      _firestore.collection('products');

  // Invoices Collection Reference
  CollectionReference<Map<String, dynamic>> get _invoicesRef =>
      _firestore.collection('invoices');

  // Expenses Collection Reference
  CollectionReference<Map<String, dynamic>> get _expensesRef =>
      _firestore.collection('expenses');

  // Create Product
  Future<void> createProduct(Product product) async {
    await _productsRef.doc(product.id).set(product.toMap());
  }

  // Read Products
  Stream<List<Product>> getProducts() {
    return _productsRef
        .orderBy('name')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Product.fromMap(doc.data()))
            .toList());
  }

  // Update Product
  Future<void> updateProduct(Product product) async {
    await _productsRef.doc(product.id).update(product.toMap());
  }

  // Delete Product
  Future<void> deleteProduct(String productId) async {
    await _productsRef.doc(productId).delete();
  }

  // Create Invoice
  Future<void> createInvoice(Invoice invoice) async {
    await _invoicesRef.doc(invoice.id).set(invoice.toMap());
    
    // Update product quantities
    for (var item in invoice.items) {
      final product = item.product;
      product.quantity -= item.quantity;
      await updateProduct(product);
    }
  }

  // Read Invoices
  Stream<List<Invoice>> getInvoices() {
    return _invoicesRef
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Invoice.fromMap(doc.data())).toList());
  }

  // Update Invoice Status
  Future<void> updateInvoiceStatus(String invoiceId, String status) async {
    await _invoicesRef.doc(invoiceId).update({'status': status});
  }

  // Create Expense
  Future<void> createExpense(Expense expense) async {
    await _expensesRef.doc(expense.id).set(expense.toMap());
  }

  // Read Expenses
  Stream<List<Expense>> getExpenses() {
    return _expensesRef
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Expense.fromMap(doc.data())).toList());
  }

  // Update Expense
  Future<void> updateExpense(Expense expense) async {
    await _expensesRef.doc(expense.id).update(expense.toMap());
  }

  // Delete Expense
  Future<void> deleteExpense(String expenseId) async {
    await _expensesRef.doc(expenseId).delete();
  }
} 