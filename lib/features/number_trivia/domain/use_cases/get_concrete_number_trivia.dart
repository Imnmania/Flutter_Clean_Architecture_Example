import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/use_cases/use_case.dart';
import '../entitites/number_trivia.dart';
import '../repositories/number_trivia_repository.dart';

class GetConcreteNumberTrivia implements UseCase<NumberTrivia, Params> {
  final NumberTriviaRepository numberTriviaRepository;

  const GetConcreteNumberTrivia(this.numberTriviaRepository);

  @override
  Future<Either<Failures, NumberTrivia>?> call({
    required Params params,
  }) async {
    return numberTriviaRepository.getConcreteNumberTrivia(params.number);
  }
}

class Params extends Equatable {
  final int number;
  const Params({
    required this.number,
  });

  @override
  List<Object?> get props => [number];
}
