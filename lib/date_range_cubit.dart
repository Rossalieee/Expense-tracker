import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DateRangeState {
  DateRangeState({this.selectedDateRange});

  final DateTimeRange? selectedDateRange;
}

class DateRangeCubit extends Cubit<DateRangeState> {
  DateRangeCubit() : super(DateRangeState());

  void selectDateRange(DateTimeRange? value) {
    if (value != null) {
      emit(DateRangeState(selectedDateRange: value));
    }
  }

  void clearDateRange() {
    emit(DateRangeState());
  }
}
