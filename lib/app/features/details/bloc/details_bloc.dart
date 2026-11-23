import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../di/di.dart';
import '../../../../domain/repositories/content/content_repository_interface.dart';
import '../../../../domain/repositories/content/model/content.dart';

part 'details_event.dart';
part 'details_state.dart';

class DetailsBloc extends Bloc<DetailsEvent, DetailsState> {
  final ContentRepositoryInterface contentRepository;

  DetailsBloc(this.contentRepository) : super(DetailsInitial()) {
    on<DetailsLoad>(_detailsLoad);
  }

  Future<void> _detailsLoad(DetailsLoad event, Emitter<DetailsState> emit) async {
    try {
      emit(DetailsLoadInProgress());
      final content = await contentRepository.getContentById(event.id);
      emit(DetailsLoadSuccess(content: content));
    } catch (exception, stackTrace) {
      emit(DetailsLoadFailure(exception: exception));
      talker.handle(exception, stackTrace);
    } finally {
      event.completer?.complete();
    }
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    talker.handle(error, stackTrace);
  }
}
