import 'package:ecommerce_ui/models/product.dart';
import 'package:ecommerce_ui/data/products.dart' as demo_data;

abstract class ProductRepository {
  Future<List<Product>> getProducts();
  Future<List<Product>> searchProducts(String query);
  Future<List<Product>> getProductsByCategory(String category);
}

class MockProductRepository implements ProductRepository {
  @override
  Future<List<Product>> getProducts() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return demo_data.demoProducts;
  }

  @override
  Future<List<Product>> searchProducts(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (query.isEmpty) return demo_data.demoProducts;

    return demo_data.demoProducts
        .where(
          (product) =>
              product.title.toLowerCase().contains(query.toLowerCase()) ||
              (product.description?.toLowerCase().contains(
                    query.toLowerCase(),
                  ) ??
                  false),
        )
        .toList();
  }

  @override
  Future<List<Product>> getProductsByCategory(String category) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (category.isEmpty) return demo_data.demoProducts;

    return demo_data.demoProducts
        .where((product) => product.category == category)
        .toList();
  }
}
