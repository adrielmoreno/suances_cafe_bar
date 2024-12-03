import 'package:flutter/material.dart';

import '../../../../app/di/inject.dart';
import '../../../../core/presentation/common/extensions/widget_extensions.dart';
import '../../../../core/presentation/common/localization/localization_manager.dart';
import '../../../../core/presentation/common/theme/constants/dimens.dart';
import '../../../../core/presentation/common/utils/format_helper.dart';
import '../../../../core/presentation/common/utils/local_dates.dart';
import '../../../../core/presentation/common/widgets/buttons/custom_appbar.dart';
import '../../../../core/presentation/common/widgets/buttons/custom_icon_button.dart';
import '../../../../core/presentation/common/widgets/images/pick_image_gallery.dart';
import '../../../../core/presentation/common/widgets/inputs/custom_decimal_input.dart';
import '../../../../core/presentation/common/widgets/inputs/custom_text_form_field.dart';
import '../../../../core/presentation/common/widgets/margins/margin_container.dart';
import '../../domain/entities/income.dart';
import '../forms/income_form.dart';

class IncomePage extends StatefulWidget {
  const IncomePage({super.key, this.income});
  final Income? income;
  static const String route = "income-page";

  @override
  State<IncomePage> createState() => _IncomePageState();
}

class _IncomePageState extends State<IncomePage> {
  final _incomeForm = getIt<IncomeForm>();

  @override
  void initState() {
    super.initState();
    _incomeForm.addListener(_onUpdate);

    // init Date
    _incomeForm.selectedDate = widget.income != null
        ? widget.income!.createdAt.toDate()
        : DateTime.now();
  }

  @override
  void dispose() {
    _incomeForm.resetForm();
    _incomeForm.removeListener(_onUpdate);
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
                title: text.new_income,
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: MarginContainer(
                    child: Form(
                      key: _incomeForm.formKey,
                      child: Column(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                child: CustomDecimalInput(
                                  controller: _incomeForm.cashController,
                                  labelText: text.label_cash,
                                  hintText: "0.0",
                                  onChanged: (value) {
                                    _incomeForm.cash =
                                        FormatHelper.parseInput(value);

                                    _incomeForm.setTotal();
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: Dimens.medium,
                              ),
                              Expanded(
                                child: CustomDecimalInput(
                                  controller: _incomeForm.cardController,
                                  labelText: text.label_card,
                                  hintText: "0.0",
                                  onChanged: (value) {
                                    _incomeForm.card =
                                        FormatHelper.parseInput(value);

                                    _incomeForm.setTotal();
                                  },
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                child: CustomDecimalInput(
                                  labelText: text.label_total,
                                  readOnly: true,
                                  controller: _incomeForm.totalController,
                                ),
                              ),
                              const SizedBox(
                                width: Dimens.medium,
                              ),
                              Expanded(
                                child: CustomTextFormField(
                                  controller: _incomeForm.dateController,
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
                                  hintText: LocalDates.dateFormated(
                                      _incomeForm.selectedDate),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: Dimens.medium,
                          ),
                          _incomeForm.imageFile == null
                              ? Text(text.no_image)
                              : Image.file(_incomeForm.imageFile!),
                          const SizedBox(
                            height: Dimens.medium,
                          ),
                          PickImageGallery(
                            onFile: (file) {
                              setState(() {
                                _incomeForm.imageFile = file;
                              });
                            },
                          ),
                          const SizedBox(height: Dimens.semiBig),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton(
                              onPressed: () async {
                                _incomeForm.saveIncome().then((value) {
                                  if (value) {
                                    context.showSnackBar(text.income_saved);
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

  void updateDate() async {
    final date = await context.selectedDatePicker();

    if (date != null && date != _incomeForm.selectedDate) {
      setState(() {
        _incomeForm.selectedDate = date;
      });
    }
  }
}
