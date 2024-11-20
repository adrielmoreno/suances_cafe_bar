import 'package:get_it/get_it.dart';

import '../../core/data/db_services/firebase_db.dart';
import '../../core/data/db_services/local_db.dart';
import '../../core/data/db_services/web_db.dart';
import '../../data/supplier/data_impl/supplier_data_impl.dart';
import '../../data/supplier/remote_impl/supplier_remote_impl.dart';
import '../../domain/repositories/supplier_repository.dart';
import '../../features/balance/provider/transaction_provider.dart';
import '../../features/expense/presentation/viewmodels/expense_provider.dart';
import '../../features/incomes/data/data_impl/income_data_impl.dart';
import '../../features/incomes/data/remote_impl/income_remote_impl.dart';
import '../../features/incomes/domain/repositories/income_repository.dart';
import '../../features/incomes/presentation/viewmodels/income_view_model.dart';
import '../../features/products/data/data_impl/product_data_impl.dart';
import '../../features/products/data/remote_impl/product_remote_impl.dart';
import '../../features/products/domain/repositories/product_repository.dart';
import '../../features/products/presentation/view_model/product_view_model.dart';
import '../../presentation/views/suppliers/provider/supplier_provider.dart';
import '../../presentation/views/suppliers/view_model/supplier_view_model.dart';
import '../../presentation/views/todos/provider/order_provider.dart';
import '../../presentation/views/todos/provider/to_dos_provider.dart';

final getIt = GetIt.instance;

class Inject {
  setup() {
    _setupDB();
    _setupSupplier();
    _setupProduct();
    _setupToDos();
    _setupTransaction();
    _setupIncome();
  }

  _setupSupplier() {
    getIt.registerFactory<SupplierRemoteImpl>(
        () => SupplierRemoteImpl(getIt.get()));
    getIt.registerFactory<SupplierRepository>(
        () => SupplierDataImpl(getIt.get()));
    getIt.registerFactory<SupplierViewModel>(
        () => SupplierViewModel(getIt.get()));
    getIt.registerSingleton(SupplierProvider());
  }

  _setupProduct() {
    getIt.registerFactory<ProductRemoteImpl>(
        () => ProductRemoteImpl(getIt.get()));
    getIt
        .registerFactory<ProductRepository>(() => ProductDataImpl(getIt.get()));
    getIt
        .registerFactory<ProductViewModel>(() => ProductViewModel(getIt.get()));
  }

  _setupIncome() {
    getIt
        .registerFactory<IncomeRemoteImpl>(() => IncomeRemoteImpl(getIt.get()));
    getIt.registerFactory<IncomeRepository>(() => IncomeDataImpl(getIt.get()));
    getIt.registerFactory<IncomeViewModel>(() => IncomeViewModel(getIt.get()));
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

  _setupTransaction() {
    getIt.registerLazySingleton(() => TransactionProvider());
    getIt.registerSingleton(ExpenseProvider());
  }
}
