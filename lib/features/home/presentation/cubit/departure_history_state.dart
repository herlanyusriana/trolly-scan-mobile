import 'package:equatable/equatable.dart';

import '../../../scan/domain/entities/trolley_submission.dart';

class DepartureHistoryState extends Equatable {
  const DepartureHistoryState({
    this.entries = const <TrolleySubmission>[],
    this.loading = false,
    this.error,
  });

  final List<TrolleySubmission> entries;
  final bool loading;
  final String? error;

  DepartureHistoryState copyWith({
    List<TrolleySubmission>? entries,
    bool? loading,
    String? error,
  }) {
    return DepartureHistoryState(
      entries: entries ?? this.entries,
      loading: loading ?? this.loading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [entries, loading, error];
}
