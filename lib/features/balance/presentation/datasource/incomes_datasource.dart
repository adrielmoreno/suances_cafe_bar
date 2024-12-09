import 'package:flutter/material.dart';

import '../../../../app/di/inject.dart';
import '../../../../core/presentation/common/localization/localization_manager.dart';
import '../../domain/entities/income.dart';
import '../viewmodels/income_view_model.dart';

class IncomesDatasource extends DataTableSource {
  final BuildContext context;
  final IncomeViewModel _incomeViewModel = getIt<IncomeViewModel>();

  IncomesDatasource({required this.context});

  void _showImage(Income income) {
    if (income.urlImgTicket != null && income.urlImgTicket!.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Image.network(
              income.urlImgTicket!,
              fit: BoxFit.cover,
            ),
          );
        },
      );
    }
  }

  void _deleteIncome(Income income) {
    // Lógica para eliminar ingresos
  }

  void _editIncome(Income income) {
    // Lógica de navegación para editar ingresos
  }

  void sort(Comparable Function(Income income) getField, bool ascending) {
    _incomeViewModel.allItems.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return ascending ? aValue.compareTo(bValue) : bValue.compareTo(aValue);
    });
    notifyListeners();
  }

  @override
  DataRow getRow(int index) {
    final incomes = List<Income>.from(_incomeViewModel.allItems);

    if (index >= incomes.length) return const DataRow(cells: []);

    final income = incomes[index];

    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text(text.date_format(income.createdAt.toDate()))),
        DataCell(Text(income.total.toStringAsFixed(2))),
        DataCell(Text(income.card.toStringAsFixed(2))),
        DataCell(Text(income.cash.toStringAsFixed(2))),
        DataCell(
          InkWell(
            onTap: () {
              if (income.urlImgTicket != null &&
                  income.urlImgTicket!.isNotEmpty) {
                _showImage(income);
              }
            },
            child:
                income.urlImgTicket != null && income.urlImgTicket!.isNotEmpty
                    ? const Icon(Icons.image, color: Colors.blue)
                    : const Icon(Icons.image_not_supported, color: Colors.grey),
          ),
        ),
        DataCell(
          Row(
            children: [
              IconButton(
                onPressed: () => _editIncome(income),
                icon: const Icon(Icons.edit_outlined),
              ),
              IconButton(
                onPressed: () => _deleteIncome(income),
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
  int get rowCount => _incomeViewModel.allItems.length;

  @override
  int get selectedRowCount => 0;
}
