part of 'product_bloc.dart';

class ProductState extends Equatable {
  final List<Product> allProducts;
  final List<Product> filteredProducts;
  final ProductStatus status;
  final String? error;
  final String? selectedCategory; // ✅ Can be null for "All"
  final String searchQuery;

  const ProductState({
    this.allProducts = const [],
    this.filteredProducts = const [],
    this.status = ProductStatus.initial,
    this.error,
    this.selectedCategory, // ✅ null by default
    this.searchQuery = '',
  });

  @override
  List<Object?> get props => [
    allProducts,
    filteredProducts,
    status,
    error,
    selectedCategory, // ✅ Include null in props
    searchQuery,
  ];

  ProductState copyWith({
    List<Product>? allProducts,
    List<Product>? filteredProducts,
    ProductStatus? status,
    String? error,
    String? selectedCategory, // ✅ Allow null
    String? searchQuery,
  }) {
    return ProductState(
      allProducts: allProducts ?? this.allProducts,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      status: status ?? this.status,
      error: error ?? this.error,
      selectedCategory: selectedCategory, // ✅ Direct assignment (can be null)
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

enum ProductStatus { initial, loading, loaded, error }
