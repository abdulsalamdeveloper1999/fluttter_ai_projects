import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_midjourney/features/prompt/bloc/prompt_bloc.dart';

class CreatePromptScreen extends StatefulWidget {
  const CreatePromptScreen({Key? key}) : super(key: key);

  @override
  State<CreatePromptScreen> createState() => _CreatePromptScreenState();
}

class _CreatePromptScreenState extends State<CreatePromptScreen> {
  var kborder = OutlineInputBorder(
    borderSide: const BorderSide(
      color: Colors.white54,
    ),
    borderRadius: BorderRadius.circular(15),
  );

  final promptController = TextEditingController();

  @override
  void dispose() {
    promptController.dispose();
    super.dispose();
  }

  // @override
  // void initState() {
  //   context.read<PromptBloc>().add(PromptInitialEvent());
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomSheet: Container(
          padding: const EdgeInsets.all(10),
          child: TextFormField(
            controller: promptController,
            decoration: InputDecoration(
              hintText: 'Enter prompt here...',
              border: kborder,
              suffixIcon: GestureDetector(
                onTap: () {
                  if (promptController.text.isNotEmpty) {
                    context
                        .read<PromptBloc>()
                        .add(PromptEnteredEvent(prompt: promptController.text));
                    FocusScope.of(context).requestFocus(FocusNode());
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter prompt')),
                    );
                  }
                },
                child: const Icon(Icons.generating_tokens),
              ),
              focusedBorder: kborder,
              enabledBorder: kborder,
            ),
          ),
        ),
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Generate Images 🚀',
            style: TextStyle(fontSize: 18),
          ),
        ),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: BlocConsumer<PromptBloc, PromptState>(
            listener: (context, state) {
              if (state is PromptGeneratingImageSuccessState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Image Generated Successfully')),
                );
              } else if (state is PromptGeneratingImageErrorState) {
                context.read<PromptBloc>().add(PromptInitialEvent());
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.error)),
                );
              }
            },
            builder: (context, state) {
              if (state is PromptGeneratingImageLoadState) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is PromptGeneratingImageSuccessState) {
                return _body(state);
              } else if (state is PromptInitial) {
                // Handle unknown state
                return _animatedText();
              }
              return Center(
                child: Text('Error $state'),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _animatedText() {
    const colorizeColors = [
      Colors.white,
      Colors.blue,
      Colors.grey,
    ];

    const colorizeTextStyle = TextStyle(
      fontSize: 18,
    );

    return Center(
      child: SizedBox(
        width: 250.0,
        child: AnimatedTextKit(
          pause: const Duration(milliseconds: 100),
          animatedTexts: [
            ColorizeAnimatedText(
              'Unleash Your Creativity with AI-Generated Images!',
              textAlign: TextAlign.center,
              textStyle: colorizeTextStyle,
              colors: colorizeColors,
              speed: const Duration(milliseconds: 200),
            ),
            ColorizeAnimatedText(
              'Get Started!',
              textAlign: TextAlign.center,
              textStyle: colorizeTextStyle,
              colors: colorizeColors,
              speed: const Duration(milliseconds: 200),
            ),
          ],
          isRepeatingAnimation: false,
          totalRepeatCount: 0,
          onTap: () {},
        ),
      ),
    );
  }

  Widget _body(PromptGeneratingImageSuccessState successState) {
    return Container(
      padding: const EdgeInsets.all(15),
      height: MediaQuery.of(context).size.height,
      width: double.maxFinite,
      decoration: const BoxDecoration(
        // image: DecorationImage(
        //   fit: BoxFit.cover,
        //   image: MemoryImage(),
        // ),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black12,
            Colors.black38,
            Colors.black87,
          ],
        ),
      ),
      child: Image.memory(
        successState.uint8list,
        fit: BoxFit.cover,
        width: double.maxFinite,
      ),
    );
  }
}

class GlowingText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final Duration duration;

  const GlowingText({
    required this.text,
    this.style = const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    this.duration = const Duration(seconds: 1),
    Key? key,
  }) : super(key: key);

  @override
  State<GlowingText> createState() => _GlowingTextState();
}

class _GlowingTextState extends State<GlowingText> {
  bool _glow = false;

  @override
  void initState() {
    super.initState();
    _startGlowAnimation();
  }

  void _startGlowAnimation() {
    Timer.periodic(widget.duration, (timer) {
      setState(() {
        _glow = !_glow;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: _glow
            ? const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Colors.transparent, Colors.yellow, Colors.transparent],
                stops: [0.1, 0.5, 0.9],
              )
            : null,
      ),
      child: Text(
        widget.text,
        style: widget.style.copyWith(
          color: _glow ? Colors.transparent : widget.style.color,
        ),
      ),
    );
  }
}
