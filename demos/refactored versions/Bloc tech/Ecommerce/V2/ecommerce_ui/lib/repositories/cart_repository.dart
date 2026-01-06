import '../models/product.dart';

abstract class CartRepository {
  Future<List<Product>> getCartItems();
  Future<void> addToCart(Product product);
  Future<void> removeFromCart(Product product);
  Future<void> removeAllFromCart(Product product); // Add this
  Future<void> clearCart();
  Future<int> getCartCount(); // ✅ ADD THIS METHOD
}

class MockCartRepository implements CartRepository {
  final List<Product> _cartItems = [];

  @override
  Future<List<Product>> getCartItems() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.from(_cartItems);
  }

  @override
  Future<void> addToCart(Product product) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _cartItems.add(product);
  }

  @override
  Future<void> removeFromCart(Product product) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _cartItems.remove(product);
  }

  @override
  Future<void> removeAllFromCart(Product product) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _cartItems.removeWhere((item) => item == product);
  }

  @override
  Future<void> clearCart() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _cartItems.clear();
  }

  @override
  Future<int> getCartCount() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _cartItems.length; // ✅ Return actual count
  }
}
