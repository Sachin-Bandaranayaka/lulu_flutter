class Expense {
  final String id;
  final String description;
  final double amount;
  final String category;
  final DateTime date;
  final String? notes;
  final DateTime createdAt;

  Expense({
    required this.id,
    required this.description,
    required this.amount,
    required this.category,
    required this.date,
    this.notes,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'amount': amount,
      'category': category,
      'date': date.toIso8601String(),
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      description: map['description'],
      amount: map['amount'].toDouble(),
      category: map['category'],
      date: DateTime.parse(map['date']),
      notes: map['notes'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}

class ExpenseCategory {
  static const String fuel = 'Fuel';
  static const String maintenance = 'Vehicle Maintenance';
  static const String supplies = 'Office Supplies';
  static const String salary = 'Salary';
  static const String other = 'Other';

  static List<String> get values => [
        fuel,
        maintenance,
        supplies,
        salary,
        other,
      ];
} 