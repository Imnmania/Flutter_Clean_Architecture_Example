import 'package:dartz/dartz.dart';
import 'package:number_trivia/core/error/failures.dart';
import 'package:number_trivia/features/number_trivia/domain/entitites/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';

class GetConcreteNumberTrivia {
  final NumberTriviaRepository numberTriviaRepository;

  const GetConcreteNumberTrivia(this.numberTriviaRepository);

  Future<Either<Failures, NumberTrivia>> execute({
    required int number,
  }) async {
    return numberTriviaRepository.getConcreteNumberTrivia(number);
  }
}
