import 'package:flutter/material.dart';

import '../../../../app/di/inject.dart';
import '../../../../core/presentation/common/localization/localization_manager.dart';
import '../../domain/entities/expense.dart';
import '../viewmodels/expense_view_model.dart';

class ExpensesDatasource extends DataTableSource {
  final BuildContext context;
  final ExpenseViewModel _expenseViewModel = getIt<ExpenseViewModel>();

  ExpensesDatasource({
    required this.context,
  });

  void _showImage(Expense expense) {
    if (expense.urlImgTicket != null) {
      showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Image.network(
              expense.urlImgTicket!,
              fit: BoxFit.cover,
            ),
          );
        },
      );
    }
  }

  void _deleteExpense(Expense expense) {
    //
  }

  void _editExpense(Expense expense) {
    // Lógica de navegación para editar
  }

  void _navigateToSupplier(String supplierId) {
    // Lógica de navegación a la pantalla de proveedor
  }

  void sort(Comparable Function(Expense expense) getField, bool ascending) {
    _expenseViewModel.allItems.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return ascending ? aValue.compareTo(bValue) : bValue.compareTo(aValue);
    });
    notifyListeners();
  }

  @override
  DataRow getRow(int index) {
    final expenses = List<Expense>.from(_expenseViewModel.allItems);

    if (index >= expenses.length) return const DataRow(cells: []);

    final expense = expenses[index];

    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text(text.date_format(expense.createdAt.toDate()))),
        DataCell(Text(expense.total.toStringAsFixed(2))),
        DataCell(Text(expense.category.getName)),
        DataCell(Text(expense.paymentMethod.getName)),
        DataCell(
          InkWell(
            onTap: () {
              if (expense.urlImgTicket != null &&
                  expense.urlImgTicket!.isNotEmpty) {
                _showImage(expense);
              }
            },
            child:
                expense.urlImgTicket != null && expense.urlImgTicket!.isNotEmpty
                    ? const Icon(Icons.image, color: Colors.blue)
                    : const Icon(Icons.image_not_supported, color: Colors.grey),
          ),
        ),
        DataCell(
          expense.supplier != null
              ? InkWell(
                  onTap: () => _navigateToSupplier(expense.supplier!.id),
                  child: Row(
                    children: [
                      const Icon(Icons.handshake_outlined, color: Colors.green),
                      const SizedBox(width: 5),
                      Text(expense.supplier!.id),
                    ],
                  ),
                )
              : const Icon(Icons.remove_circle_outline, color: Colors.grey),
        ),
        DataCell(
          Row(
            children: [
              IconButton(
                onPressed: () => _editExpense(expense),
                icon: const Icon(Icons.edit_outlined),
              ),
              IconButton(
                onPressed: () => _deleteExpense(expense),
                icon: const Icon(Icons.delete_outline, color: Colors.red),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _expenseViewModel.allItems.length;

  @override
  int get selectedRowCount => 0;
}
