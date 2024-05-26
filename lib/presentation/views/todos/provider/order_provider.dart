import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import "package:universal_html/html.dart" as html;

import '../../../../domain/entities/orden.dart';
import '../../../../domain/entities/supplier.dart';
import '../../../common/theme/constants/dimens.dart';

class OrderProvider extends ChangeNotifier {
  Supplier? _selectedSupplier;
  final List<Order> _selectedProducts = [];
  late XFile _file;

  Supplier? get selectedSupplier => _selectedSupplier;
  List<Order> get selectedProducts => _selectedProducts;

  set selectedSupplier(Supplier? supplier) {
    _selectedSupplier = supplier;
    _selectedProducts.clear();
    notifyListeners();
  }

  void addSelectedProduct(Order order) {
    final existingOrderIndex = _selectedProducts
        .indexWhere((element) => element.product.id == order.product.id);

    if (existingOrderIndex != -1) {
      _selectedProducts[existingOrderIndex].quantity = order.quantity;
    } else {
      _selectedProducts.add(order);
    }

    notifyListeners();
  }

  void removeSelectedProduct(Order order) {
    _selectedProducts
        .removeWhere((element) => element.product.id == order.product.id);
    notifyListeners();
  }

  void clearSelectedProducts() {
    _selectedProducts.clear();
    notifyListeners();
  }

  // PDF
  Future<void> shareFile() async {
    await _createPDF();
    if (!kIsWeb) {
      final shareResult =
          await Share.shareXFiles([_file], text: DateTime.now().toString());

      if (shareResult.status == ShareResultStatus.success) {
        clearSelectedProducts();
      } else {
        log('Fallo al compartir');
      }
    }
  }

  Future<void> _createPDF() async {
    final pdf = pw.Document();

    // image logo
    final Uint8List imageData =
        (await rootBundle.load('assets/images/suances.png'))
            .buffer
            .asUint8List();
    final logo = pw.MemoryImage(imageData);

    pdf.addPage(
      pw.Page(
        build: (pw.Context ctx) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              // Header
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Image(logo, width: 100),
                  pw.Text('Orden de compra',
                      style: pw.TextStyle(
                          fontSize: Dimens.semiBig,
                          fontWeight: pw.FontWeight.bold)),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text('Bar Suances'),
                      pw.Text('+34 675 123 359'),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 20),
              // Supplier
              if (_selectedSupplier != null)
                pw.Row(children: [pw.Text('${_selectedSupplier?.name}')]),

              pw.SizedBox(height: 20),
              // Table products
              pw.TableHelper.fromTextArray(
                headers: ['Producto', 'Unidad', 'Cantidad'],
                headerStyle: const pw.TextStyle(
                    color: PdfColors.white,
                    background: pw.BoxDecoration(color: PdfColors.blue400)),
                cellAlignments: {
                  1: pw.Alignment.topRight,
                  2: pw.Alignment.topRight,
                },
                data: selectedProducts
                    .map((order) => [
                          order.product.name,
                          order.product.measure,
                          order.quantity
                        ])
                    .toList(),
              ),
              pw.SizedBox(height: 20),

              pw.Text('¡Por favor comunicar cualquier variación de precios!'),
              pw.Spacer(),
              // Footer
              pw.Divider(),
              pw.Text('Calle doctor moreno, 28, 47008, Valladolid'),
            ],
          );
        },
      ),
    );

    final String dir =
        !kIsWeb ? (await getApplicationDocumentsDirectory()).path : 'downloads';
    final String path = '$dir/purchase_order.pdf';

    if (kIsWeb) {
      final blob = html.Blob([await pdf.save()], 'application/pdf');
      final url = html.Url.createObjectUrlFromBlob(blob);
      html.AnchorElement(href: url)
        ..setAttribute("download", "purchase_order.pdf")
        ..click();
      html.Url.revokeObjectUrl(url);
    } else {
      final File file = File(path);
      await file.writeAsBytes(await pdf.save());
      _file = XFile(file.path);
    }
  }
}
