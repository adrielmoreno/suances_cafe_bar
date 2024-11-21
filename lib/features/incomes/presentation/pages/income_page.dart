import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../../../app/di/inject.dart';
import '../../../../presentation/common/extensions/widget_extensions.dart';
import '../../../../presentation/common/theme/constants/dimens.dart';
import '../../../../presentation/common/utils/format_helper.dart';
import '../../../../presentation/common/utils/local_dates.dart';
import '../../../../presentation/common/widgets/buttons/custom_appbar.dart';
import '../../../../presentation/common/widgets/buttons/custom_icon_button.dart';
import '../../../../presentation/common/widgets/images/pick_image_gallery.dart';
import '../../../../presentation/common/widgets/inputs/custom_decimal_input.dart';
import '../../../../presentation/common/widgets/inputs/custom_text_form_field.dart';
import '../../../../presentation/common/widgets/margins/margin_container.dart';
import '../../domain/entities/income.dart';
import '../viewmodels/income_view_model.dart';

class IncomePage extends StatefulWidget {
  const IncomePage({super.key, this.income});
  final Income? income;
  static const String route = "income_page";

  @override
  State<IncomePage> createState() => _IncomePageState();
}

class _IncomePageState extends State<IncomePage> {
  final _incomeViewModel = getIt<IncomeViewModel>();

  @override
  void initState() {
    super.initState();
    _incomeViewModel.addListener(_onUpdate);

    // init Date
    _incomeViewModel.selectedDate = widget.income != null
        ? widget.income!.createdAt.toDate()
        : DateTime.now();
  }

  @override
  void dispose() {
    _incomeViewModel.resetForm();
    _incomeViewModel.removeListener(_onUpdate);
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
                      key: _incomeViewModel.formKey,
                      child: Column(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                child: CustomDecimalInput(
                                  controller: _incomeViewModel.cashController,
                                  labelText: '€ Efectivo',
                                  hintText: "0.0",
                                  onChanged: (value) {
                                    _incomeViewModel.cash =
                                        FormatHelper.parseInput(value);

                                    _incomeViewModel.setTotal();
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: Dimens.medium,
                              ),
                              Expanded(
                                child: CustomDecimalInput(
                                  controller: _incomeViewModel.cardController,
                                  labelText: '€ Tarjeta',
                                  hintText: "0.0",
                                  onChanged: (value) {
                                    _incomeViewModel.card =
                                        FormatHelper.parseInput(value);

                                    _incomeViewModel.setTotal();
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
                                  controller: _incomeViewModel.totalController,
                                ),
                              ),
                              const SizedBox(
                                width: Dimens.medium,
                              ),
                              Expanded(
                                child: CustomTextFormField(
                                  controller: _incomeViewModel.dateController,
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
                                      _incomeViewModel.selectedDate),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: Dimens.medium,
                          ),
                          _incomeViewModel.imageFile == null
                              ? const Text('No se ha seleccionado una imagen.')
                              : Image.file(_incomeViewModel.imageFile!),
                          const SizedBox(
                            height: Dimens.medium,
                          ),
                          PickImageGallery(
                            onFile: (file) {
                              setState(() {
                                _incomeViewModel.imageFile = file;
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

    if (date != null && date != _incomeViewModel.selectedDate) {
      setState(() {
        _incomeViewModel.selectedDate = date;
      });
    }
  }

  void _submitForm() {
    if (_incomeViewModel.formKey.currentState!.validate()) {
      // correct time
      final selectedDate = _incomeViewModel.selectedDate;
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
        cash: _incomeViewModel.cash ?? 0.0,
        card: _incomeViewModel.card ?? 0.0,
        total: (_incomeViewModel.cash ?? 0.0) + (_incomeViewModel.card ?? 0.0),
        urlImgTicket: _incomeViewModel.imageFile?.path ?? "",
        id: const Uuid().v4(),
      );

      _incomeViewModel
          .saveOne(newIncome, _incomeViewModel.imageFile)
          .then((value) {
        context.showSnackBar("Ingreso guardado correctamente");
        _incomeViewModel.resetForm();
      });
    }
  }
}
