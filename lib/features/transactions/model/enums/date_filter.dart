enum DateFilter {
  today,
  week,
  month,
  all;

  bool get isToday => this == DateFilter.today;
  bool get isWeek => this == DateFilter.week;
  bool get isMonth => this == DateFilter.month;
  bool get isAll => this == DateFilter.all;
}
