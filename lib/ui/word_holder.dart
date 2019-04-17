import 'package:flutter/material.dart';

class WordHolder extends StatefulWidget {
  final Function onTap;
  final List<String> builtWord;
  final int points;

  const WordHolder({Key key, this.onTap, this.points, this.builtWord}) : super(key: key);

  @override
  _WordHolderState createState() => _WordHolderState();
}

class _WordHolderState extends State<WordHolder> with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> scaleAnimation;
  Animation<double> borderAnimation;
  List<String> letters;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: animationController,
        builder: (c, v) => GestureDetector(
            onTap: widget.onTap,
            child: Transform.scale(
                scale: scaleAnimation.value,
                child: Container(
                    decoration: BoxDecoration(
                        // color: colorAnimation.value,
                        border: Border.all(color: Colors.white, width: borderAnimation.value),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: Iterable.generate(letters.length).map((n) {
                        return Container(
                            child: MaterialButton(
                                minWidth: (MediaQuery.of(context).size.width - 86) / 6,
                                onPressed: null,
                                child: AnimatedDefaultTextStyle(
                                  child: Text(
                                    letters[n],
                                  ),
                                  duration: Duration(milliseconds: 250),
                                  curve: Curves.easeInSine,
                                  style: letters[n] == kSpace
                                      ? TextStyle(fontSize: 0).copyWith(color: Colors.white)
                                      : TextStyle(fontSize: 32).copyWith(color: Colors.white),
                                )));
                      }).toList(),
                    )))));
  }

  @override
  void didUpdateWidget(WordHolder oldWidget) {
    if (oldWidget.points < widget.points) {
      animationController
        ..value = 0
        ..forward();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    letters = widget.builtWord;
    animationController = new AnimationController(duration: const Duration(milliseconds: 300), vsync: this)
      ..addStatusListener((s) {
        if (s == AnimationStatus.completed) {
          animationController.reverse();
          setState(() {
            letters = widget.builtWord;
          });
        }
      });
    scaleAnimation = new Tween<double>(begin: 1, end: 1.1).animate(animationController);
    borderAnimation = new Tween<double>(begin: 0.5, end: 4).animate(animationController);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}
