import 'package:equatable/equatable.dart';

class TrolleyKindSummary extends Equatable {
  const TrolleyKindSummary({
    required this.kindKey,
    required this.displayName,
    required this.insideCount,
    required this.outsideCount,
  });

  final String kindKey;
  final String displayName;
  final int insideCount;
  final int outsideCount;

  int get total => insideCount + outsideCount;

  @override
  List<Object?> get props => [kindKey, displayName, insideCount, outsideCount];
}

enum TrolleySummaryStatus { initial, loading, success, failure }

class TrolleySummaryState extends Equatable {
  const TrolleySummaryState({
    this.status = TrolleySummaryStatus.initial,
    this.summaries = const <TrolleyKindSummary>[],
    this.error,
  });

  final TrolleySummaryStatus status;
  final List<TrolleyKindSummary> summaries;
  final String? error;

  TrolleySummaryState copyWith({
    TrolleySummaryStatus? status,
    List<TrolleyKindSummary>? summaries,
    String? error,
  }) {
    return TrolleySummaryState(
      status: status ?? this.status,
      summaries: summaries ?? this.summaries,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, summaries, error];
}
