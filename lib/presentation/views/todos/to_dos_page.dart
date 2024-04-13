import 'package:flutter/material.dart';

import '../../../inject/inject.dart';
import '../../common/localization/app_localizations.dart';
import '../../common/theme/constants/dimens.dart';
import '../../common/widgets/buttons/custom_appbar.dart';
import 'provider/to_dos_provider.dart';
import 'widgets/options_panel.dart';
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

  @override
  void initState() {
    super.initState();
    _toDosProvider.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    // TODO:
    final theme = Theme.of(context).textTheme;
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Column(
            children: [
              CustomAppBar(
                title: text.todos,
              ),
              // ---- Switch
              const OptionsPanel(),
              // ---- Form
              Visibility(
                  visible: _toDosProvider.todoView == TypeToDo.tasks,
                  child: const TaskForm()),
              // ---- Task List
              Visibility(
                visible: _toDosProvider.todoView == TypeToDo.tasks,
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
            ],
          ),
        ),
      ),
    );
  }
}
