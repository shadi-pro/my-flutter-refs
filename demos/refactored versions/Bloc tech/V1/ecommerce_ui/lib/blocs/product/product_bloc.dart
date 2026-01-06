import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/product.dart';
import '../../repositories/product_repository.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository productRepository;

  ProductBloc({required this.productRepository}) : super(const ProductState()) {
    on<LoadProducts>(_onLoadProducts);
    on<SearchProducts>(_onSearchProducts);
    on<FilterProductsByCategory>(_onFilterByCategory);

    // Load products when bloc is created
    add(const LoadProducts());
  }

  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<ProductState> emit,
  ) async {
    emit(state.copyWith(status: ProductStatus.loading));

    try {
      final products = await productRepository.getProducts();
      emit(
        state.copyWith(
          allProducts: products,
          filteredProducts: products,
          status: ProductStatus.loaded,
          selectedCategory: null, // ✅ Start with "All" selected
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ProductStatus.error,
          error: 'Failed to load products: $e',
        ),
      );
    }
  }

  Future<void> _onSearchProducts(
    SearchProducts event,
    Emitter<ProductState> emit,
  ) async {
    if (event.query.isEmpty) {
      // When search is cleared, show all products
      emit(
        state.copyWith(filteredProducts: state.allProducts, searchQuery: ''),
      );
      return;
    }

    try {
      final filtered = state.allProducts.where((product) {
        return product.title.toLowerCase().contains(
              event.query.toLowerCase(),
            ) ||
            (product.description ?? '').toLowerCase().contains(
              event.query.toLowerCase(),
            );
      }).toList();

      emit(
        state.copyWith(filteredProducts: filtered, searchQuery: event.query),
      );
    } catch (e) {
      emit(state.copyWith(error: 'Search failed: $e'));
    }
  }

  Future<void> _onFilterByCategory(
    FilterProductsByCategory event,
    Emitter<ProductState> emit,
  ) async {
    print('Filtering by category: ${event.category}'); // Debug

    // ✅ When category is null (meaning "All"), show all products
    if (event.category == null) {
      emit(
        state.copyWith(
          filteredProducts: state.allProducts,
          selectedCategory: null, // ✅ Explicitly set to null for "All"
        ),
      );
      return;
    }

    try {
      final filtered = state.allProducts.where((product) {
        return product.category == event.category;
      }).toList();

      emit(
        state.copyWith(
          filteredProducts: filtered,
          selectedCategory: event.category, // ✅ Set the selected category
        ),
      );
    } catch (e) {
      emit(state.copyWith(error: 'Filter failed: $e'));
    }
  }
}
