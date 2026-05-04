import 'package:bridle/game.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class Tile extends StatelessWidget {
  const Tile(this.letter, this.hitType, {super.key});
  final String letter;
  final HitType hitType;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      width: 60,
      height: 60,
      duration: Duration(milliseconds: 500),
      curve: Curves.bounceIn,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        color: switch (hitType) {
          HitType.hit => Colors.green,
          HitType.miss => Colors.grey,
          HitType.partial => Colors.yellow,
          _ => Colors.white,
        },
      ),
      child: Center(child: Text(letter.toUpperCase())),
    );
  }
}

class GamePage extends StatefulWidget {
  GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final Game _game = Game();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Column(
        spacing: 5.0, 
        children: [for (final guess in _game.guesses) 
          Row(
            spacing: 5.0,
            children: [for (final letter in guess) Tile(letter.char, letter.type)]
          ),
          GuessInput(onSubmitGuess: (guess) {
            setState(() {
              _game.guess(guess);
            });
          })
        ]
      ),
    );
  }
}

class GuessInput extends StatelessWidget {
  final Function(String) onSubmitGuess;
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focus = FocusNode();
  GuessInput({super.key, required this.onSubmitGuess});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              maxLength: 5, 
              decoration: InputDecoration(labelText: "Enter your guess", 
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0))
                  )
                ),
              controller: _controller,
              onSubmitted: (input) {
                _controller.clear();
                _focus.requestFocus();
              },
              focusNode: _focus,
            ),
          ),
        ),
        IconButton(
          padding: EdgeInsets.all(8.0),
          icon: Icon(Icons.arrow_circle_up),
          onPressed: () {
            onSubmitGuess(_controller.text.trim());
            _controller.clear();
            _focus.requestFocus();
          },
        ),
      ],
    );
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(child: GamePage()),
        appBar: AppBar(title: Align(alignment: Alignment.centerLeft, child: Text("Bridle"))),
      ),
    );
  }
}