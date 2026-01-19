import 'package:equatable/equatable.dart';
abstract class HistoryEvent extends Equatable {
  const HistoryEvent();
  @override
  List<Object?> get props => [];
}
class LoadHistoryEvent extends HistoryEvent {
  final String? filter; 
  const LoadHistoryEvent({this.filter});
  @override
  List<Object?> get props => [filter];
}
class DeleteSessionEvent extends HistoryEvent {
  final int sessionId;
  const DeleteSessionEvent(this.sessionId);
  @override
  List<Object?> get props => [sessionId];
}
class RefreshHistoryEvent extends HistoryEvent {
  const RefreshHistoryEvent();
}
