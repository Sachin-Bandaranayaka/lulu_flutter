import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:lulu/models/invoice.dart';
import 'package:lulu/providers/invoice_provider.dart';
import 'package:lulu/screens/invoices/invoice_form_screen.dart';
import 'package:lulu/screens/settings/printer_settings_screen.dart';

class InvoicesScreen extends StatefulWidget {
  const InvoicesScreen({super.key});

  @override
  State<InvoicesScreen> createState() => _InvoicesScreenState();
}

class _InvoicesScreenState extends State<InvoicesScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<InvoiceProvider>().loadInvoices(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoices'),
      ),
      body: Consumer<InvoiceProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.invoices.isEmpty) {
            return const Center(child: Text('No invoices found'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: provider.invoices.length,
            itemBuilder: (context, index) {
              final invoice = provider.invoices[index];
              return _buildInvoiceCard(context, invoice);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToInvoiceForm(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildInvoiceCard(BuildContext context, Invoice invoice) {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
    
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ExpansionTile(
        title: Text(invoice.customerName),
        subtitle: Text(
          'Total: \$${invoice.total.toStringAsFixed(2)} | ${dateFormat.format(invoice.createdAt)}',
        ),
        trailing: _buildStatusChip(invoice.status),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Address: ${invoice.customerAddress}'),
                const Divider(),
                const Text(
                  'Items:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...invoice.items.map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        '${item.product.name} x ${item.quantity} = \$${item.total.toStringAsFixed(2)}',
                      ),
                    )),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => _printInvoice(invoice),
                      icon: const Icon(Icons.print),
                      label: const Text('Print'),
                    ),
                    if (invoice.status == 'pending')
                      ElevatedButton.icon(
                        onPressed: () => _updateStatus(invoice.id, 'completed'),
                        icon: const Icon(Icons.check),
                        label: const Text('Mark as Completed'),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    IconData icon;

    switch (status) {
      case 'completed':
        color = Colors.green;
        icon = Icons.check_circle;
        break;
      case 'cancelled':
        color = Colors.red;
        icon = Icons.cancel;
        break;
      default:
        color = Colors.orange;
        icon = Icons.pending;
    }

    return Chip(
      label: Text(
        status.toUpperCase(),
        style: TextStyle(color: color, fontSize: 12),
      ),
      avatar: Icon(icon, color: color, size: 16),
      backgroundColor: color.withOpacity(0.1),
    );
  }

  void _navigateToInvoiceForm(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const InvoiceFormScreen(),
      ),
    );
  }

  Future<void> _updateStatus(String invoiceId, String status) async {
    try {
      await context.read<InvoiceProvider>().updateInvoiceStatus(invoiceId, status);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _printInvoice(Invoice invoice) async {
    try {
      final printerProvider = context.read<PrinterProvider>();
      if (printerProvider.selectedPrinter == null) {
        // Show printer selection dialog if no printer is selected
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('No Printer Selected'),
            content: const Text(
              'Please select a printer in Settings > Printer Settings before printing.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PrinterSettingsScreen(),
                    ),
                  );
                },
                child: const Text('Settings'),
              ),
            ],
          ),
        );
        return;
      }

      // Show printing dialog
      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Printing...'),
            ],
          ),
        ),
      );

      // Print invoice
      await printerProvider.printInvoice(invoice);

      // Close printing dialog and show success message
      if (!mounted) return;
      Navigator.pop(context); // Close printing dialog
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invoice printed successfully')),
      );
    } catch (e) {
      // Close printing dialog if open
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error printing invoice: ${e.toString()}')),
      );
    }
  }
} 