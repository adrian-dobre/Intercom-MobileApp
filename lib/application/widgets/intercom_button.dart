import 'package:flutter/material.dart';

class IntercomButton extends StatefulWidget {
  const IntercomButton(
      {Key? key,
      required this.buttonColor,
      required this.pressedButtonColor,
      required this.text,
      required this.onInteraction})
      : super(key: key);

  final Color buttonColor;
  final Color pressedButtonColor;
  final String text;
  final Function(bool isActive) onInteraction;

  @override
  State<IntercomButton> createState() => _IntercomButtonState();
}

class _IntercomButtonState extends State<IntercomButton> {
  bool isActive = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTapDown: (tapDownDetails) {
          setState(() {
            isActive = true;
          });
          widget.onInteraction(true);
        },
        onTapCancel: () {
          setState(() {
            isActive = false;
          });
          widget.onInteraction(false);
        },
        onTapUp: (tapUpDetails) {
          setState(() {
            isActive = false;
          });
          widget.onInteraction(false);
        },
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Container(
                alignment: Alignment.center,
                width: double.maxFinite,
                height: 60,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey,
                          offset: Offset.fromDirection(1.5708, 1.0),
                          spreadRadius: 0.0,
                          blurRadius: 1.0)
                    ],
                    color: isActive
                        ? widget.pressedButtonColor
                        : widget.buttonColor,
                    borderRadius: const BorderRadius.all(Radius.circular(3))),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 16.0),
                  child: Text(widget.text,
                      style: const TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.w500)),
                ))));
  }
}
