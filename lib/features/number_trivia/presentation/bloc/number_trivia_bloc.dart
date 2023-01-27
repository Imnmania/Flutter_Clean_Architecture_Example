// ignore_for_file: constant_identifier_names

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_trivia/core/error/failures.dart';
import 'package:number_trivia/core/use_cases/use_case.dart';
import 'package:number_trivia/core/util/input_converter.dart';
import 'package:number_trivia/features/number_trivia/domain/entitites/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/use_cases/get_concrete_number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/use_cases/get_random_number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_FAILURE_MESSAGE =
    'Invalid Input Failure - Number must be positive or zero';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    required this.getConcreteNumberTrivia,
    required this.getRandomNumberTrivia,
    required this.inputConverter,
  }) : super(const EmptyState()) {
    on<GetTriviaForConcreteNumberEvent>(
      (event, emit) {
        emit(const LoadingState());
        final inputEither =
            inputConverter.stringToUnsignedInteger(event.numberString);

        inputEither.fold(
          (failure) {
            emit(const ErrorState(errorMessage: INVALID_FAILURE_MESSAGE));
          },
          (integer) async {
            final value =
                await getConcreteNumberTrivia(params: Params(number: integer));
            value.fold(
              (failure) => emit(ErrorState(
                errorMessage: _failureMessage(failure),
              )),
              (trivia) => emit(LoadedState(trivia: trivia)),
            );
          },
        );
      },
    );
    on<GetTriviaForRandomNumberEvent>(
      (event, emit) async {
        emit(const LoadingState());
        final value = await getRandomNumberTrivia(params: const NoParams());
        value.fold(
          (failure) => emit(ErrorState(
            errorMessage: _failureMessage(failure),
          )),
          (trivia) => emit(LoadedState(trivia: trivia)),
        );
      },
    );
  }

  String _failureMessage(Failures failures) {
    switch (failures.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected Failure';
    }
  }
}
