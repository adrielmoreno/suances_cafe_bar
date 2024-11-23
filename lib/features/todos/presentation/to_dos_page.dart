import 'package:flutter/material.dart';

import '../../../app/di/inject.dart';
import '../../../core/presentation/common/localization/localization_manager.dart';
import '../../../core/presentation/common/theme/constants/dimens.dart';
import '../../../core/presentation/common/widgets/buttons/custom_appbar.dart';
import 'pages/order_list_page.dart';
import 'pages/task_list_page.dart';
import 'providers/order_provider.dart';
import 'providers/to_dos_provider.dart';
import 'widgets/options_panel.dart';
import 'widgets/task_form.dart';

class ToDosPage extends StatefulWidget {
  const ToDosPage({
    super.key,
  });

  static const route = '/todos-page';

  @override
  State<ToDosPage> createState() => _ToDosPageState();
}

class _ToDosPageState extends State<ToDosPage> {
  final _toDosProvider = getIt<ToDosProvider>();
  final _orderProvider = getIt<OrderProvider>();

  @override
  void initState() {
    super.initState();
    _toDosProvider.addListener(_updateState);

    _orderProvider.addListener(_updateState);
  }

  @override
  void dispose() {
    _toDosProvider.removeListener(_updateState);
    _orderProvider.removeListener(_updateState);
    super.dispose();
  }

  _updateState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: Center(
          child: Column(
            children: [
              CustomAppBar(
                title: text.newTask,
                actions: [
                  (_orderProvider.selectedProducts.isNotEmpty &&
                          _toDosProvider.todoView != TypeToDo.errand)
                      ? Container(
                          margin: const EdgeInsets.only(right: Dimens.medium),
                          decoration: BoxDecoration(
                            color: themeColor.primary,
                            borderRadius: BorderRadius.circular(Dimens.semiBig),
                          ),
                          child: IconButton(
                            color: themeColor.onSecondary,
                            onPressed: () async {
                              await _orderProvider.shareFile();
                            },
                            icon: Badge(
                              label: Text(
                                  '${_orderProvider.selectedProducts.length}'),
                              child: const Icon(
                                  Icons.shopping_cart_checkout_outlined),
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ],
              ),
              // ---- Switchs
              const OptionsPanel(),
              // ---- Task Form
              Visibility(
                  visible: _toDosProvider.todoView == TypeToDo.errand,
                  child: const TaskForm()),
              // ---- Task List
              Visibility(
                visible: _toDosProvider.todoView == TypeToDo.errand,
                child: Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: Dimens.medium,
                    ),
                    child: const TaskListPage(),
                  ),
                ),
              ),
              // ---- Task List
              Visibility(
                visible: _toDosProvider.todoView != TypeToDo.errand,
                child: Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: Dimens.medium,
                    ),
                    child: const OrderListPage(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
