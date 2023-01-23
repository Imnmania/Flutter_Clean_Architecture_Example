import 'package:dartz/dartz.dart';
import '../entitites/number_trivia.dart';

import '../../../../core/error/failures.dart';

abstract class NumberTriviaRepository {
  Future<Either<Failures, NumberTrivia>> getConcreteNumberTrivia(int number);
  Future<Either<Failures, NumberTrivia>> getRandomNumberTrivia();
}
