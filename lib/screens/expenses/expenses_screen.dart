import 'package:flutter/material.dart';

class ExpensesScreen extends StatelessWidget {
  const ExpensesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses'),
      ),
      body: const Center(
        child: Text('Expenses Screen'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement add expense
        },
        child: const Icon(Icons.add),
      ),
    );
  }
} 