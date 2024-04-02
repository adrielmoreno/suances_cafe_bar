import 'package:get_it/get_it.dart';

import '../data/product/data_impl/product_data_impl.dart';
import '../data/product/remote_impl/product_remote_impl.dart';
import '../data/supplier/data_impl/supplier_data_impl.dart';
import '../data/supplier/remote_impl/supplier_remote_impl.dart';
import '../presentation/providers/product/producto_provider.dart';
import '../presentation/providers/supplier/supplier_provider.dart';

final getIt = GetIt.instance;

class Inject {
  setup() {
    _setupSupplier();
    _setupProduct();
  }

  _setupSupplier() {
    getIt.registerFactory<SupplierRemoteImpl>(() => SupplierRemoteImpl());
    getIt
        .registerFactory<SupplierDataImpl>(() => SupplierDataImpl(getIt.get()));
    getIt.registerSingleton(SupplierProvider());
  }

  _setupProduct() {
    getIt.registerFactory<ProductRemoteImpl>(() => ProductRemoteImpl());
    getIt.registerFactory<ProductDataImpl>(() => ProductDataImpl(getIt.get()));
    getIt.registerSingleton(ProductProvider());
  }
}
