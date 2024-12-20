import 'package:flutter/material.dart';

import '../../../../../app/di/inject.dart';
import '../../../../../core/presentation/common/extensions/widget_extensions.dart';
import '../../../../../core/presentation/common/localization/localization_manager.dart';
import '../../../../../core/presentation/common/theme/constants/dimens.dart';
import '../../../../../core/presentation/common/utils/local_dates.dart';
import '../../../../../core/presentation/common/widgets/buttons/custom_icon_button.dart';
import '../../../../../core/presentation/common/widgets/margins/margin_container.dart';
import '../providers/to_dos_provider.dart';

class TaskForm extends StatefulWidget {
  const TaskForm({
    super.key,
  });

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final _toDosProvider = getIt<ToDosProvider>();

  @override
  void initState() {
    super.initState();

    _toDosProvider.addListener(_updateState);
  }

  @override
  void dispose() {
    _toDosProvider.removeListener(_updateState);
    super.dispose();
  }

  _updateState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  void updateDate() async {
    final date = await context.selectedDatePicker();
    if (date != null && date != _toDosProvider.selectedDate) {
      setState(() {
        _toDosProvider.selectedDate = date;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MarginContainer(
      child: Form(
        key: _toDosProvider.formKey,
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: TextFormField(
                controller: _toDosProvider.dateController,
                readOnly: true,
                onTap: () async => updateDate(),
                decoration: InputDecoration(
                  prefixIcon: CustomIconButton(
                    iconData: Icons.calendar_month_outlined,
                    onTap: () async => updateDate(),
                  ),
                  hintText:
                      LocalDates.dateFormated(_toDosProvider.selectedDate),
                ),
              ),
            ),
            const SizedBox(
              width: Dimens.small,
            ),
            Expanded(
              flex: 4,
              child: TextFormField(
                controller: _toDosProvider.taskController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return text.errorName;
                  }
                  return null;
                },
                onFieldSubmitted: (texto) {
                  setState(() {
                    _toDosProvider.setTask();
                    _toDosProvider.taskController.clear();
                  });
                },
                decoration: InputDecoration(hintText: text.newTask),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
