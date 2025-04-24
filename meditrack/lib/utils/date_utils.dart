DateTime? dateTimeFromStringNullable(String? dateString) {
  if (dateString == null) {
    return null;
  }
  try {
    return DateTime.tryParse(dateString)?.toLocal();
  } catch (e) {
    return null;
  }
}

String? dateTimeToStringNullable(DateTime? dateTime) {
  return dateTime?.toUtc().toIso8601String();
}
