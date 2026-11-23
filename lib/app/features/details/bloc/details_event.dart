part of "details_bloc.dart";

sealed class DetailsEvent extends Equatable {
  const DetailsEvent();

  @override
  List<Object> get props => [];
}

class DetailsLoad extends DetailsEvent {
  const DetailsLoad({required this.id, this.completer});

  final int id;
  final Completer? completer;

  @override
  List<Object> get props => [id];
}
