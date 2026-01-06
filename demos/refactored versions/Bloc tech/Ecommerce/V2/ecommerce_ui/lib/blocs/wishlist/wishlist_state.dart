part of 'wishlist_bloc.dart';

class WishlistState extends Equatable {
  final List<Product> wishlistItems;
  final bool isLoading;
  final String? error;

  const WishlistState({
    this.wishlistItems = const [],
    this.isLoading = false,
    this.error,
  });

  @override
  List<Object?> get props => [wishlistItems, isLoading, error];

  WishlistState copyWith({
    List<Product>? wishlistItems,
    bool? isLoading,
    String? error,
  }) {
    return WishlistState(
      wishlistItems: wishlistItems ?? this.wishlistItems,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
