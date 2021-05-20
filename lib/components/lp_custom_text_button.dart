import 'package:flutter/material.dart';

class LP_CustomTextButton extends StatelessWidget {
  const LP_CustomTextButton({
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
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
          return Colors.transparent; // Defer to the widget's default.
        }),
      ),
      child: Container(
        padding:
            const EdgeInsets.only(left: 15.0, right: 15.0, top: 10, bottom: 10),
        child: Text(
          btnText,
          key: textKey,
          style: TextStyle(fontSize: 14, color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
