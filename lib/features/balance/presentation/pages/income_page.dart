import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../../../app/di/inject.dart';
import '../../../../core/presentation/common/extensions/widget_extensions.dart';
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
import '../viewmodels/income_view_model.dart';

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
              const CustomAppBar(
                title: 'Nuevo Ingreso',
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
                                  labelText: '€ Efectivo',
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
                                  labelText: '€ Tarjeta',
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
                                  labelText: '€ Total',
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
                                  labelText: 'Fecha',
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
                              ? const Text('No se ha seleccionado una imagen.')
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
                              onPressed: _submitForm,
                              child: const Text('Guardar'),
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

  void _submitForm() {
    if (_incomeForm.formKey.currentState!.validate()) {
      // correct time
      final selectedDate = _incomeForm.selectedDate;
      final dateWithCorrectTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        DateTime.now().hour,
        DateTime.now().minute,
        DateTime.now().second,
      );

      final newIncome = Income(
        createdAt: Timestamp.fromDate(dateWithCorrectTime),
        cash: _incomeForm.cash ?? 0.0,
        card: _incomeForm.card ?? 0.0,
        total: (_incomeForm.cash ?? 0.0) + (_incomeForm.card ?? 0.0),
        urlImgTicket: _incomeForm.imageFile?.path ?? "",
        id: const Uuid().v4(),
      );

      getIt<IncomeViewModel>()
          .saveOne(newIncome, _incomeForm.imageFile)
          .then((value) {
        context.showSnackBar("Ingreso guardado correctamente");
        _incomeForm.resetForm();
      });
    }
  }
}
