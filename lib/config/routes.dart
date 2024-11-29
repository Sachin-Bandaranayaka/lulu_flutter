import 'package:flutter/material.dart';
import 'package:lulu/screens/home/home_screen.dart';
import 'package:lulu/screens/products/products_screen.dart';
import 'package:lulu/screens/products/product_form_screen.dart';
import 'package:lulu/screens/invoices/invoices_screen.dart';
import 'package:lulu/screens/invoices/invoice_form_screen.dart';
import 'package:lulu/screens/expenses/expenses_screen.dart';
import 'package:lulu/screens/settings/settings_screen.dart';

class AppRoutes {
  static const home = '/';
  static const products = '/products';
  static const productForm = '/products/form';
  static const invoices = '/invoices';
  static const invoiceForm = '/invoices/form';
  static const expenses = '/expenses';
  static const settings = '/settings';
  
  static Map<String, WidgetBuilder> get routes => {
    home: (context) => const HomeScreen(),
    products: (context) => const ProductsScreen(),
    productForm: (context) => const ProductFormScreen(),
    invoices: (context) => const InvoicesScreen(),
    invoiceForm: (context) => const InvoiceFormScreen(),
    expenses: (context) => const ExpensesScreen(),
    settings: (context) => const SettingsScreen(),
  };
} 