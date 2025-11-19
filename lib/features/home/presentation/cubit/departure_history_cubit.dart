import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/storage/session_storage.dart';
import '../../../scan/domain/entities/trolley_submission.dart';
import 'departure_history_state.dart';

class DepartureHistoryCubit extends Cubit<DepartureHistoryState> {
  DepartureHistoryCubit(this._storage) : super(const DepartureHistoryState());

  final SessionStorage _storage;

  void loadHistory() {
    final history = _storage.readSubmissionHistory();
    emit(state.copyWith(entries: history));
  }

  void addSubmission(TrolleySubmission submission) {
    final updated = [submission, ...state.entries];
    emit(state.copyWith(entries: updated));
  }
}
