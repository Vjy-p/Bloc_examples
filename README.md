# bloc_examples

A scalable Flutter application demonstrating **real-world implementation of BLoC architecture** with multiple features like chat, product management, social feed, and pagination.

---

## ✨ Features

### 💬 Chat (Real-time)

- Real-time messaging using **Sockets**
- Message send/receive flow
- Designed for scalability with BLoC
- Handles live updates efficiently

---

### 🛍️ Products & Cart

- Product listing with pagination
- Add to cart functionality
- View and manage cart items
- State management handled via BLoC

---

### 📰 Posts / Feed

- Paginated feed system
- Like / Unlike functionality
- Optimized UI updates using BLoC states

---

### 🔄 Pagination (Across Modules)

- Implemented in:
  - Products
  - Posts
  - Recipes

- Efficient data loading (lazy loading)
- Smooth scrolling experience

---

## 🧠 Architecture

This project follows **BLoC (Business Logic Component) architecture** to ensure:

- Separation of concerns
- Scalable code structure
- Testability
- Maintainability

### 🔁 BLoC Flow

User Action → Event → Bloc → State → UI Update

---

## 🛠 Tech Stack

- **Flutter**
- **Dart**
- **flutter_bloc**
- **Socket (real-time communication)**
- REST APIs (for products, posts, recipes)

---

## ⚡ Key Highlights

- Real-time chat using sockets
- Multiple feature modules in a single app
- Pagination implemented across different domains
- Clean and reusable BLoC pattern
- Scalable folder structure

---

## ▶️ Getting Started

```bash
git clone https://github.com/Vjy-p/Bloc_examples.git
cd Bloc_examples
flutter pub get
flutter run
```

---

## 🎯 What This Project Demonstrates

- Handling multiple features using BLoC
- Managing complex state across modules
- Real-time updates with sockets
- Pagination & performance optimization
- Production-like app structure

---

## 📌 Future Improvements

- Add unit & widget tests
- Implement offline caching
- Improve UI/UX
- Add authentication flow

---

## 👨‍💻 Author

**Vijay**

- GitHub: https://github.com/Vjy-p

---

## ⭐ Support

If you found this helpful, give it a ⭐ on GitHub!
