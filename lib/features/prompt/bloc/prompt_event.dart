part of 'prompt_bloc.dart';

sealed class PromptEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class PromptInitialEvent extends PromptEvent {}

class PromptEnteredEvent extends PromptEvent {
  final String prompt;

  PromptEnteredEvent({required this.prompt});
  @override
  List<Object> get props => [prompt];
}
