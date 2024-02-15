import 'dart:async';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_midjourney/features/repos/repository.dart';

part 'prompt_event.dart';
part 'prompt_state.dart';

class PromptBloc extends Bloc<PromptEvent, PromptState> {
  PromptBloc() : super(PromptInitial()) {
    on<PromptInitialEvent>(promptInitialEvent);
    on<PromptEnteredEvent>(promptEnteredEvent);
  }

  FutureOr<void> promptEnteredEvent(
      PromptEnteredEvent event, Emitter<PromptState> emit) async {
    try {
      emit(PromptGeneratingImageLoadState());
      List<int>? bytes = await PromptRepo.generateImage(event.prompt);
      if (bytes != null) {
        emit(
          PromptGeneratingImageSuccessState(
            uint8list: Uint8List.fromList(bytes),
          ),
        );
      } else {
        emit(
          PromptGeneratingImageErrorState(
            error: 'Error while generating image',
          ),
        );
      }
    } catch (e) {
      emit(PromptGeneratingImageErrorState(error: e.toString()));
    }
  }

  FutureOr<void> promptInitialEvent(
      PromptInitialEvent event, Emitter<PromptState> emit) async {
    // try {
    //   final ByteData byteData = await rootBundle.load('assets/file2.png');
    //   final Uint8List bytes = byteData.buffer.asUint8List();
    //   emit(PromptGeneratingImageSuccessState(uint8list: bytes));
    // } catch (e) {
    //   emit(PromptGeneratingImageErrorState(error: e.toString()));
    // }
  }

  @override
  void onChange(Change<PromptState> change) {
    log(change.toString());
    super.onChange(change);
  }
}
