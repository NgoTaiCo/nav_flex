import 'package:flutter/material.dart';

class TransitionFactory {
  /// Slide transition with customizable start, end, and curve.
  static RouteTransitionsBuilder slideTransition({
    Offset begin = const Offset(1.0, 0.0), // Default slide from right
    Offset end = Offset.zero, // Default end position is centered
    Curve curve = Curves.easeInOut, // Default easing curve
  }) {
    return (context, animation, secondaryAnimation, child) {
      var tween = Tween<Offset>(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(position: offsetAnimation, child: child);
    };
  }

  /// Fade transition with customizable opacity.
  static RouteTransitionsBuilder fadeTransition({
    double beginOpacity = 0.0, // Default start opacity
    double endOpacity = 1.0, // Default end opacity
  }) {
    return (context, animation, secondaryAnimation, child) {
      var opacityTween = Tween<double>(begin: beginOpacity, end: endOpacity);
      var opacityAnimation = animation.drive(opacityTween);

      return FadeTransition(opacity: opacityAnimation, child: child);
    };
  }

  /// Scale transition with customizable scale factor.
  static RouteTransitionsBuilder scaleTransition({
    double beginScale = 0.0, // Default start scale
    double endScale = 1.0, // Default end scale
    Curve curve = Curves.easeInOut, // Default easing curve
  }) {
    return (context, animation, secondaryAnimation, child) {
      var scaleTween = Tween<double>(begin: beginScale, end: endScale).chain(CurveTween(curve: curve));
      var scaleAnimation = animation.drive(scaleTween);

      return ScaleTransition(scale: scaleAnimation, child: child);
    };
  }

  /// Rotate transition with customizable angle.
  static RouteTransitionsBuilder rotateTransition({
    double beginAngle = 0.0,
    double endAngle = 1.0,
    Curve curve = Curves.easeInOut,
  }) {
    return (context, animation, secondaryAnimation, child) {
      var angleTween = Tween<double>(begin: beginAngle, end: endAngle).chain(CurveTween(curve: curve));
      var angleAnimation = animation.drive(angleTween);

      return RotationTransition(turns: angleAnimation, child: child);
    };
  }

  static RouteTransitionsBuilder colorFadeTransition({
    Color beginColor = Colors.white,
    Color endColor = Colors.blue,
    double beginOpacity = 0.0,
    double endOpacity = 1.0,
  }) {
    return (context, animation, secondaryAnimation, child) {
      var colorTween = ColorTween(begin: beginColor, end: endColor).chain(CurveTween(curve: Curves.easeInOut));
      var opacityTween = Tween<double>(begin: beginOpacity, end: endOpacity);

      var colorAnimation = animation.drive(colorTween);
      var opacityAnimation = animation.drive(opacityTween);

      return AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return Container(
            color: colorAnimation.value,
            child: Opacity(opacity: opacityAnimation.value, child: child),
          );
        },
        child: child,
      );
    };
  }

  static RouteTransitionsBuilder slideAndRotateTransition({
    Offset begin = const Offset(1.0, 0.0),
    double beginAngle = 2,
    Curve curve = Curves.easeInOut,
  }) {
    return (context, animation, secondaryAnimation, child) {
      var offsetTween = Tween<Offset>(begin: begin, end: Offset.zero).chain(CurveTween(curve: curve));
      var angleTween = Tween<double>(begin: beginAngle, end: 0).chain(CurveTween(curve: curve));

      var offsetAnimation = animation.drive(offsetTween);
      var angleAnimation = animation.drive(angleTween);

      return AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return Transform(
            transform: Matrix4.translationValues(offsetAnimation.value.dx, offsetAnimation.value.dy, 0)
              ..rotateZ(angleAnimation.value),
            child: child,
          );
        },
        child: child,
      );
    };
  }

  static RouteTransitionsBuilder parallaxTransition({
    double xOffset = 0.0,
    double yOffset = 0.0,
    Curve curve = Curves.easeInOut,
  }) {
    return (context, animation, secondaryAnimation, child) {
      var offsetTween =
          Tween<Offset>(begin: Offset(xOffset, yOffset), end: Offset.zero).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(offsetTween);

      return SlideTransition(position: offsetAnimation, child: child);
    };
  }

  static RouteTransitionsBuilder zoomAndFadeTransition({
    double beginScale = 0.0,
    double endScale = 1.0,
    double beginOpacity = 0.0,
    double endOpacity = 1.0,
    Curve curve = Curves.easeInOut,
  }) {
    return (context, animation, secondaryAnimation, child) {
      var scaleTween = Tween<double>(begin: beginScale, end: endScale).chain(CurveTween(curve: curve));
      var opacityTween = Tween<double>(begin: beginOpacity, end: endOpacity);

      var scaleAnimation = animation.drive(scaleTween);
      var opacityAnimation = animation.drive(opacityTween);

      return AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return Transform.scale(
            scale: scaleAnimation.value,
            child: FadeTransition(opacity: opacityAnimation, child: child),
          );
        },
        child: child,
      );
    };
  }
}
