import 'package:flutter/material.dart';

import '../../../../app/di/inject.dart';
import '../../../../core/data/db_services/web_db.dart';
import '../../../../core/presentation/common/utils/local_dates.dart';
import '../providers/to_dos_provider.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({
    super.key,
  });

  @override
  State<TaskListPage> createState() => _TaskListsState();
}

class _TaskListsState extends State<TaskListPage> {
  final _toDosProvider = getIt<ToDosProvider>();
  final _db = getIt<WebDB>();

  @override
  void initState() {
    super.initState();
    _toDosProvider.loadDB();
    _toDosProvider.addListener(_updateState);
  }

  @override
  void dispose() {
    _db.close();
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
