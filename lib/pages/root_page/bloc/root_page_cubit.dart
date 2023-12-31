import 'package:flutter_bloc/flutter_bloc.dart';

class RootPageState {
  RootPageState(this.currentPage);

  final int currentPage;

  @override
  String toString() => 'RootPageState(currentPage: $currentPage)';
}

class RootPageCubit extends Cubit<RootPageState> {
  RootPageCubit() : super(RootPageState(0));

  void setPage(int index) => emit(RootPageState(index));
}
