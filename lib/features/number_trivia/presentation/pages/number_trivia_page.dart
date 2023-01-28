import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_trivia/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import '../widgets/number_trivia_widgets.dart';

import '../../../../injection_container.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Number Trivia'),
      ),
      body: BlocProvider(
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
                    child: const Placeholder(),
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
    );
  }
}

class TriviaControlWidget extends StatefulWidget {
  const TriviaControlWidget({
    super.key,
  });

  @override
  State<TriviaControlWidget> createState() => _TriviaControlWidgetState();
}

class _TriviaControlWidgetState extends State<TriviaControlWidget> {
  @override
  Widget build(BuildContext context) {
    String inputStr = '';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: TextField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Enter a trivia number...',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              inputStr = value;
            },
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: MaterialButton(
                color: Colors.blueGrey,
                child: const Text('Search'),
                onPressed: () {
                  context
                      .read<NumberTriviaBloc>()
                      .add(GetTriviaForConcreteNumberEvent(inputStr));
                  setState(() {});
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: MaterialButton(
                color: Colors.blue.shade900,
                child: const Text('Random Trivia'),
                onPressed: () {
                  context
                      .read<NumberTriviaBloc>()
                      .add(GetTriviaForRandomNumberEvent());
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
