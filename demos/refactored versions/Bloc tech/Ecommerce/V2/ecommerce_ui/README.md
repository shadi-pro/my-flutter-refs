# 🛒 Flutter E‑Commerce App

A feature‑rich e‑commerce demo built with **Flutter** and **Firebase**.  
This project showcases product browsing, detailed pages, cart/wishlist management, and a roadmap for future scalability.

---

## ✨ Features (Current Progress)

- **Homepage with category filtering**: Browse products by category chips and search bar.  
- **Product details page**: View product image, price, stock status, description, and interact with cart/wishlist.  
- **Cart management**: Add/remove items, adjust quantities, view total price, and proceed to checkout.  
- **Wishlist management**: Save favorite products, remove them, and preview details.  
- **Orders tab**: Placeholder page ready to display past orders.  
- **Settings page**: Toggle dark/light mode for personalized UI.

---

## 🛠️ Tech Stack

- **Flutter** (UI framework)  
- **Firebase Firestore** (cloud database)  
- **Firebase Auth** (planned for user login)  
- **Dart** (programming language)

---

## 📌 Roadmap

### ✅ Current Core Features
- Homepage with category filtering  
- Product details page  
- Cart management  
- Wishlist management  
- Orders tab (placeholder)  
- Settings page  

### 🔧 Short‑Term Enhancements
- Orders integration with Firestore  
- Search improvements (fuzzy + category filters)  
- UI polish (icons, badges, error handling)  
- Snackbar feedback for all actions  

### 🌟 Medium‑Term Goals
- User authentication (Firebase Auth)  
- Persistent cart/wishlist synced to Firestore  
- Checkout flow with address & payment  
- Responsive design for tablets  

### 🚀 Long‑Term Vision
- Scalable product catalog with pagination  
- Analytics dashboard for product popularity  
- Multi‑language support  
- Deployment to Play Store/App Store  

---

## ▶️ Demo Flow

1. **Browse products** on the homepage.  
2. **Tap a product** → navigate to detailed page.  
3. **Add/remove from cart** → cart badge updates.  
4. **Add/remove from wishlist** → wishlist badge updates.  
5. **Proceed to checkout** → orders flow (coming soon).  

---

## 📷 Screenshots (to add later)

- Homepage  
- Product details  
- Cart page  
- Wishlist page  

---

## 🤝 Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you’d like to change.

---

## 📄 License

This project is licensed under the MIT License.


### breif project structure :
ecommerce_ui/
├── lib/
│   ├── blocs/ (Theme, Cart, Product, Wishlist)
│   ├── pages/ (All UI pages)
│   ├── widgets/ (Reusable components)
│   ├── models/ (Data models)
│   ├── repositories/ (Data layer)
│   ├── utils/ (Helpers)
│   └── main.dart (BLOC providers setup)