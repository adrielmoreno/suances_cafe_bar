import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../inject/inject.dart';
import '../../common/localization/localization_manager.dart';
import '../../common/theme/constants/dimens.dart';
import '../../common/widgets/buttons/custom_appbar.dart';
import '../../common/widgets/buttons/custom_icon_button.dart';
import 'provider/order_provider.dart';
import 'provider/to_dos_provider.dart';
import 'widgets/options_panel.dart';
import 'widgets/order_panel.dart';
import 'widgets/task_form.dart';
import 'widgets/task_list.dart';

class ToDosPage extends StatefulWidget {
  const ToDosPage({
    super.key,
  });

  static const route = '/todos_page';

  @override
  State<ToDosPage> createState() => _ToDosPageState();
}

class _ToDosPageState extends State<ToDosPage> {
  final _toDosProvider = getIt<ToDosProvider>();
  final _orderProvider = getIt<OrderProvider>();

  @override
  void initState() {
    super.initState();
    _toDosProvider.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    _orderProvider.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).colorScheme;

    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
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
                              borderRadius:
                                  BorderRadius.circular(Dimens.semiBig),
                            ),
                            child: CustomIconButton(
                              color: themeColor.onSecondary,
                              onTap: () async {
                                await _orderProvider.shareFile();
                              },
                              iconData: !kIsWeb
                                  ? Icons.send_outlined
                                  : Icons.send_and_archive_outlined,
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
                      child: const TaskList(),
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
                      child: const OrderPanel(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
