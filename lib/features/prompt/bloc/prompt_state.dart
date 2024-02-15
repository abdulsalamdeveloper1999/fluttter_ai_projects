part of 'prompt_bloc.dart';

sealed class PromptState {}

final class PromptInitial extends PromptState {}

final class PromptGeneratingImageLoadState extends PromptState {}

final class PromptGeneratingImageSuccessState extends PromptState {
  final Uint8List uint8list;

  PromptGeneratingImageSuccessState({required this.uint8list});
}

final class PromptGeneratingImageErrorState extends PromptState {
  final String error;

  PromptGeneratingImageErrorState({required this.error});
}
