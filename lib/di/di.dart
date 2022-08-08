import 'package:ecommerce/data/remote/authentication/google_auth_service.dart';
import 'package:ecommerce/data/remote/chat/chat_service.dart';
import 'package:ecommerce/data/remote/products/add_product.dart';
import 'package:ecommerce/data/remote/products/categories_services.dart';
import 'package:get_it/get_it.dart';
import '../data/remote/authentication/phone_auth_service.dart';
import '../data/remote/products/products.dart';

final GetIt getIt = GetIt.instance;

Future<void> injector() async {
  ///Authentication
  getIt.registerLazySingleton<PhoneAuthService>(() => PhoneAuthServiceImpl());
  getIt
      .registerLazySingleton<GoogleAuthServices>(() => GoogleAuthServiceImpl());

  ///Product
  getIt.registerLazySingleton<CategoriesService>(() => CategoriesServiceImpl());
  getIt.registerLazySingleton<ProductService>(() => ProductServiceImpl());
  getIt.registerLazySingleton<AddProductService>(() => AddProductServiceImpl());

  ///Chat
  getIt.registerLazySingleton<ChatServices>(() => ChatServicesImpl());
}
