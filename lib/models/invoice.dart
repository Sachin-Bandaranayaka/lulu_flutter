import 'package:lulu/models/product.dart';

class Invoice {
  final String id;
  final String customerName;
  final String customerAddress;
  final List<InvoiceItem> items;
  final double total;
  final DateTime createdAt;
  final String status; // 'pending', 'completed', 'cancelled'

  Invoice({
    required this.id,
    required this.customerName,
    required this.customerAddress,
    required this.items,
    required this.total,
    required this.createdAt,
    this.status = 'pending',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customerName': customerName,
      'customerAddress': customerAddress,
      'items': items.map((item) => item.toMap()).toList(),
      'total': total,
      'createdAt': createdAt.toIso8601String(),
      'status': status,
    };
  }

  factory Invoice.fromMap(Map<String, dynamic> map) {
    return Invoice(
      id: map['id'],
      customerName: map['customerName'],
      customerAddress: map['customerAddress'],
      items: (map['items'] as List)
          .map((item) => InvoiceItem.fromMap(item))
          .toList(),
      total: map['total'],
      createdAt: DateTime.parse(map['createdAt']),
      status: map['status'],
    );
  }
}

class InvoiceItem {
  final Product product;
  final int quantity;
  final double price;
  final double total;

  InvoiceItem({
    required this.product,
    required this.quantity,
    required this.price,
    required this.total,
  });

  Map<String, dynamic> toMap() {
    return {
      'product': product.toMap(),
      'quantity': quantity,
      'price': price,
      'total': total,
    };
  }

  factory InvoiceItem.fromMap(Map<String, dynamic> map) {
    return InvoiceItem(
      product: Product.fromMap(map['product']),
      quantity: map['quantity'],
      price: map['price'],
      total: map['total'],
    );
  }
} 