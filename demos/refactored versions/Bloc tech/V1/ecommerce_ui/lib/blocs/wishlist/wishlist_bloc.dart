import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/product.dart';

part 'wishlist_event.dart';
part 'wishlist_state.dart';

class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  WishlistBloc() : super(const WishlistState()) {
    on<LoadWishlist>(_onLoadWishlist);
    on<AddToWishlist>(_onAddToWishlist);
    on<RemoveFromWishlist>(_onRemoveFromWishlist);
    on<ClearWishlist>(_onClearWishlist);
    on<ToggleWishlist>(_onToggleWishlist);
  }

  void _onLoadWishlist(LoadWishlist event, Emitter<WishlistState> emit) {
    // For now, return empty wishlist
    // Later can integrate with Firestore
    emit(const WishlistState());
  }

  void _onAddToWishlist(AddToWishlist event, Emitter<WishlistState> emit) {
    final updatedWishlist = List<Product>.from(state.wishlistItems);
    if (!updatedWishlist.contains(event.product)) {
      updatedWishlist.add(event.product);
      emit(state.copyWith(wishlistItems: updatedWishlist));
    }
  }

  void _onRemoveFromWishlist(
    RemoveFromWishlist event,
    Emitter<WishlistState> emit,
  ) {
    final updatedWishlist = List<Product>.from(state.wishlistItems);
    updatedWishlist.remove(event.product);
    emit(state.copyWith(wishlistItems: updatedWishlist));
  }

  void _onClearWishlist(ClearWishlist event, Emitter<WishlistState> emit) {
    emit(const WishlistState(wishlistItems: []));
  }

  void _onToggleWishlist(ToggleWishlist event, Emitter<WishlistState> emit) {
    final updatedWishlist = List<Product>.from(state.wishlistItems);

    if (updatedWishlist.contains(event.product)) {
      updatedWishlist.remove(event.product);
    } else {
      updatedWishlist.add(event.product);
    }

    emit(state.copyWith(wishlistItems: updatedWishlist));
  }
}
