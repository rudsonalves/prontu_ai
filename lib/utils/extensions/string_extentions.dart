import '/utils/extensions/date_time_extensions.dart';

extension StringExtensions on String {
  String onlyDigits() => replaceAll(RegExp(r'[^\d]'), '');

  bool isPtBRDate() {
    try {
      DateTimeMapper.fromDDMMYYYY(this);
    } catch (err) {
      return false;
    }
    return true;
  }
}
