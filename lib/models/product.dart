class Product {
  final String id;
  final String name;
  final double price;
  int quantity;
  final String unit; // e.g., "packet", "bar"
  final DateTime createdAt;
  DateTime updatedAt;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.unit,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'quantity': quantity,
      'unit': unit,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      price: map['price'].toDouble(),
      quantity: map['quantity'],
      unit: map['unit'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }
} 