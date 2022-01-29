import 'package:flutter/material.dart';

class IntercomButtonIndicator extends StatelessWidget {
  const IntercomButtonIndicator({Key? key, required this.icon})
      : super(key: key);

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 19, 154, 67),
                border: Border.all(width: 1, color: Colors.white),
                shape: BoxShape.circle),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Icon(icon, size: 20, color: Colors.white),
            )));
  }
}

class IntercomButtonStateIndicator extends StatelessWidget {
  const IntercomButtonStateIndicator(
      {Key? key,
      required this.talkButtonActive,
      required this.openButtonActive})
      : super(key: key);

  final bool talkButtonActive;
  final bool openButtonActive;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        talkButtonActive
            ? const IntercomButtonIndicator(icon: Icons.mic_none)
            : openButtonActive
                ? const IntercomButtonIndicator(icon: Icons.lock_open)
                : const Text(""),
      ],
    );
  }
}
