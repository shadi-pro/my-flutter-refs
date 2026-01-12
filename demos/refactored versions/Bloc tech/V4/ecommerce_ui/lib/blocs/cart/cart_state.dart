part of 'cart_bloc.dart';

class CartState extends Equatable {
  final List<Product> cartItems;
  final bool isLoading;
  final String? error;
  final int itemCount;
  final double totalPrice;

  const CartState({
    this.cartItems = const [],
    this.isLoading = false,
    this.error,
    this.itemCount = 0,
    this.totalPrice = 0.0,
  });

  @override
  List<Object?> get props => [
    cartItems,
    isLoading,
    error,
    itemCount,
    totalPrice,
  ];

  CartState copyWith({
    List<Product>? cartItems,
    bool? isLoading,
    String? error,
    int? itemCount,
    double? totalPrice,
  }) {
    return CartState(
      cartItems: cartItems ?? this.cartItems,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      itemCount: itemCount ?? this.itemCount,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }
}
