import 'dart:developer';
import 'dart:io';

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:intl/intl.dart';

import '../../../../app/di/inject.dart';
import '../../../suppliers/domain/entities/supplier.dart';
import '../../../suppliers/presentation/view_model/supplier_view_model.dart';

class RecognitionService {
  final TextRecognizer _textRecognizer = TextRecognizer();
  final SupplierViewModel _supplierViewModel = getIt<SupplierViewModel>();

  RecognitionService();

  /// Processes an image to extract total, date, and supplier.
  Future<Map<String, dynamic>> processImage(File image) async {
    final inputImage = InputImage.fromFile(image);

    try {
      final RecognizedText recognizedText =
          await _textRecognizer.processImage(inputImage);

      String extractedTotal = '';
      String extractedDate = '';
      Supplier? matchedSupplier;

      // Refined regular expressions
      final totalRegex = RegExp(r'(Total|Importe|Pagado)[\s:.]*([\d.,]+)',
          caseSensitive: false);

      final dateRegex = RegExp(r'\b\d{1,2}[/-]\d{1,2}[/-]\d{4}\b');
      final numberRegex =
          RegExp(r'\b\d{1,4}[.,]\d{2}\b'); // Matches any decimal number

      log("Full recognized text:\n${recognizedText.text}");

      List<String> allNumbers = [];

      for (TextBlock block in recognizedText.blocks) {
        for (TextLine line in block.lines) {
          String text = line.text.trim();

          // 1. Detect "IMPORTE EUR" as a priority
          if (text.contains("IMPORTE EUR")) {
            final match =
                RegExp(r'IMPORTE EUR[:\s]*([\d.,]+)').firstMatch(text);
            if (match != null) {
              extractedTotal = match.group(1)?.replaceAll(',', '.') ?? '';
            }
          }

          // 2. Detect explicit total using keywords like "Total", "Importe", "Pagado"
          if (totalRegex.hasMatch(text) && extractedTotal.isEmpty) {
            final match = totalRegex.firstMatch(text);
            extractedTotal = match?.group(2)?.replaceAll(',', '.') ?? '';
          }

          // 3. Extract date using date regex patterns
          if (dateRegex.hasMatch(text) && extractedDate.isEmpty) {
            String rawDate = dateRegex.firstMatch(text)?.group(0) ?? '';
            extractedDate = _parseAndFormatDateSafely(rawDate);
          }

          // 4. Store all valid numeric values for later inference
          final numberMatches = numberRegex.allMatches(text);
          for (var match in numberMatches) {
            allNumbers.add(match.group(0)?.replaceAll(',', '.') ?? '');
          }

          // 5. Search for supplier in the recognized text
          matchedSupplier ??= _findSupplier(text);
        }
      }

      // Infer the total if no explicit value was found
      if (extractedTotal.isEmpty && allNumbers.isNotEmpty) {
        extractedTotal = _inferTotalFromNumbers(allNumbers);
        print("Inferred total: $extractedTotal");
      }

      // Return the extracted results
      return {
        "total": extractedTotal,
        "date": extractedDate,
        "supplier": matchedSupplier,
      };
    } catch (e) {
      throw Exception("Error processing text: $e");
    } finally {
      _textRecognizer.close();
    }
  }

  /// Attempts to find a supplier based on the given text.
  Supplier? _findSupplier(String text) {
    // Clean text to remove unnecessary symbols
    String cleanText = text.replaceAll(RegExp(r'[^\w\s]'), '').trim();

    Supplier? supplier;
    if (cleanText.isNotEmpty) {
      String firstWord = cleanText.split(' ').first;
      _supplierViewModel.search(firstWord, (supplier) => supplier.name);

      if (_supplierViewModel.filteredItems.isNotEmpty) {
        supplier = _supplierViewModel.filteredItems.first;
      }
    }
    // Clears
    _supplierViewModel.search('', (supplier) => supplier.name);
    return supplier;
  }

  /// Safely parses and formats a date string.
  String _parseAndFormatDateSafely(String rawDate) {
    try {
      rawDate = rawDate.trim().replaceAll(RegExp(r'[^\d/-]'), '');
      final formats = [DateFormat("dd/MM/yyyy"), DateFormat("dd-MM-yyyy")];

      for (var format in formats) {
        try {
          DateTime parsedDate = format.parseStrict(rawDate);
          return DateFormat("dd/MM/yyyy").format(parsedDate);
        } catch (_) {}
      }
      throw FormatException("Unknown date format: $rawDate");
    } catch (e) {
      print("Error formatting date: $e");
      return '';
    }
  }

  /// Infers the total amount from a list of numeric values.
  String _inferTotalFromNumbers(List<String> allNumbers) {
    if (allNumbers.isEmpty) return '';

    final validNumbers =
        allNumbers.map((n) => double.tryParse(n)).whereType<double>().toList();

    if (validNumbers.isNotEmpty) {
      return validNumbers.reduce((a, b) => a > b ? a : b).toStringAsFixed(2);
    }

    return '';
  }
}
