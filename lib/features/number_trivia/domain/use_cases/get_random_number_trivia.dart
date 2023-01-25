import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/use_cases/use_case.dart';
import '../entitites/number_trivia.dart';
import '../repositories/number_trivia_repository.dart';

class GetRandomNumberTrivia implements UseCase<NumberTrivia, NoParams> {
  final NumberTriviaRepository numberTriviaRepository;

  const GetRandomNumberTrivia(this.numberTriviaRepository);

  @override
  Future<Either<Failures, NumberTrivia>> call({
    required NoParams params,
  }) {
    return numberTriviaRepository.getRandomNumberTrivia();
  }
}
