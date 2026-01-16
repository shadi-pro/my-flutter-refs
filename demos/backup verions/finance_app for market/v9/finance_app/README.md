# proejct name :
    A Flutter project.
    finance_app  
## ---------------------------------------------- 


## شرح المشروع باللغة العربية    :
## 📁 هيكل المشروع النهائي  project structure  :
  
finance_app/
├── android/
├── ios/
├── lib/
│   ├── main.dart
│   └── features/
│       ├── expense/
│       │   └── presentation/
│       │       ├── controllers/
│       │       │   ├── expense_controller.dart
│       │       │   └── budget_controller.dart
│       │       ├── bindings/
│       │       │   └── expense_binding.dart
│       │       └── pages/
│       │           ├── home_page.dart
│       │           ├── add_expense_page.dart
│       │           ├── budget_page.dart
│       │           └── reports_page.dart
│       │       └── widget/  $empty folder
│       │       └── data/  $empty folder
        │           └── datasources/         #empty folder
        |           └── models/              #empty folder
        |           └── repositories /       $empty folder
        │       └── domain/  $empty folder
        │           └── entities/            #empty folder
        │               └── expense_entity.dart        
        │               └── repositories /   $empty folder  
        │               └── usecases /       $empty folder
│       ├── alerts/
│       │   └── presentation/
│       │       ├── controllers/
│       │       │   └── alert_controller.dart
│       │       └── pages/
│       │           └── alerts_settings_page.dart
│       ├── backup/
│       │   └── presentation/
│       │       ├── controllers/
│       │       │   └── backup_controller.dart
│       │       └── pages/
│       │           └── backup_page.dart
│       └── search/
│           └── presentation/
│               ├── controllers/
│               │   └── expense_search_controller.dart
│               └── pages/
│                   └── filter_page.dart
│   └── core/
│       ├──  constants/                       #empty folder 
│       ├──  errors/                         #empty folder
        ├──  network/                        #empty folder
│       └──  usecases /                      #empty folder
│       └──  models /  
│       |    └── enums.dart/
        |
│       └──  utils /  
│           └──  error_handler.dart 
│           └──  secure_storage.dart 
 
├── pubspec.yaml
└── README.md

--------------------------------------------

### 🎯 ميزات التطبيق الكاملة project features:         
1. 📊 إدارة المعاملات (Core) :
✅ إضافة معاملات جديدة (دخل/مصروف)

✅ عرض جميع المعاملات في قائمة

✅ تفاصيل كاملة لكل معاملة

✅ تعديل المعاملات

✅ حذف المعاملات

✅ مسح كل البيانات

2. 💰 نظام الميزانية  :
✅ تحديد ميزانية شهرية

✅ ميزانية لكل فئة (طعام، مواصلات، إلخ)

✅ تتبع نسبة الإنفاق من الميزانية

✅ تحذيرات عند اقتراب تجاوز الميزانية

✅ صفحة إدارة الميزانية الكاملة

3. 📈 التقارير والإحصائيات :
✅ إحصائيات الشهر الحالي

✅ توزيع الدخل حسب الفئة

✅ توزيع المصروفات حسب الفئة

✅ رصيد الشهر

✅ عدد المعاملات

✅ صفحة تقارير متكاملة

4. 🔔 نظام التنبيهات الذكي :
✅ تنبيهات عند اقتراب تجاوز الميزانية

✅ تنبيهات للمصروفات الكبيرة

✅ إعدادات تنبيهات قابلة للتخصيص

✅ ملخص يومي (اختياري)

✅ صفحة إعدادات التنبيهات

5. 🔍 نظام البحث والفلترة  :
✅ شريط بحث في الصفحة الرئيسية

✅ فلترة بالفئة (طعام، مواصلات، إلخ)

✅ فلترة بالنوع (دخل/مصروف)

✅ فلترة بنطاق المبلغ

✅ صفحة فلترة متقدمة

✅ عرض عدد النتائج

✅ زر إعادة تعيين الفلاتر

6. 💾 النسخ الاحتياطي :
✅ إنشاء نسخة احتياطية كاملة

✅ استعادة البيانات من نسخة احتياطية

✅ تصدير تقرير نصي

✅ مشاركة ملف النسخة الاحتياطية

