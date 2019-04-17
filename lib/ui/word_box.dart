import 'package:flutter/material.dart';

class AnimatedWordBox extends StatefulWidget {
  final int count;
  final String word;
  final bool found;

  const AnimatedWordBox({Key key, this.count, this.word, this.found}) : super(key: key);
  @override
  _AnimatedWordBoxState createState() => _AnimatedWordBoxState();
}

class _AnimatedWordBoxState extends State<AnimatedWordBox> with SingleTickerProviderStateMixin {
  AnimationController animationController;
  List<Animation<double>> animations;
  final BorderSide side = const BorderSide(color: Colors.white54, width: 0.4, style: BorderStyle.solid);

  @override
  void initState() {
    animationController = new AnimationController(duration: Duration(milliseconds: 150 * widget.count), vsync: this);
    animations = Iterable.generate(widget.count)
        .map((n) => Tween<double>(begin: 1.5, end: 1).animate(CurvedAnimation(
            parent: animationController,
            curve: Interval(n / widget.count, (n + 1) / widget.count, curve: Curves.easeInCubic))))
        .toList();
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.found) {
      animationController.forward();
    }
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: Iterable.generate(widget.count, (n) {
            return Transform.scale(
                scale: widget.found ? animations[n].value : 1,
                child: Container(
                    decoration: BoxDecoration(
                      border: (n < widget.count - 1)
                          ? Border(top: side, bottom: side, left: side)
                          : Border(
                              top: side,
                              bottom: side,
                              left: side,
                              right: side,
                            ),
                    ),
                    child: Opacity(
                        opacity: widget.found ? 2 - animations[n].value : 1,
                        child: SizedBox.fromSize(
                            size: Size(20, 20),
                            child: Center(
                                child: Text(
                              animations[n].value >= 1.5 ? '' : widget.word[n],
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 14),
                            ))))));
          }).toList(),
        );
      },
    );
  }
}