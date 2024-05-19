import 'package:get_it/get_it.dart';

import '../data/db_services/firebase_db.dart';
import '../data/db_services/local_db.dart';
import '../data/db_services/web_db.dart';
import '../data/product/data_impl/product_data_impl.dart';
import '../data/product/remote_impl/product_remote_impl.dart';
import '../data/supplier/data_impl/supplier_data_impl.dart';
import '../data/supplier/remote_impl/supplier_remote_impl.dart';
import '../domain/repositories/product_repository.dart';
import '../domain/repositories/supplier_repository.dart';
import '../presentation/views/products/provider/producto_provider.dart';
import '../presentation/views/products/view_model/product_view_model.dart';
import '../presentation/views/suppliers/provider/supplier_provider.dart';
import '../presentation/views/suppliers/view_model/supplier_view_model.dart';
import '../presentation/views/todos/provider/order_provider.dart';
import '../presentation/views/todos/provider/to_dos_provider.dart';

final getIt = GetIt.instance;

class Inject {
  setup() {
    _setupDB();
    _setupSupplier();
    _setupProduct();
    _setupToDos();
  }

  _setupSupplier() {
    getIt.registerFactory<SupplierRemoteImpl>(() => SupplierRemoteImpl());
    getIt.registerFactory<SupplierRepository>(
        () => SupplierDataImpl(getIt.get()));
    getIt.registerFactory<SupplierViewModel>(
        () => SupplierViewModel(getIt.get()));
    getIt.registerSingleton(SupplierProvider());
  }

  _setupProduct() {
    getIt.registerFactory<ProductRemoteImpl>(() => ProductRemoteImpl());
    getIt
        .registerFactory<ProductRepository>(() => ProductDataImpl(getIt.get()));
    getIt
        .registerFactory<ProductViewModel>(() => ProductViewModel(getIt.get()));
    getIt.registerSingleton(ProductProvider());
  }

  _setupToDos() {
    getIt.registerSingleton(ToDosProvider());
    getIt.registerSingleton(OrderProvider());
  }

  _setupDB() {
    getIt.registerSingleton(FirebaseDB());
    getIt.registerSingleton(LocalDB());
    getIt.registerSingleton(WebDB());
  }
}
