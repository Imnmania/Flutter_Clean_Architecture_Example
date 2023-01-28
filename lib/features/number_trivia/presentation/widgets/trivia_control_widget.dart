import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/number_trivia_bloc.dart';

class TriviaControlWidget extends StatefulWidget {
  const TriviaControlWidget({
    super.key,
  });

  @override
  State<TriviaControlWidget> createState() => _TriviaControlWidgetState();
}

class _TriviaControlWidgetState extends State<TriviaControlWidget> {
  late TextEditingController triviaInputController;

  @override
  void initState() {
    triviaInputController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    triviaInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: TextField(
            controller: triviaInputController,
            keyboardType: TextInputType.number,
            keyboardAppearance: Brightness.dark,
            decoration: const InputDecoration(
              labelText: 'Enter a trivia number...',
              border: OutlineInputBorder(),
            ),
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
                  context.read<NumberTriviaBloc>().add(
                      GetTriviaForConcreteNumberEvent(
                          triviaInputController.text));
                  triviaInputController.clear();
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
                  triviaInputController.clear();
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
