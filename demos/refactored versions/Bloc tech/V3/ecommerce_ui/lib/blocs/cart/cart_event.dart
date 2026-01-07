part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class LoadCart extends CartEvent {
  const LoadCart();
}

class AddToCart extends CartEvent {
  final Product product;

  const AddToCart(this.product);

  @override
  List<Object> get props => [product];
}

class RemoveFromCart extends CartEvent {
  final Product product;

  const RemoveFromCart(this.product);

  @override
  List<Object> get props => [product];
}

class RemoveAllFromCart extends CartEvent {
  final Product product;

  const RemoveAllFromCart(this.product);

  @override
  List<Object> get props => [product];
}

class ClearCart extends CartEvent {
  const ClearCart();
}
