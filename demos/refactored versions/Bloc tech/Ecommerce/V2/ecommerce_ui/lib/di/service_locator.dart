import 'package:get_it/get_it.dart';
import '../repositories/product_repository.dart';
import '../repositories/cart_repository.dart';
import '../repositories/auth_repository.dart';
import '../repositories/order_repository.dart';

final GetIt serviceLocator = GetIt.instance;

void setupServiceLocator() {
  // Register repositories
  serviceLocator.registerLazySingleton<ProductRepository>(
    () => MockProductRepository(),
  );

  serviceLocator.registerLazySingleton<CartRepository>(
    () => MockCartRepository(),
  );

  serviceLocator.registerLazySingleton<AuthRepository>(
    () => MockAuthRepository(),
  );

  serviceLocator.registerLazySingleton<OrderRepository>(
    () => MockOrderRepository(),
  );

  // BLOCs will be registered here later
}
