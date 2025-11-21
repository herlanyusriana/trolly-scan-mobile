import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../scan/domain/entities/trolley_submission.dart';
import '../../../scan/domain/repositories/trolley_repository.dart';
import 'departure_history_state.dart';

class DepartureHistoryCubit extends Cubit<DepartureHistoryState> {
  DepartureHistoryCubit(this._repository) : super(const DepartureHistoryState());

  final TrolleyRepository _repository;

  Future<void> loadHistory() async {
    emit(state.copyWith(loading: true, error: null));
    final result = await _repository.fetchSubmissionHistory(limit: 50);
    result.match(
      (err) {
        emit(state.copyWith(loading: false, error: err));
      },
      (remote) async {
        emit(state.copyWith(entries: remote, loading: false, error: null));
      },
    );
  }

  void addSubmission(TrolleySubmission submission) {
    final updated = [submission, ...state.entries];
    emit(state.copyWith(entries: updated));
  }
}
