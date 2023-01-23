import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:number_trivia/core/use_cases/use_case.dart';
import 'package:number_trivia/features/number_trivia/domain/entitites/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/features/number_trivia/domain/use_cases/get_random_number_trivia.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  late GetRandomNumberTrivia useCase;
  late MockNumberTriviaRepository mockNumberTriviaRepository;

  setUp(
    () {
      mockNumberTriviaRepository = MockNumberTriviaRepository();
      useCase = GetRandomNumberTrivia(mockNumberTriviaRepository);
    },
  );

  const tNumberTrivia = NumberTrivia(number: 1, text: 'test');

  test(
    'should get random trivia from repository',
    () async {
      // arrange
      when(() => mockNumberTriviaRepository.getRandomNumberTrivia())
          .thenAnswer((_) async => const Right(tNumberTrivia));

      // act
      final result = await useCase(
        params: const NoParams(),
      );

      // assert
      expect(result, const Right(tNumberTrivia));
      verify(() => mockNumberTriviaRepository.getRandomNumberTrivia());
      verifyNoMoreInteractions(mockNumberTriviaRepository);
    },
  );
}
