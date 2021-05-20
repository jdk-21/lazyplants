import 'package:flutter/material.dart';

class LPCustomButton extends StatelessWidget {
  const LPCustomButton({
    Key key,
    @required this.onPressed,
    @required this.btnText,
    this.textKey,
  }) : super(key: key);

  final GestureTapCallback onPressed;
  final String btnText;
  final Key textKey;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50.0),
      child: TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
            return Colors.transparent; // Defer to the widget's default.
          }),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: Color(0xFF00897B),
          ),
          padding: const EdgeInsets.only(
              left: 45.0, right: 45.0, top: 12, bottom: 12),
          child: Text(
            btnText,
            key: textKey,
            style: TextStyle(fontSize: 14, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
