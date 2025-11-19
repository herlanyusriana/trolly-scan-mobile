import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../scan/domain/entities/trolley.dart';
import '../../../scan/domain/repositories/trolley_repository.dart';
import 'trolley_summary_state.dart';

class TrolleySummaryCubit extends Cubit<TrolleySummaryState> {
  TrolleySummaryCubit(this._repository) : super(const TrolleySummaryState());

  final TrolleyRepository _repository;

  static const _kindLabels = <String, String>{
    'reinforce': 'Reinforce',
    'backplate': 'Backplate',
    'compbase': 'CompBase',
  };

  Future<void> loadSummary() async {
    if (state.status == TrolleySummaryStatus.loading) return;
    emit(state.copyWith(status: TrolleySummaryStatus.loading, error: null));

    final result = await _repository.fetchAvailableTrolleys();

    result.match(
      (error) => emit(
        state.copyWith(status: TrolleySummaryStatus.failure, error: error),
      ),
      (data) {
        final summaries = _buildSummaries(data);
        emit(
          state.copyWith(
            status: TrolleySummaryStatus.success,
            summaries: summaries,
            error: null,
          ),
        );
      },
    );
  }

  List<TrolleyKindSummary> _buildSummaries(List<Trolley> trolleys) {
    final result = <String, _SummaryCounter>{};

    for (final entry in _kindLabels.keys) {
      result[entry] = _SummaryCounter();
    }

    for (final trolley in trolleys) {
      final kindKey = trolley.kind?.toLowerCase() ?? '';
      if (!_kindLabels.containsKey(kindKey)) continue;
      final counter = result[kindKey]!;
      final isOut = trolley.status.toLowerCase() == 'out';
      if (isOut) {
        counter.outside++;
      } else {
        counter.inside++;
      }
    }

    return _kindLabels.entries
        .map(
          (entry) => TrolleyKindSummary(
            kindKey: entry.key,
            displayName: entry.value,
            insideCount: result[entry.key]?.inside ?? 0,
            outsideCount: result[entry.key]?.outside ?? 0,
          ),
        )
        .toList();
  }
}

class _SummaryCounter {
  int inside = 0;
  int outside = 0;
}
