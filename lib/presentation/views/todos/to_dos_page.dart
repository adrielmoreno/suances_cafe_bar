import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../inject/inject.dart';
import '../../common/localization/app_localizations.dart';
import '../../common/theme/constants/dimens.dart';
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
    final text = AppLocalizations.of(context)!;

    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Column(
            children: [
              // ---- Switch
              const OptionsPanel(),
              // ---- Task Form
              Visibility(
                  visible: _toDosProvider.todoView == TypeToDo.errand,
                  child: const SizedBox(
                      width: Dimens.maxwidth, child: TaskForm())),
              // ---- Task List
              Visibility(
                visible: _toDosProvider.todoView == TypeToDo.errand,
                child: Expanded(
                  child: SizedBox(
                    width: Dimens.maxwidth,
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: Dimens.big,
                      ),
                      child: const TaskList(),
                    ),
                  ),
                ),
              ),
              // ---- Task List
              Visibility(
                visible: _toDosProvider.todoView != TypeToDo.errand,
                child: Expanded(
                  child: SizedBox(
                    width: Dimens.maxwidth,
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: Dimens.big,
                      ),
                      child: const OrderPanel(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: (_orderProvider.selectedProducts.isNotEmpty &&
              _toDosProvider.todoView != TypeToDo.errand)
          ? FloatingActionButton(
              mini: true,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Dimens.big)),
              onPressed: () async {
                await _orderProvider.shareFile();
              },
              tooltip: text.save,
              child: const Icon(!kIsWeb
                  ? Icons.send_outlined
                  : Icons.send_and_archive_outlined),
            )
          : const SizedBox.shrink(),
    );
  }
}
