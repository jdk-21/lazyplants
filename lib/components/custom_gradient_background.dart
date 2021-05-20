import 'package:flutter/material.dart';
import 'package:lazyplants/components/custom_colors.dart';

class CustomGradientBackground extends StatelessWidget {
  const CustomGradientBackground({
    Key key,
    @required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: CustomColors.addGradientColors,
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
            ),
          ),
          Center(
            child: child,
          ),
        ],
      ),
    );
  }
}
