import 'package:ecommerce_ui/models/product.dart';

abstract class CartRepository {
  Future<List<Product>> getCartItems();
  Future<void> addToCart(Product product);
  Future<void> removeFromCart(Product product);
  Future<void> clearCart();
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
  Future<void> clearCart() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _cartItems.clear();
  }
}
