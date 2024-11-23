class FormatHelper {
  static double parseInput(String value) {
    return double.tryParse(value.replaceAll(',', '.')) ?? 0.0;
  }
}
