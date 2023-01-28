import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_trivia/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import '../widgets/widgets.dart';

import '../../../../injection_container.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Number Trivia'),
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        child: BlocProvider(
          create: (context) => sl<NumberTriviaBloc>(),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 10),
                BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                  builder: (context, state) {
                    if (state is EmptyState) {
                      return const MessageDisplayWidget(
                        message: '🔍 Start Searching!',
                      );
                    } else if (state is ErrorState) {
                      return MessageDisplayWidget(
                        message: '⚠️ ${state.errorMessage}',
                      );
                    } else if (state is LoadingState) {
                      return const LoadingWidget();
                    } else if (state is LoadedState) {
                      return TriviaDisplayWidget(
                        numberTrivia: state.trivia,
                      );
                    }
                    return SizedBox(
                      height: MediaQuery.of(context).size.height / 3,
                      child: const MessageDisplayWidget(
                        message: '🔍 Start Searching!',
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                const TriviaControlWidget(),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
