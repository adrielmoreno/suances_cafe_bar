import 'package:flutter/material.dart';

import '../../../../inject/inject.dart';
import '../../../common/utils/local_dates.dart';
import '../provider/to_dos_provider.dart';

class TaskList extends StatefulWidget {
  const TaskList({
    super.key,
  });

  @override
  State<TaskList> createState() => _TaskListsState();
}

class _TaskListsState extends State<TaskList> {
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final color = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: _toDosProvider.tasks.length,
            itemBuilder: (context, index) {
              final task = _toDosProvider.tasks[index];
              return Dismissible(
                key: Key(task.date.toString()),
                direction: DismissDirection.horizontal,
                onDismissed: (direction) {
                  _toDosProvider.removeTask(task);
                },
                background: Container(
                  color: color.error,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Icon(
                    Icons.delete,
                    color: color.onSecondary,
                  ),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Checkbox(
                    value: task.isCompleted,
                    onChanged: (value) {
                      setState(() {
                        _toDosProvider.toggleTask(task);
                      });
                    },
                  ),
                  title: Text(
                    task.name,
                    style: theme.titleMedium?.apply(
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none),
                  ),
                  trailing: Text(LocalDates.dateFormated(task.date)),
                  onTap: () {
                    setState(() {
                      _toDosProvider.toggleTask(task);
                    });
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
