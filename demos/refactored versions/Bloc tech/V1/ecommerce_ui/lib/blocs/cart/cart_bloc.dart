import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/product.dart';
import '../../repositories/cart_repository.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository cartRepository;

  CartBloc({required this.cartRepository}) : super(const CartState()) {
    on<LoadCart>(_onLoadCart);
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<RemoveAllFromCart>(_onRemoveAllFromCart);
    on<ClearCart>(_onClearCart);
  }

  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final cartItems = await cartRepository.getCartItems();
      final itemCount = await cartRepository.getCartCount();
      final totalPrice = _calculateTotal(cartItems);

      emit(
        state.copyWith(
          isLoading: false,
          cartItems: cartItems,
          itemCount: itemCount,
          totalPrice: totalPrice,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: 'Failed to load cart: $e'));
    }
  }

  Future<void> _onAddToCart(AddToCart event, Emitter<CartState> emit) async {
    try {
      await cartRepository.addToCart(event.product);

      final cartItems = await cartRepository.getCartItems();
      final itemCount = await cartRepository.getCartCount();
      final totalPrice = _calculateTotal(cartItems);

      emit(
        state.copyWith(
          cartItems: cartItems,
          itemCount: itemCount,
          totalPrice: totalPrice,
        ),
      );
    } catch (e) {
      emit(state.copyWith(error: 'Failed to add to cart: $e'));
    }
  }

  Future<void> _onRemoveFromCart(
    RemoveFromCart event,
    Emitter<CartState> emit,
  ) async {
    try {
      await cartRepository.removeFromCart(event.product);

      final cartItems = await cartRepository.getCartItems();
      final itemCount = await cartRepository.getCartCount();
      final totalPrice = _calculateTotal(cartItems);

      emit(
        state.copyWith(
          cartItems: cartItems,
          itemCount: itemCount,
          totalPrice: totalPrice,
        ),
      );
    } catch (e) {
      emit(state.copyWith(error: 'Failed to remove from cart: $e'));
    }
  }

  Future<void> _onRemoveAllFromCart(
    RemoveAllFromCart event,
    Emitter<CartState> emit,
  ) async {
    try {
      await cartRepository.removeAllFromCart(event.product);

      final cartItems = await cartRepository.getCartItems();
      final itemCount = await cartRepository.getCartCount();
      final totalPrice = _calculateTotal(cartItems);

      emit(
        state.copyWith(
          cartItems: cartItems,
          itemCount: itemCount,
          totalPrice: totalPrice,
        ),
      );
    } catch (e) {
      emit(state.copyWith(error: 'Failed to remove items: $e'));
    }
  }

  Future<void> _onClearCart(ClearCart event, Emitter<CartState> emit) async {
    try {
      await cartRepository.clearCart();

      emit(const CartState(cartItems: [], itemCount: 0, totalPrice: 0.0));
    } catch (e) {
      emit(state.copyWith(error: 'Failed to clear cart: $e'));
    }
  }

  double _calculateTotal(List<Product> cartItems) {
    return cartItems.fold(0.0, (sum, product) => sum + product.price);
  }
}
