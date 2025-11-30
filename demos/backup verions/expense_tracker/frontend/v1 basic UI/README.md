# expense_tracker

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


### project Structure

 lib/
 ├─ main.dart                # Entry point, theme, routes, AuthGate
 ├─ firebase_options.dart    # Firebase config
 ├─ models/
 │   └─ expense.dart         # Expense model (id, title, amount, category, date, createdAt)
 ├─ services/
 │   ├─ firestore_service.dart # CRUD for expenses
 │   └─ auth_service.dart      # (optional) Firebase Auth helpers
 ├─ pages/
 │   ├─ home_page.dart       # Dashboard with expense list + summary
 │   ├─ add_expense_page.dart # Form to add new expense
 │   ├─ login_page.dart      # Auth screen
 │   ├─ profile_page.dart    # User info + logout/reset password
 │   └─ reports_page.dart    # Monthly/Category charts (later)
 ├─ widgets/
 │   ├─ expense_card.dart    # Reusable widget for expense display
 │   └─ summary_card.dart    # Reusable widget for totals/charts
 └─ utils/
     └─ formatters.dart      # Currency/date formatting helpers 
  