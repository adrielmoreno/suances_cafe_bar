import 'package:flutter/material.dart';

import '../../../../inject/inject.dart';
import '../../../common/localization/localization_manager.dart';
import '../../../common/widgets/margins/margin_container.dart';
import '../provider/to_dos_provider.dart';

class OptionsPanel extends StatefulWidget {
  const OptionsPanel({
    super.key,
  });

  @override
  State<OptionsPanel> createState() => _OptionsPanelState();
}

class _OptionsPanelState extends State<OptionsPanel> {
  final _toDosProvider = getIt<ToDosProvider>();

  @override
  Widget build(BuildContext context) {
    return MarginContainer(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: SegmentedButton<TypeToDo>(
              selected: <TypeToDo>{_toDosProvider.todoView},
              segments: [
                ButtonSegment(
                  value: TypeToDo.errand,
                  label: Text(text.todos),
                  icon: const Icon(Icons.assignment_outlined),
                ),
                ButtonSegment(
                  value: TypeToDo.order,
                  label: Text(text.orders),
                  icon: const Icon(Icons.shopping_cart_checkout_outlined),
                ),
              ],
              onSelectionChanged: (value) => setState(() {
                _toDosProvider.todoView = value.first;
              }),
            ),
          ),
        ],
      ),
    );
  }
}
