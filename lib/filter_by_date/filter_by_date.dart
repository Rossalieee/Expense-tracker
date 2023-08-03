import 'package:expense_tracker/filter_by_date/bloc/date_range_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Row filterByDate(BuildContext context) {
    final cubit = context.read<DateRangeCubit>();

    return Row(
      children: [
        IconButton(
          onPressed: () => showDateRangePicker(
      context: context,
      firstDate: DateTime(2022),
      lastDate: DateTime(2100),
      currentDate: DateTime.now(),
      saveText: 'Done',
    ).then(cubit.selectDateRange),
          icon: const Icon(Icons.calendar_month_outlined),
        ),
        if (cubit.state.selectedDateRange != null)
          Text(
            'From: ${cubit.state.selectedDateRange?.start.toString().split(' ')[0]} To: ${cubit.state.selectedDateRange?.end.toString().split(' ')[0]}',
          ),
        Visibility(
          visible: cubit.state.selectedDateRange != null,
          child: IconButton(
            onPressed: cubit.clearDateRange,
            icon: const Icon(Icons.cancel_outlined),
          ),
        ),
      ],
    );
  }
