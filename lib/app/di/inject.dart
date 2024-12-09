import 'package:get_it/get_it.dart';

import '../../core/data/db_services/firebase_db.dart';
import '../../core/data/db_services/local_db.dart';
import '../../core/data/db_services/web_db.dart';
import '../../features/balance/data/expenses/data_impl/expense_data_impl.dart';
import '../../features/balance/data/expenses/remote_impl/expense_remote_impl.dart';
import '../../features/balance/data/incomes/data_impl/income_data_impl.dart';
import '../../features/balance/data/incomes/remote_impl/income_remote_impl.dart';
import '../../features/balance/domain/repositories/expense_repository.dart';
import '../../features/balance/domain/repositories/income_repository.dart';
import '../../features/balance/presentation/forms/expense_form.dart';
import '../../features/balance/presentation/forms/income_form.dart';
import '../../features/balance/presentation/providers/transaction_provider.dart';
import '../../features/balance/presentation/viewmodels/expense_view_model.dart';
import '../../features/balance/presentation/viewmodels/income_view_model.dart';
import '../../features/products/data/data_impl/product_data_impl.dart';
import '../../features/products/data/remote_impl/product_remote_impl.dart';
import '../../features/products/domain/repositories/product_repository.dart';
import '../../features/products/presentation/forms/product_form.dart';
import '../../features/products/presentation/view_model/product_view_model.dart';
import '../../features/suppliers/data/data_impl/supplier_data_impl.dart';
import '../../features/suppliers/data/remote_impl/supplier_remote_impl.dart';
import '../../features/suppliers/domain/repositories/supplier_repository.dart';
import '../../features/suppliers/presentation/forms/supplier_form.dart';
import '../../features/suppliers/presentation/view_model/supplier_view_model.dart';
import '../../features/todos/presentation/providers/order_provider.dart';
import '../../features/todos/presentation/providers/to_dos_provider.dart';

final getIt = GetIt.instance;

class Inject {
  setup() {
    _setupDB();
    _setupSupplier();
    _setupProduct();
    _setupToDos();
    _setupTransaction();
    _setupIncome();
    _setupExpense();
  }

  _setupSupplier() {
    getIt.registerFactory<SupplierRemoteImpl>(
        () => SupplierRemoteImpl(getIt.get()));
    getIt.registerFactory<SupplierRepository>(
        () => SupplierDataImpl(getIt.get()));
    getIt.registerLazySingleton<SupplierViewModel>(
        () => SupplierViewModel(getIt.get()));
    getIt.registerLazySingleton(() => SupplierForm());
  }

  _setupIncome() {
    getIt
        .registerFactory<IncomeRemoteImpl>(() => IncomeRemoteImpl(getIt.get()));
    getIt.registerFactory<IncomeRepository>(() => IncomeDataImpl(getIt.get()));
    getIt.registerLazySingleton<IncomeViewModel>(
        () => IncomeViewModel(getIt.get()));
    getIt.registerLazySingleton(() => IncomeForm());
  }

  _setupExpense() {
    getIt.registerFactory<ExpenseRemoteImpl>(
        () => ExpenseRemoteImpl(getIt.get()));
    getIt
        .registerFactory<ExpenseRepository>(() => ExpenseDataImpl(getIt.get()));
    getIt.registerLazySingleton<ExpenseViewModel>(
        () => ExpenseViewModel(getIt.get()));
    getIt.registerLazySingleton(() => ExpenseForm());
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
  }

  void _setupProduct() {
    getIt.registerFactory<ProductRemoteImpl>(
        () => ProductRemoteImpl(getIt.get()));
    getIt
        .registerFactory<ProductRepository>(() => ProductDataImpl(getIt.get()));
    getIt
        .registerFactory<ProductViewModel>(() => ProductViewModel(getIt.get()));
    getIt.registerLazySingleton(() => ProductForm());
  }
}
