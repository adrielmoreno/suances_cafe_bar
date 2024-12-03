import 'package:flutter/material.dart';

import '../../../../app/di/inject.dart';
import '../../../../core/data/db_services/firebase_db.dart';
import '../../../../core/presentation/common/enums/payment_method.dart';
import '../../../../core/presentation/common/enums/type_of_expense.dart';
import '../../../../core/presentation/common/extensions/widget_extensions.dart';
import '../../../../core/presentation/common/localization/localization_manager.dart';
import '../../../../core/presentation/common/theme/constants/dimens.dart';
import '../../../../core/presentation/common/utils/format_helper.dart';
import '../../../../core/presentation/common/widgets/buttons/custom_appbar.dart';
import '../../../../core/presentation/common/widgets/buttons/custom_icon_button.dart';
import '../../../../core/presentation/common/widgets/images/pick_image_gallery.dart';
import '../../../../core/presentation/common/widgets/inputs/custom_decimal_input.dart';
import '../../../../core/presentation/common/widgets/inputs/custom_dropdown.dart';
import '../../../../core/presentation/common/widgets/inputs/custom_text_form_field.dart';
import '../../../../core/presentation/common/widgets/margins/margin_container.dart';
import '../../../suppliers/domain/entities/supplier.dart';
import '../../domain/entities/expense.dart';
import '../forms/expense_form.dart';

class ExpensePage extends StatefulWidget {
  const ExpensePage({super.key, this.expense});
  final Expense? expense;
  static const String route = "expense-page";

  @override
  State<ExpensePage> createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  final _expenseForm = getIt<ExpenseForm>();

  @override
  void initState() {
    super.initState();
    _expenseForm.addListener(_onUpdate);

    _expenseForm.selectedDate = widget.expense != null
        ? widget.expense!.createdAt.toDate()
        : DateTime.now();
  }

  @override
  void dispose() {
    _expenseForm.resetForm();
    _expenseForm.removeListener(_onUpdate);
    super.dispose();
  }

  void _onUpdate() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Column(
            children: [
              CustomAppBar(
                title: text.new_expense,
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: MarginContainer(
                    child: Form(
                      key: _expenseForm.formKey,
                      child: Column(
                        children: [
                          CustomDecimalInput(
                            controller: _expenseForm.totalController,
                            labelText: text.label_total,
                            hintText: "0.0",
                            onChanged: (value) {
                              _expenseForm.total =
                                  FormatHelper.parseInput(value);
                            },
                          ),
                          const SizedBox(height: Dimens.medium),
                          Row(
                            children: [
                              Flexible(
                                flex: 7,
                                child: _buildSupplierDropdown(),
                              ),
                              const SizedBox(width: Dimens.medium),
                              Flexible(
                                flex: 3,
                                child: CustomTextFormField(
                                  controller: _expenseForm.dateController,
                                  readOnly: true,
                                  onTap: () async {
                                    updateDate();
                                  },
                                  labelText: text.label_date,
                                  prefixIcon: CustomIconButton(
                                    iconData: Icons.calendar_month_outlined,
                                    onTap: () async {
                                      updateDate();
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: CustomDropDown<TypeOfExpense>(
                                  value: _expenseForm.category,
                                  enabled: _expenseForm.isEnabled,
                                  items: TypeOfExpense.values,
                                  labelText: text.category,
                                  getItemLabel: (category) => category.getName,
                                  getItemIcon: (category) =>
                                      category.getIconData,
                                  onChanged: (value) {
                                    if (value != null) {
                                      _expenseForm.category = value;
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(width: Dimens.small),
                              Expanded(
                                child: CustomDropDown<PaymentMethod>(
                                  value: _expenseForm.paymentMethod,
                                  enabled: _expenseForm.isEnabled,
                                  items: PaymentMethod.values,
                                  labelText: text.payment_method,
                                  getItemLabel: (method) => method.getName,
                                  getItemIcon: (method) => method.getIconData,
                                  onChanged: (value) {
                                    if (value != null) {
                                      _expenseForm.paymentMethod = value;
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          CustomTextFormField(
                            controller: _expenseForm.descriptionController,
                            labelText: text.description,
                            hintText: text.description,
                          ),
                          const SizedBox(height: Dimens.medium),
                          const SizedBox(height: Dimens.medium),
                          const SizedBox(height: Dimens.medium),
                          _expenseForm.imageFile == null
                              ? Text(text.no_image)
                              : Image.file(_expenseForm.imageFile!),
                          const SizedBox(height: Dimens.medium),
                          PickImageGallery(
                            onFile: (file) {
                              setState(() {
                                _expenseForm.imageFile = file;
                              });
                            },
                          ),
                          const SizedBox(height: Dimens.semiBig),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton(
                              onPressed: () async {
                                _expenseForm.saveExpense().then((value) {
                                  if (value) {
                                    context.showSnackBar(text.expense_saved);
                                  }
                                });
                              },
                              child: Text(text.save),
                            ),
                          ),
                        ],
                      ),
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

  Widget _buildSupplierDropdown() {
    return FutureBuilder(
      future: getIt<FirebaseDB>().suppliers.get(),
      builder: (context, snap) {
        final suppliers = snap.data?.docs.map((doc) => doc.data()).toList();
        return DropdownButtonFormField<Supplier>(
          isExpanded: true,
          value: _expenseForm.supplier,
          hint: Text(text.lastSupplier),
          items: suppliers?.map((supplier) {
            return DropdownMenuItem<Supplier>(
              value: supplier,
              child: Text(supplier.name),
            );
          }).toList(),
          onChanged: (value) {
            _expenseForm.supplier = value;
          },
          decoration: InputDecoration(labelText: text.supplier),
        );
      },
    );
  }

  void updateDate() async {
    final date = await context.selectedDatePicker();

    if (date != null && date != _expenseForm.selectedDate) {
      setState(() {
        _expenseForm.selectedDate = date;
      });
    }
  }
}
