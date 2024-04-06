import 'package:get_it/get_it.dart';

import '../data/product/data_impl/product_data_impl.dart';
import '../data/product/remote_impl/product_remote_impl.dart';
import '../data/supplier/data_impl/supplier_data_impl.dart';
import '../data/supplier/remote_impl/supplier_remote_impl.dart';
import '../domain/repositories/supplier_repository.dart';
import '../presentation/views/products/provider/producto_provider.dart';
import '../presentation/views/suppliers/provider/supplier_provider.dart';
import '../presentation/views/suppliers/view_model/supplier_view_model.dart';

final getIt = GetIt.instance;

class Inject {
  setup() {
    _setupSupplier();
    _setupProduct();
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
    getIt.registerFactory<ProductDataImpl>(() => ProductDataImpl(getIt.get()));
    getIt.registerSingleton(ProductProvider());
  }
}
