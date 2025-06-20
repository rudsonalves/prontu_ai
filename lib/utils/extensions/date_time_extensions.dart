extension DateTimeExtensions on DateTime {
  String toDDMMYYYY() =>
      '${day.toString().padLeft(2, '0')}/'
      '${month.toString().padLeft(2, '0')}/'
      '$year';

  String toBrDateTime() =>
      '${toDDMMYYYY()} - '
      '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}h';
}

final class DateTimeMapper {
  DateTimeMapper._();

  static String toMap(DateTime dt) => dt.toUtc().toIso8601String();

  static DateTime fromMap(String map) => DateTime.parse(map).toLocal();

  static DateTime? fromDDMMYYYY(String source) {
    final parts = source.split('/');
    try {
      return DateTime(
        int.parse(parts[2]),
        int.parse(parts[1]),
        int.parse(parts[0]),
      );
    } catch (err) {
      return null;
    }
  }
}
