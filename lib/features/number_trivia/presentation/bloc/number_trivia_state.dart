part of 'number_trivia_bloc.dart';

abstract class NumberTriviaState extends Equatable {
  const NumberTriviaState();

  @override
  List<Object> get props => [];
}

class EmptyState extends NumberTriviaState {}

class LoadingState extends NumberTriviaState {}

class LoadedState extends NumberTriviaState {
  final NumberTrivia trivia;

  const LoadedState({
    required this.trivia,
  });

  LoadedState copyWith({
    NumberTrivia? trivia,
  }) {
    return LoadedState(
      trivia: trivia ?? this.trivia,
    );
  }

  @override
  List<Object> get props => [trivia];
}

class ErrorState extends NumberTriviaState {
  final String errorMessage;

  const ErrorState({
    required this.errorMessage,
  });

  @override
  List<Object> get props => [errorMessage];
}
