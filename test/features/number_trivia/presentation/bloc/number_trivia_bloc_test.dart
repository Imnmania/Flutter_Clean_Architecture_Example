import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/core/error/failures.dart';
import 'package:number_trivia/core/use_cases/use_case.dart';
import 'package:number_trivia/core/util/input_converter.dart';
import 'package:number_trivia/features/number_trivia/domain/entitites/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/use_cases/get_concrete_number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/use_cases/get_random_number_trivia.dart';
import 'package:number_trivia/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  late NumberTriviaBloc bloc;
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    bloc = NumberTriviaBloc(
      getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
      getRandomNumberTrivia: mockGetRandomNumberTrivia,
      inputConverter: mockInputConverter,
    );
  });

  tearDown(
    () => bloc.close(),
  );

  test('initial state should be empty', () {
    // assert
    expect(
      bloc.state,
      const EmptyState(),
    );
  });

  group(
    'GetTriviaForConcreteNumber',
    () {
      const tNumberString = '1';
      const tNumberParsed = 1;
      const tNumberTrivia = NumberTrivia(
        text: 'test trivia',
        number: 1,
      );

      test(
        'should call the InputConverter to validate and convert the string to an unsigned integer',
        () async {
          // arrange
          when(() => mockInputConverter.stringToUnsignedInteger(any()))
              .thenAnswer((_) => const Right(tNumberParsed));
          when(() => mockGetConcreteNumberTrivia.call(
                  params: const Params(number: tNumberParsed)))
              .thenAnswer((_) => Future.value(const Right(tNumberTrivia)));

          // act
          bloc.add(const GetTriviaForConcreteNumberEvent(tNumberString));
          await untilCalled(
              () => mockInputConverter.stringToUnsignedInteger(tNumberString));

          // assert
          verify(
              () => mockInputConverter.stringToUnsignedInteger(tNumberString));
        },
      );

      test(
        'should emit [Error] when the input is invalid',
        () async {
          // arrange
          when(() => mockInputConverter.stringToUnsignedInteger(any()))
              .thenAnswer((_) => Left(InvalidInputFailure()));

          // act
          bloc.add(const GetTriviaForConcreteNumberEvent(tNumberString));
          await untilCalled(
              () => mockInputConverter.stringToUnsignedInteger(any()));

          // assert
          /* 
          final expected = [
            EmptyState(),
            const ErrorState(errorMessage: INVALID_FAILURE_MESSAGE),
          ];
          expectLater(
            bloc.stream,
            emitsInOrder(expected),
          ); */
          expect(bloc.state,
              const ErrorState(errorMessage: INVALID_FAILURE_MESSAGE));
        },
      );

      test(
        'should get data from the concrete use case',
        () async {
          // arrange
          when(() => mockInputConverter.stringToUnsignedInteger(any()))
              .thenAnswer((_) => const Right(tNumberParsed));
          when(() => mockGetConcreteNumberTrivia.call(
                  params: const Params(number: tNumberParsed)))
              .thenAnswer((_) => Future.value(const Right(tNumberTrivia)));

          // act
          bloc.add(const GetTriviaForConcreteNumberEvent(tNumberString));
          await untilCalled(() => mockGetConcreteNumberTrivia.call(
              params: const Params(number: tNumberParsed)));

          // assert
          verify(() => mockGetConcreteNumberTrivia.call(
              params: const Params(number: tNumberParsed))).called(1);
        },
      );

      test(
        'should emit [LoadingState, LoadedState] when data is gotten successfully',
        () async {
          // arrange
          when(() => mockInputConverter.stringToUnsignedInteger(any()))
              .thenAnswer((_) => const Right(tNumberParsed));
          when(() => mockGetConcreteNumberTrivia.call(
                  params: const Params(number: tNumberParsed)))
              .thenAnswer((_) => Future.value(const Right(tNumberTrivia)));

          // act
          bloc.add(const GetTriviaForConcreteNumberEvent(tNumberString));

          // assert later
          const expectedStates = [
            LoadingState(),
            LoadedState(trivia: tNumberTrivia),
          ];
          expectLater(bloc.stream, emitsInOrder(expectedStates));
        },
      );

      // blocTest<NumberTriviaBloc, NumberTriviaState>(
      //   'should emit [LoadingState, LoadedState] when data is gotten successfully',
      //   setUp: () {
      //     when(() => mockInputConverter.stringToUnsignedInteger(any()))
      //         .thenAnswer((_) => const Right(tNumberParsed));
      //     when(() => mockGetConcreteNumberTrivia.call(
      //             params: const Params(number: tNumberParsed)))
      //         .thenAnswer((_) => Future.value(const Right(tNumberTrivia)));
      //   },
      //   build: () => NumberTriviaBloc(
      //     getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
      //     getRandomNumberTrivia: mockGetRandomNumberTrivia,
      //     inputConverter: mockInputConverter,
      //   ),
      //   act: (bloc) =>
      //       bloc.add(const GetTriviaForConcreteNumberEvent(tNumberString)),
      //   expect: () => const <NumberTriviaState>[
      //     LoadingState(),
      //     LoadedState(trivia: tNumberTrivia),
      //   ],
      // );

      test(
        'should emit [LoadingState, ErrorState] when data fails',
        () async {
          // arrange
          when(() => mockInputConverter.stringToUnsignedInteger(any()))
              .thenAnswer((_) => const Right(tNumberParsed));
          when(() => mockGetConcreteNumberTrivia.call(
                  params: const Params(number: tNumberParsed)))
              .thenAnswer((_) => Future.value(Left(ServerFailure())));

          // act
          bloc.add(const GetTriviaForConcreteNumberEvent(tNumberString));

          // assert later
          const expectedStates = [
            LoadingState(),
            ErrorState(errorMessage: SERVER_FAILURE_MESSAGE),
          ];
          expectLater(bloc.stream, emitsInOrder(expectedStates));
        },
      );

      test(
        'should emit [LoadingState, ErrorState] when data fails with proper message',
        () async {
          // arrange
          when(() => mockInputConverter.stringToUnsignedInteger(any()))
              .thenAnswer((_) => const Right(tNumberParsed));
          when(() => mockGetConcreteNumberTrivia.call(
                  params: const Params(number: tNumberParsed)))
              .thenAnswer((_) => Future.value(Left(CacheFailure())));

          // act
          bloc.add(const GetTriviaForConcreteNumberEvent(tNumberString));

          // assert later
          const expectedStates = [
            LoadingState(),
            ErrorState(errorMessage: CACHE_FAILURE_MESSAGE),
          ];
          expectLater(bloc.stream, emitsInOrder(expectedStates));
        },
      );
    },
  );

  group(
    'GetTriviaForRandomNumber',
    () {
      const tNumberTrivia = NumberTrivia(
        text: 'test trivia',
        number: 1,
      );

      test(
        'should get data from the random use case',
        () async {
          // arrange
          when(() => mockGetRandomNumberTrivia.call(params: const NoParams()))
              .thenAnswer((_) => Future.value(const Right(tNumberTrivia)));

          // act
          bloc.add(GetTriviaForRandomNumberEvent());
          await untilCalled(
              () => mockGetRandomNumberTrivia.call(params: const NoParams()));

          // assert
          verify(() => mockGetRandomNumberTrivia.call(params: const NoParams()))
              .called(1);
        },
      );

      test(
        'should emit [LoadingState, LoadedState] when data is gotten successfully',
        () async {
          // arrange
          when(() => mockGetRandomNumberTrivia.call(params: const NoParams()))
              .thenAnswer((_) => Future.value(const Right(tNumberTrivia)));

          // act
          bloc.add(GetTriviaForRandomNumberEvent());

          // assert later
          const expectedStates = [
            LoadingState(),
            LoadedState(trivia: tNumberTrivia),
          ];
          expectLater(bloc.stream, emitsInOrder(expectedStates));
        },
      );

      test(
        'should emit [LoadingState, ErrorState] when data fails',
        () async {
          // arrange
          when(() => mockGetRandomNumberTrivia.call(params: const NoParams()))
              .thenAnswer((_) => Future.value(Left(ServerFailure())));

          // act
          bloc.add(GetTriviaForRandomNumberEvent());

          // assert later
          const expectedStates = [
            LoadingState(),
            ErrorState(errorMessage: SERVER_FAILURE_MESSAGE),
          ];
          expectLater(bloc.stream, emitsInOrder(expectedStates));
        },
      );

      test(
        'should emit [LoadingState, ErrorState] when data fails with proper message',
        () async {
          // arrange
          when(() => mockGetRandomNumberTrivia.call(params: const NoParams()))
              .thenAnswer((_) => Future.value(Left(CacheFailure())));

          // act
          bloc.add(GetTriviaForRandomNumberEvent());

          // assert later
          const expectedStates = [
            LoadingState(),
            ErrorState(errorMessage: CACHE_FAILURE_MESSAGE),
          ];
          expectLater(bloc.stream, emitsInOrder(expectedStates));
        },
      );
    },
  );
}
