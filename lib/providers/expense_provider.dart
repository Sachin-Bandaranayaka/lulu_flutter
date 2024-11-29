import 'package:flutter/foundation.dart';
import 'package:lulu/models/expense.dart';
import 'package:lulu/services/firebase_service.dart';

class ExpenseProvider extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  List<Expense> _expenses = [];
  bool _isLoading = false;

  List<Expense> get expenses => _expenses;
  bool get isLoading => _isLoading;

  Future<void> loadExpenses() async {
    _isLoading = true;
    notifyListeners();

    try {
      _firebaseService.getExpenses().listen((expenses) {
        _expenses = expenses;
        _isLoading = false;
        notifyListeners();
      });
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> addExpense(Expense expense) async {
    await _firebaseService.createExpense(expense);
  }

  Future<void> updateExpense(Expense expense) async {
    await _firebaseService.updateExpense(expense);
  }

  Future<void> deleteExpense(String expenseId) async {
    await _firebaseService.deleteExpense(expenseId);
  }

  double getTotalExpenses() {
    return _expenses.fold(0, (sum, expense) => sum + expense.amount);
  }

  Map<String, double> getExpensesByCategory() {
    final map = <String, double>{};
    for (var expense in _expenses) {
      map[expense.category] = (map[expense.category] ?? 0) + expense.amount;
    }
    return map;
  }
} 