// lib/features/expense/presentation/widgets/simple_card.dart

import 'package:flutter/material.dart';

class SimpleCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;

  const SimpleCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}
