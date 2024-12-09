import 'dart:io';

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:intl/intl.dart';

class RecognitionService {
  final TextRecognizer _textRecognizer = TextRecognizer();

  Future<Map<String, String>> processImage(File image) async {
    final inputImage = InputImage.fromFile(image);

    try {
      final RecognizedText recognizedText =
          await _textRecognizer.processImage(inputImage);

      String extractedTotal = '';
      String extractedDate = '';

      final totalRegex = RegExp(r'(Total|Importe\s*Total|TOTAL):?\s*([0-9.,]+)',
          caseSensitive: false);
      final dateRegex =
          RegExp(r'\b\d{1,2}[/-]\d{1,2}[/-]\d{4}(\s\d{2}:\d{2})?\b');
      for (TextBlock block in recognizedText.blocks) {
        for (TextLine line in block.lines) {
          final text = line.text.trim();

          if (totalRegex.hasMatch(text)) {
            final match = totalRegex.firstMatch(text);
            extractedTotal = match?.group(2)?.replaceAll(',', '.') ?? '';
          }

          if (dateRegex.hasMatch(text)) {
            String rawDate = dateRegex.firstMatch(text)?.group(0) ?? '';
            extractedDate = _parseAndFormatDateSafely(rawDate);
          }
        }
      }

      return {
        "total": extractedTotal,
        "date": extractedDate,
      };
    } catch (e) {
      throw Exception("Error al reconocer el texto: $e");
    } finally {
      _textRecognizer.close();
    }
  }

  String _parseAndFormatDateSafely(String rawDate) {
    try {
      rawDate = rawDate.trim().replaceAll(RegExp(r'[^\d/-]'), '');

      if (rawDate.isEmpty) {
        throw const FormatException("La fecha está vacía después de limpiar.");
      }

      rawDate = _extractDatePart(rawDate);

      final List<DateFormat> formats = [
        DateFormat("dd/MM/yyyy"),
        DateFormat("dd-MM-yyyy"),
      ];

      for (var format in formats) {
        try {
          DateTime parsedDate = format.parseStrict(rawDate);
          return DateFormat("dd/MM/yyyy").format(parsedDate);
        } catch (_) {
          continue;
        }
      }

      throw FormatException("Formato de fecha desconocido: $rawDate");
    } catch (e) {
      print("Error al formatear la fecha: $e");
      return '';
    }
  }

  String _extractDatePart(String rawDate) {
    final match = RegExp(r'\d{2}[/-]\d{2}[/-]\d{4}').firstMatch(rawDate);
    return match?.group(0) ?? '';
  }
}
