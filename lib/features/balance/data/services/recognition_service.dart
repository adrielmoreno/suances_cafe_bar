import 'dart:io';

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:intl/intl.dart';

class RecognitionService {
  final TextRecognizer _textRecognizer = TextRecognizer();

  /// Processes an image to extract the total amount and date from text.
  Future<Map<String, String>> processImage(File image) async {
    final inputImage = InputImage.fromFile(image);

    try {
      final RecognizedText recognizedText =
          await _textRecognizer.processImage(inputImage);

      String extractedTotal = '';
      String extractedDate = '';

      // Refined regular expressions
      final totalRegex = RegExp(r'(Total|Importe|Pagado)[:\s]*([\d.,]+)',
          caseSensitive: false);
      final dateRegex = RegExp(r'\b\d{1,2}[/-]\d{1,2}[/-]\d{4}\b');
      final numberRegex =
          RegExp(r'\b\d{1,4}[.,]\d{2}\b'); // Matches any decimal number

      print("Full recognized text:\n${recognizedText.text}");

      List<String> allNumbers = []; // List to store all detected numbers
      String? previousLineText; // To keep track of the previous line's text

      for (TextBlock block in recognizedText.blocks) {
        for (TextLine line in block.lines) {
          String text = line.text.trim();

          // Extract date
          if (dateRegex.hasMatch(text) && extractedDate.isEmpty) {
            String rawDate = dateRegex.firstMatch(text)?.group(0) ?? '';
            extractedDate = _parseAndFormatDateSafely(rawDate);
            print("Date found: $extractedDate");
          }

          // Extract explicit total on the same line
          if (totalRegex.hasMatch(text)) {
            final match = totalRegex.firstMatch(text);
            extractedTotal = match?.group(2)?.replaceAll(',', '.') ?? '';
            print("Total found with keyword: $extractedTotal");
          }

          // Handle case where "TOTAL" is on one line and the amount is on the next line
          if (previousLineText != null &&
              previousLineText.toLowerCase().contains('total') &&
              numberRegex.hasMatch(text)) {
            extractedTotal = numberRegex.firstMatch(text)?.group(0) ?? '';
            extractedTotal = extractedTotal.replaceAll(',', '.');
            print("Total found on the next line: $extractedTotal");
          }

          // Save current line as previous for the next iteration
          previousLineText = text;

          // Extract all valid numbers from the current line
          final numberMatches = numberRegex.allMatches(text);
          for (var match in numberMatches) {
            allNumbers.add(match.group(0)?.replaceAll(',', '.') ?? '');
          }
        }
      }

      // If no explicit total is found, infer the total from detected numbers
      if (extractedTotal.isEmpty && allNumbers.isNotEmpty) {
        extractedTotal = _inferTotalFromNumbers(allNumbers);
        print("Inferred total: $extractedTotal");
      }

      return {
        "total": extractedTotal,
        "date": extractedDate,
      };
    } catch (e) {
      throw Exception("Error processing text: $e");
    } finally {
      _textRecognizer.close();
    }
  }

  /// Attempts to safely parse and format a date.
  ///
  /// Cleans the input date string and tries to parse it using known formats.
  /// Returns the date in "dd/MM/yyyy" format if successful, or an empty string if it fails.
  String _parseAndFormatDateSafely(String rawDate) {
    try {
      // Clean unwanted characters and spaces
      rawDate = rawDate.trim().replaceAll(RegExp(r'[^\d/-]'), '');
      final formats = [DateFormat("dd/MM/yyyy"), DateFormat("dd-MM-yyyy")];

      // Try parsing the date with known formats
      for (var format in formats) {
        try {
          DateTime parsedDate = format.parseStrict(rawDate);
          return DateFormat("dd/MM/yyyy")
              .format(parsedDate); // Return formatted date
        } catch (_) {}
      }
      throw FormatException("Unknown date format: $rawDate");
    } catch (e) {
      print("Error formatting date: $e");
      return '';
    }
  }

  /// Infers the total amount from a list of numeric values.
  ///
  /// Parses the list of numbers, finds the largest value, and returns it as the total.
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
