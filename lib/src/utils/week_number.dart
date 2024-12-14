int translateToWeekNumber(DateTime dateToTranslate, DateTime startDay) {
  final daysDiff = ((dateToTranslate.toUtc().millisecondsSinceEpoch -
              startDay.toUtc().millisecondsSinceEpoch) /
          (1000 * 60 * 60 * 24))
      .floor();
  return 1 + (daysDiff / 7).floor();
}
