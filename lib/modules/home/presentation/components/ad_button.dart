import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/constants/core_colors.dart';

enum ButtonState { Busy, Idle }

class AdButton extends StatefulWidget {
  final Function onPressedFunction;
  final String text;
  final IconData icon;
  final int cooldown;

  const AdButton({
    Key? key,
    required this.onPressedFunction,
    required this.text,
    required this.icon,
    required this.cooldown,
  }) : super(key: key);

  @override
  State<AdButton> createState() => _AdButtonState();
}

class _AdButtonState extends State<AdButton> with TickerProviderStateMixin {
  double? loaderWidth;

  late Animation<double> _animation;
  late AnimationController _controller;
  ButtonState btn = ButtonState.Idle;
  int secondsLeft = 0;
  Timer? _timer;
  Stream emptyStream = Stream.empty();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: widget.cooldown));

    _animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCirc,
      reverseCurve: Curves.easeInOutCirc,
    ));

    _animation.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        setState(() {
          btn = ButtonState.Idle;
        });
      }
    });
  }

  @override
  void dispose() {
    if (_timer != null) _timer!.cancel();
    _controller.dispose();
    super.dispose();
  }

  void animateForward() {
    setState(() {
      btn = ButtonState.Busy;
    });
    _controller.forward();
  }

  void animateReverse() {
    _controller.reverse();
  }

  lerpWidth(a, b, t) {
    if (a == 0.0 || b == 0.0) {
      return null;
    } else {
      return a + (b - a) * t;
    }
  }

  void startTimer(int newTime) {
    if (newTime == 0) {
      throw ("Count Down Time can not be null");
    }

    animateForward();

    setState(() {
      secondsLeft = newTime;
    });

    if (_timer != null) {
      _timer!.cancel();
    }

    var oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (secondsLeft < 1) {
            timer.cancel();
          } else {
            secondsLeft = secondsLeft - 1;
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return buttonBody();
      },
    );
  }

  Widget buttonBody() {
    return btn == ButtonState.Idle
        ? ElevatedButton.icon(
            onPressed: () {
              widget.onPressedFunction();
              startTimer(widget.cooldown);
            },
            label:
                Text(widget.text, style: const TextStyle(color: Colors.black)),
            icon: Icon(
              widget.icon,
              color: Colors.black,
            ),
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(CoreColors.sfmAccentColor),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(36.0),
              )),
            ),
          )
        : StreamBuilder(
            stream: emptyStream,
            builder: (context, snapshot) {
              if (secondsLeft == 0) {
                animateReverse();
              }
              return ElevatedButton.icon(
                onPressed: null,
                label: Text(secondsLeft.toString() + ' Seconds remaining',
                    style: const TextStyle(color: Colors.black)),
                icon: Icon(
                  widget.icon,
                  color: Colors.black,
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      CoreColors.sfmAccentColor),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(36.0),
                  )),
                ),
              );
            });
  }
}
