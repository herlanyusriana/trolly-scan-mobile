import 'package:equatable/equatable.dart';

import '../../../scan/domain/entities/trolley_submission.dart';

class DepartureHistoryState extends Equatable {
  const DepartureHistoryState({this.entries = const <TrolleySubmission>[]});

  final List<TrolleySubmission> entries;

  DepartureHistoryState copyWith({List<TrolleySubmission>? entries}) {
    return DepartureHistoryState(entries: entries ?? this.entries);
  }

  @override
  List<Object?> get props => [entries];
}
