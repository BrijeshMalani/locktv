import 'package:flutter/material.dart';
import 'animations.dart';

class CustomPageTransitionBuilder extends PageTransitionsBuilder {
  const CustomPageTransitionBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return CustomPageTransitions.slideFadeTransition(
      context,
      animation,
      secondaryAnimation,
      child,
    );
  }
}

