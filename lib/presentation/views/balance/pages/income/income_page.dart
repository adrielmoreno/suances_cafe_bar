import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../../domain/entities/income.dart';
import '../../../../../external/inject/inject.dart';
import '../../../../common/extensions/widget_extensions.dart';
import '../../../../common/interfaces/resource_state.dart';
import '../../../../common/localization/localization_manager.dart';
import '../../../../common/theme/constants/dimens.dart';
import '../../../../common/utils/local_dates.dart';
import '../../../../common/widgets/buttons/custom_appbar.dart';
import '../../../../common/widgets/buttons/custom_icon_button.dart';
import '../../../../common/widgets/margins/margin_container.dart';
import '../../provider/income_provider.dart';
import '../../view_model/income_view_model.dart';
import '../../widgets/pick_image_gallery.dart';

class IncomePage extends StatefulWidget {
  const IncomePage({super.key, this.income});
  final Income? income;
  static const String route = "income_page";

  @override
  State<IncomePage> createState() => _IncomePageState();
}

class _IncomePageState extends State<IncomePage> {
  final _incomeProvider = getIt<IncomeProvider>();
  final _incomeViewModel = getIt<IncomeViewModel>();

  @override
  void initState() {
    super.initState();
    _incomeProvider.addListener(_onUpdate);

    _incomeViewModel.saveOneState.stream.listen((event) {
      switch (event.state) {
        case Status.LOADING:
          break;
        case Status.COMPLETED:
          context.showSnackBar("Ingreso guardado correctamente");
          _incomeProvider.resetForm();
          break;
        default:
      }
    });

    // init Date
    _incomeProvider.selectedDate = DateTime.now();
  }

  @override
  void dispose() {
    _incomeProvider.resetForm();
    _incomeViewModel.close();
    _incomeProvider.removeListener(_onUpdate);
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
                      key: _incomeProvider.formKey,
                      child: Column(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                    labelText: '€ Efectivo',
                                    hintText: "0.0",
                                  ),
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return text.errorEmpty;
                                    }
                                    if (double.tryParse(value) == null) {
                                      return 'Por favor, introduce un número válido';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    _incomeProvider.cash =
                                        double.tryParse(value) ?? 0.0;

                                    _incomeProvider.setTotal();
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: Dimens.medium,
                              ),
                              Expanded(
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                    labelText: '€ Tarjeta',
                                    hintText: "0.0",
                                  ),
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return text.errorEmpty;
                                    }
                                    if (double.tryParse(value) == null) {
                                      return 'Por favor, introduce un número válido';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    _incomeProvider.card =
                                        double.tryParse(value) ?? 0.0;

                                    _incomeProvider.setTotal();
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
                                child: TextFormField(
                                  readOnly: true,
                                  decoration: const InputDecoration(
                                    labelText: '€ Total',
                                  ),
                                  controller: _incomeProvider.totalController,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: Dimens.medium,
                              ),
                              Expanded(
                                child: TextFormField(
                                  controller: _incomeProvider.dateController,
                                  readOnly: true,
                                  onTap: () async {
                                    updateDate();
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Fecha',
                                    prefixIcon: CustomIconButton(
                                      iconData: Icons.calendar_month_outlined,
                                      onTap: () async {
                                        updateDate();
                                      },
                                    ),
                                    hintText: LocalDates.dateFormated(
                                        _incomeProvider.selectedDate),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return text.errorEmpty;
                                    }

                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: Dimens.medium,
                          ),
                          _incomeProvider.imageFile == null
                              ? const Text('No se ha seleccionado una imagen.')
                              : Image.file(_incomeProvider.imageFile!),
                          const SizedBox(
                            height: Dimens.medium,
                          ),
                          PickImageGallery(
                            onFile: (file) {
                              setState(() {
                                _incomeProvider.imageFile = file;
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
    if (date != null && date != _incomeProvider.selectedDate) {
      setState(() {
        _incomeProvider.selectedDate = date;
      });
    }
  }

  void _submitForm() {
    if (_incomeProvider.formKey.currentState!.validate()) {
      // correct time
      final selectedDate = _incomeProvider.selectedDate;
      final dateWithCorrectTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        DateTime.now().hour,
        DateTime.now().minute,
        DateTime.now().second,
      );

      final newIncome = Income(
        date: Timestamp.fromDate(dateWithCorrectTime),
        cash: _incomeProvider.cash ?? 0.0,
        card: _incomeProvider.card ?? 0.0,
        total: (_incomeProvider.cash ?? 0.0) + (_incomeProvider.card ?? 0.0),
        urlImgTicket: _incomeProvider.imageFile?.path ?? "",
      );

      _incomeViewModel.saveOne(newIncome, _incomeProvider.imageFile);
    }
  }
}