✅ تتبع تاريخ آخر نسخة

✅ صفحة إدارة النسخ الاحتياطية

7. 🎨 الميزات الفنية :
✅ Clean Architecture

✅ GetX State Management

✅ GetStorage للتخزين المحلي

✅ دعم اللغة العربية الكامل

✅ Dark/Light Mode (يتبع النظام)

✅ تصميم متجاوب

✅ معالجة الأخطاء

✅ إشعارات للمستخدم

✅ تحميل البيانات غير المتزامن

8. 📱 واجهات المستخدم :
✅ واجهة رئيسية مع شريط البحث

✅ بطاقة ملخص الرصيد

✅ قائمة معاملات مع تفاصيل

✅ صفحات متخصصة (ميزانية، تقارير، تنبيهات، نسخ احتياطي)

✅ Bottom Sheet لعرض التفاصيل

✅ Dialogs للتأكيد

✅ Snackbars للإشعارات

✅ أزرار إجراءات سريعة
-------------------------------------------

##  🔧 الـ Controllers الرئيسية main technical features :


1. ExpenseController  :
إدارة جميع المعاملات

حساب الإجماليات (دخل، مصروف، رصيد)

العمليات CRUD الكاملة

التخزين المحلي بالكامل

2. BudgetController  :
إدارة الميزانية الشهرية

متابعة الميزانية لكل فئة

حساب النسب المئوية

التحذيرات والتنبيهات

3. AlertController  :
إعدادات التنبيهات

التحقق من الشروط

عرض التنبيهات المناسبة

حفظ الإعدادات

4. BackupController   :
إنشاء النسخ الاحتياطية

استعادة البيانات

تصدير التقارير

إدارة الملفات

5. ExpenseSearchController :
البحث في المعاملات

الفلترة بالفئة والنوع

الفلترة بنطاق المبلغ

إعادة تعيين الفلاتر
-------------------------------------

🌐 الدعم التقني
الحزم المستخدمة:
get: ^4.6.5 - State Management & Navigation

get_storage: ^2.1.1 - Local Storage

google_fonts: ^6.0.0 - الخطوط العربية

intl: ^0.19.0 - تنسيق التواريخ

share_plus: ^7.0.1 - مشاركة الملفات

path_provider: ^2.1.1 - مسارات الملفات
---------------------------------------------


الدعم اللغوي:
✅ اللغة العربية (الافتراضية)

✅ تنسيق التاريخ العربي

✅ اتجاه RTL

✅ خطوط عربية
-----------------


الدعم المرئي:
✅ Light Mode

✅ Dark Mode

✅ ألوان متوافقة

✅ تصميم Material Design
-----------------

🚀 النشر : 
-------------------------------------
 
🏆 المزايات الرئيسية لمشروع :
✅ تطبيق كامل من الصفر إلى النهاية
✅ هيكل Clean Architecture محترف
✅ إدارة حالة متقدمة مع GetX
✅ تخزين بيانات محلي مع GetStorage
✅ واجهات متعددة مع Dark Mode
✅ نظام بحث وفلترة متكامل
✅ ميزانية وتقارير احترافية
✅ نسخ احتياطي واستعادة
===============================================================
===============================================================

##  Project description by English version :

## 📁 Final Project Structure :
finance_app/
├── android/
├── ios/
├── lib/
│   ├── main.dart
│   └── features/
│       ├── expense/
│       │   └── presentation/
│       │       ├── controllers/
│       │       │   ├── expense_controller.dart
│       │       │   └── budget_controller.dart
│       │       ├── bindings/
│       │       │   └── expense_binding.dart
│       │       └── pages/
│       │           ├── home_page.dart
│       │           ├── add_expense_page.dart
│       │           ├── budget_page.dart
│       │           └── reports_page.dart
│       │       └── widget/  $empty folder
│       │       └── data/  $empty folder
        │           └── datasources/         #empty folder
        |           └── models/              #empty folder
        |           └── repositories /       $empty folder
│       │       └── domain/  $empty folder
        │           └── entities/            #empty folder
        │               └──  expense_entity.dart        
        │               └── repositories /   $empty folder  
        │               └── usecases /       $empty folder
