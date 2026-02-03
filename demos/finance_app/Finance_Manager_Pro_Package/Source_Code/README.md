<div align="center">

# 📱 Finance Manager Pro  
# 💼 تطبيق إدارة مالية ذكي

![Flutter](https://img.shields.io/badge/Flutter-3.13+-blue)
![Android](https://img.shields.io/badge/Android-5.0+-green)
![License](https://img.shields.io/badge/License-MIT-yellow)
![Languages](https://img.shields.io/badge/اللغة-Arabic_&_English-orange)

**تطبيق Flutter متكامل لإدارة الشؤون المالية الشخصية**  
**A complete Flutter application for personal financial management**

</div>

---

## 🌍 اللغات المتاحة | Available Languages
- 🇸🇦 **العربية:** واجهة كاملة مع دعم كامل للغة العربية
- 🇺🇸 **English:** Complete interface with full English support

---

## 🚀 البدء السريع | Quick Start

### 📥 التحميل والتثبيت | Download & Install
1. **حمل الملف:** `Finance_Manager_Pro.apk`  
   **Download:** `Finance_Manager_Pro.apk`

2. **التثبيت على الأندرويد:**  
   **Install on Android:**
   - افتح الملف على هاتفك | Open the file on your phone
   - اضغط "تثبيت" | Tap "Install"
   - اسمح بالتثبيت من مصادر غير معروفة إذا لزم الأمر | Allow installation from unknown sources if needed

3. **البدء:** افتح التطبيق وابدأ في إدارة أموالك!  
   **Start:** Open the app and start managing your finances!

---

## ✨ المميزات الرئيسية | Key Features

### 💰 الإدارة المالية | Financial Management
- 📊 **تتبع المصروفات والدخل** | Expense and income tracking
- 🎯 **تحديد الأهداف المالية** | Set financial goals
- ⚠️ **تنبيهات عند تجاوز الميزانية** | Budget exceed alerts
- 📈 **تقارير شهرية تفصيلية** | Detailed monthly reports

### 🔒 الأمان والنسخ الاحتياطي | Security & Backup
- ☁️ **نسخ احتياطي سحابي** | Cloud backup
- 📁 **استعادة البيانات بضغطة واحدة** | One-tap data restore
- 🔐 **تشفير البيانات المحلية** | Local data encryption
- 📤 **تصدير التقارير بصيغة نصية** | Export reports as text

### 🎨 الواجهة والتجربة | UI & Experience
- 🎭 **واجهة مستخدم حديثة** | Modern user interface
- 📱 **متوافق مع جميع أحجام الشاشات** | Responsive for all screen sizes
- 🌙 **وضع ليلي (Dark Mode)** | Dark mode support
- ⚡ **أداء سريع وسلس** | Fast and smooth performance

---

## 📊 لقطات الشاشة | Screenshots

| الصفحة الرئيسية | Home Page | إدارة الأهداف | Goals Management |
|-----------------|-----------|---------------|------------------|
| ![Home](https://via.placeholder.com/300x600/4CAF50/FFFFFF?text=Home+Page) | ![Home EN](https://via.placeholder.com/300x600/2196F3/FFFFFF?text=Home+Page) | ![Goals](https://via.placeholder.com/300x600/FF9800/FFFFFF?text=Goals) | ![Goals EN](https://via.placeholder.com/300x600/9C27B0/FFFFFF?text=Goals) |

| التقارير | Reports | النسخ الاحتياطي | Backup |
|----------|---------|-----------------|--------|
| ![Reports](https://via.placeholder.com/300x600/3F51B5/FFFFFF?text=التقارير) | ![Reports EN](https://via.placeholder.com/300x600/009688/FFFFFF?text=Reports) | ![Backup](https://via.placeholder.com/300x600/FF5722/FFFFFF?text=النسخ+الاحتياطي) | ![Backup EN](https://via.placeholder.com/300x600/795548/FFFFFF?text=Backup) |

---

## 💻 للمطورين | For Developers

### 🛠️ متطلبات التشغيل | Requirements
- **Flutter:** 3.13.0 أو أعلى | 3.13.0 or higher
- **Dart:** 3.1.0 أو أعلى | 3.1.0 or higher
- **Android Studio / VS Code**

### 🔧 خطوات التشغيل | Setup Steps

```bash
# 1. استنساخ المشروع | Clone the project
git clone [project-url]

# 2. تثبيت التبعيات | Install dependencies
flutter pub get

# 3. تشغيل على جهاز متصل | Run on connected device
flutter run

# 4. بناء نسخة Release | Build release version
flutter build apk --release --split-per-abi
```

### 📁 هيكل المشروع | Project Structure
```
lib/
├── core/                 # الأساسيات | Core
├── features/             # الميزات | Features
│   ├── expense/          # المصروفات | Expenses
│   ├── goals/            # الأهداف | Goals
│   ├── backup/           # النسخ الاحتياطي | Backup
│   └── alerts/           # التنبيهات | Alerts
└── main.dart            # نقطة الدخول | Entry point
```

### 🎨 تخصيص التطبيق | Customization
```dart
// تغيير الألوان الأساسية | Change primary colors
// في | in: core/constants/app_colors.dart
class AppColors {
  static const Color primary = Color(0xFF4CAF50);  // الأخضر | Green
  static const Color secondary = Color(0xFF2196F3); // الأزرق | Blue
}

// إضافة لغة جديدة | Add new language
// في | in: assets/lang/ أضف | add new_language.json
{
  "welcome": "مرحباً",
  "welcome_en": "Welcome"
}
```

---

## ❓ الأسئلة الشائعة | FAQ

### ❓ هل يحتاج التطبيق إنترنت؟ | Does the app need internet?
**✅ لا، يعمل دون إنترنت** | **No, works offline**
- جميع الميزات الأساسية تعمل دون إنترنت | All core features work offline
- فقط النسخ الاحتياطي السحابي يحتاج إنترنت | Only cloud backup needs internet

### ❓ ما هي صلاحيات التطبيق؟ | What permissions does the app need?
**📁 تخزين** (للنسخ الاحتياطي) | **Storage** (for backup)
**🔔 إشعارات** (للتنبيهات) | **Notifications** (for alerts)

### ❓ كيف أستعيد بياناتي؟ | How do I restore my data؟
1. اذهب لصفحة النسخ الاحتياطي | Go to Backup page
2. اضغط على "استعادة" | Tap "Restore"
3. اختر ملف النسخة الاحتياطية | Choose backup file

---

## 📞 الدعم والاتصال | Support & Contact

### 📧 الدعم الفني | Technical Support
- **البريد الإلكتروني:** your.email@example.com
- **وقت الاستجابة:** 24-48 ساعة | Response time: 24-48 hours
- **يرجى إرفاق إيصال الشراء** | Please include purchase receipt

### 🌐 وسائل التواصل | Social Media
- **تويتر:** [@yourusername](https://twitter.com/yourusername)
- **تليجرام:** [@yourchannel](https://t.me/yourchannel)
- **موقع ويب:** [yourwebsite.com](https://yourwebsite.com)

### 💼 خدمات مخصصة | Custom Services
نقدم خدمات تخصيص حسب احتياجاتك: | We offer customization services:
- إضافة ميزات جديدة | Adding new features
- تغيير التصميم | Design changes
- دمج مع أنظمة خارجية | Integration with external systems

---

## 📜 الرخصة | License

هذا المشروع مرخص تحت رخصة **MIT**. | This project is licensed under the **MIT License**.

```
MIT License

Copyright (c) 2024 Finance Manager Pro

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

انظر ملف [LICENSE](LICENSE) للتفاصيل الكاملة. | See the [LICENSE](LICENSE) file for full details.

---

## ⭐ دعم المشروع | Support the Project

إذا أعجبك المشروع، يمكنك: | If you like the project, you can:

1. ⭐ **تقييمه على Gumroad** | **Rate it on Gumroad**
2. 📢 **مشاركته مع أصدقائك** | **Share it with friends**
3. 💡 **اقتراح تحسينات** | **Suggest improvements**
4. 🐛 **الإبلاغ عن أخطاء** | **Report bugs**

---

<div align="center">

### 💖 صنع بكل الحب لمساعدة الناس على إدارة أموالهم بشكل أفضل
### 💖 Made with love to help people manage their money better

**Finance Manager Pro** © 2026 | جميع الحقوق محفوظة | All rights reserved

[📥 تحميل الآن | Download Now](#) | [📖 الوثائق | Documentation](#) | [📞 اتصل بنا | Contact Us](#)

</div>