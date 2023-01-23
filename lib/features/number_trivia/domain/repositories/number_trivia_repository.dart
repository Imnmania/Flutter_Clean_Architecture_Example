import 'package:dartz/dartz.dart';
import 'package:number_trivia/features/number_trivia/domain/entitites/number_trivia.dart';

import '../../../../core/error/failures.dart';

abstract class NumberTriviaRepository {
  Future<Either<Failures, NumberTrivia>> getConcreteNumberTrivia(int number);
  Future<Either<Failures, NumberTrivia>> getRandomNumberTrivia();
}
