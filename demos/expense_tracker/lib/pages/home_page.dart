import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/expense.dart';
import '../services/firestore_service.dart';
import 'add_expense_page.dart';

class HomePage extends StatelessWidget {
  final VoidCallback onToggleTheme;
  final FirestoreService _firestoreService = FirestoreService();

  HomePage({super.key, required this.onToggleTheme});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: onToggleTheme,
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
      ),
      body: user == null
          ? const Center(child: Text('Please log in to view expenses'))
          : StreamBuilder<List<Expense>>(
              stream: _firestoreService.getExpenses(user.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('Error loading expenses'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No expenses yet'));
                }

                final expenses = snapshot.data!;
                return ListView.builder(
                  itemCount: expenses.length,
                  itemBuilder: (context, index) {
                    final expense = expenses[index];
                    return ListTile(
                      title: Text(expense.title),
                      subtitle: Text(
                        '${expense.category} • ${expense.date.toLocal().toString().split(' ')[0]}',
                      ),
                      trailing: Text(
                        '\$${expense.amount.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
      floatingActionButton: user == null
          ? null
          : FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddExpensePage(uid: user.uid),
                  ),
                );
              },
              child: const Icon(Icons.add),
            ),
    );
  }
}
