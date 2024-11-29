import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lulu/models/invoice.dart';
import 'package:lulu/models/product.dart';
import 'package:lulu/providers/invoice_provider.dart';
import 'package:lulu/providers/product_provider.dart';

class InvoiceFormScreen extends StatefulWidget {
  const InvoiceFormScreen({super.key});

  @override
  State<InvoiceFormScreen> createState() => _InvoiceFormScreenState();
}

class _InvoiceFormScreenState extends State<InvoiceFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _customerNameController = TextEditingController();
  final _customerAddressController = TextEditingController();
  final List<InvoiceItem> _items = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Invoice'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _customerNameController,
              decoration: const InputDecoration(labelText: 'Customer Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter customer name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _customerAddressController,
              decoration: const InputDecoration(labelText: 'Customer Address'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter customer address';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            _buildItemsList(),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addItem,
              child: const Text('Add Item'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveInvoice,
              child: const Text('Generate Invoice'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemsList() {
    return Column(
      children: [
        const Text(
          'Items',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ..._items.map((item) => _buildItemCard(item)).toList(),
      ],
    );
  }

  Widget _buildItemCard(InvoiceItem item) {
    return Card(
      child: ListTile(
        title: Text(item.product.name),
        subtitle: Text(
          'Quantity: ${item.quantity} | Price: \$${item.price} | Total: \$${item.total}',
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () => _removeItem(item),
        ),
      ),
    );
  }

  void _addItem() async {
    final product = await _selectProduct();
    if (product != null) {
      final quantity = await _inputQuantity(product);
      if (quantity != null) {
        setState(() {
          _items.add(InvoiceItem(
            product: product,
            quantity: quantity,
            price: product.price,
            total: product.price * quantity,
          ));
        });
      }
    }
  }

  void _removeItem(InvoiceItem item) {
    setState(() {
      _items.remove(item);
    });
  }

  Future<Product?> _selectProduct() async {
    return showDialog<Product>(
      context: context,
      builder: (context) {
        final products = context.read<ProductProvider>().products;
        return AlertDialog(
          title: const Text('Select Product'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ListTile(
                  title: Text(product.name),
                  subtitle: Text('Stock: ${product.quantity} ${product.unit}'),
                  onTap: () => Navigator.pop(context, product),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future<int?> _inputQuantity(Product product) async {
    final controller = TextEditingController();
    return showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Enter quantity for ${product.name}'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Quantity (max: ${product.quantity})',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final quantity = int.tryParse(controller.text);
              if (quantity != null && quantity <= product.quantity) {
                Navigator.pop(context, quantity);
              }
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _saveInvoice() async {
    if (_formKey.currentState!.validate() && _items.isNotEmpty) {
      final invoice = Invoice(
        id: DateTime.now().toString(),
        customerName: _customerNameController.text,
        customerAddress: _customerAddressController.text,
        items: _items,
        total: _items.fold(0, (sum, item) => sum + item.total),
        createdAt: DateTime.now(),
      );

      try {
        await context.read<InvoiceProvider>().createInvoice(invoice);
        if (mounted) {
          Navigator.pop(context);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  @override
  void dispose() {
    _customerNameController.dispose();
    _customerAddressController.dispose();
    super.dispose();
  }
} 