│       ├── alerts/
│       │   └── presentation/
│       │       ├── controllers/
│       │       │   └── alert_controller.dart
│       │       └── pages/
│       │           └── alerts_settings_page.dart
│       ├── backup/
│       │   └── presentation/
│       │       ├── controllers/
│       │       │   └── backup_controller.dart
│       │       └── pages/
│       │           └── backup_page.dart
│       └── search/
│           └── presentation/
│               ├── controllers/
│               │   └── expense_search_controller.dart
│               └── pages/
│                   └── filter_page.dart
│   └── core/
│       ├── constants/                       #empty folder 
│       ├──  errors/                         #empty folder
        ├──  network/                        #empty folder
│       └──  usecases /                      #empty folder
│       └──  models /  
│       |    └── enums.dart/
        |
│       └──  utils /  
│           └──  error_handler.dart 
│           └──  secure_storage.dart 
 
├── pubspec.yaml
└── README.md
-------------------------

## 🎯 Complete Application Features
1. 📊 Transaction Management (Core)
✅ Add new transactions (Income/Expense)

✅ View all transactions in list

✅ Full details for each transaction

✅ Edit transactions

✅ Delete transactions

✅ Clear all data

2. 💰 Budget System
✅ Set monthly budget

✅ Budget per category (Food, Transport, etc.)

✅ Track spending percentage

✅ Alerts when approaching budget limit

✅ Complete budget management page

3. 📈 Reports & Statistics
✅ Current month statistics

✅ Income distribution by category

✅ Expense distribution by category

✅ Monthly balance

✅ Transaction count

✅ Complete reports page

4. 🔔 Smart Alert System
✅ Alerts when approaching budget limit

✅ Large expense alerts

✅ Customizable alert settings

✅ Daily summary (optional)

✅ Alerts settings page

5. 🔍 Search & Filter System
✅ Search bar in home page

✅ Filter by category (Food, Transport, etc.)

✅ Filter by type (Income/Expense)

✅ Filter by amount range

✅ Advanced filter page

✅ Display result count

✅ Reset filters button

6. 💾 Backup System
✅ Create full backup

✅ Restore data from backup

✅ Export text report

✅ Share backup file

✅ Track last backup date

✅ Backup management page

7. 🎨 Technical Features
✅ Clean Architecture

✅ GetX State Management

✅ GetStorage for local storage

✅ Full Arabic language support

✅ Dark/Light Mode (follows system)

✅ Responsive design

✅ Error handling

✅ User notifications

✅ Async data loading

8. 📱 User Interfaces
✅ Main interface with search bar

✅ Balance summary card

✅ Transactions list with details

✅ Specialized pages (Budget, Reports, Alerts, Backup)

✅ Bottom Sheet for details

✅ Dialogs for confirmation

✅ Snackbars for notifications

✅ Quick action buttons

## 🔧 Main Controller :
1. ExpenseController
Manage all transactions

Calculate totals (Income, Expense, Balance)

Full CRUD operations

Complete local storage

2. BudgetController
Manage monthly budget

Track budget per category

Calculate percentages

Warnings and alerts

3. AlertController
Alert settings

Check conditions

Display appropriate alerts

Save settings

4. BackupController
Create backups

Restore data

Export reports

File management

5. ExpenseSearchController
Search in transactions

Filter by category and type

Filter by amount range

Reset filters

## 🌐 Technical Support :
Packages Used:
get: ^4.6.5 - State Management & Navigation

get_storage: ^2.1.1 - Local Storage

google_fonts: ^6.0.0 - Arabic Fonts

intl: ^0.19.0 - Date formatting

share_plus: ^7.0.1 - File sharing

path_provider: ^2.1.1 - File paths

##  Language Support : 
✅ Arabic (default)

✅ Arabic date formatting

✅ RTL direction

✅ Arabic fonts

##  Visual Support : 
✅ Light Mode

✅ Dark Mode

✅ Compatible colors

✅ Material Design
-------------------

## 🚀  Deployment ! 
 

## 🏆  Project main bvreif feastures  :  
✅ Complete Application from scratch to finish
✅ Professional Clean Architecture structure
✅ Advanced State Management with GetX
✅ Local Data Storage with GetStorage
✅ Multiple Interfaces with Dark Mode
✅ Complete Search & Filter system
✅ Professional Budget & Reports
✅ Backup & Restore functionality

