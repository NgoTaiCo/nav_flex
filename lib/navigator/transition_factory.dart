part of 'nav_flex.dart';

/// The `TransitionFactory` class provides a collection of customizable
/// route transition animations for enhancing navigation experiences.
///
/// ### Key Features:
/// - Multiple pre-built transitions, such as slide, fade, scale, rotate, etc.
/// - Flexible customization options for animation parameters.
/// - Combines transitions like sliding and rotating or zooming and fading.
///
/// ### Usage:
/// Pass a factory method to the `transitionsBuilder` parameter of a `PageRouteBuilder`
/// or other transition-compatible routing methods.
class TransitionFactory {
  /// Creates a **slide transition** with customizable start and end offsets, and curve.
  ///
  /// - **Parameters:**
  ///   - `begin`: Starting offset of the animation (default: slide from the right).
  ///   - `end`: Ending offset of the animation (default: center).
  ///   - `curve`: Animation curve (default: `Curves.easeInOut`).
  ///
  /// ### Example:
  /// ```dart
  /// TransitionFactory.slideTransition(
  ///   begin: Offset(0, 1), // Slide from the bottom
  ///   end: Offset.zero,
  ///   curve: Curves.easeOut,
  /// );
  /// ```
  static RouteTransitionsBuilder slideTransition({
    Offset begin = const Offset(1.0, 0.0),
    Offset end = Offset.zero,
    Curve curve = Curves.easeInOut,
  }) {
    return (context, animation, secondaryAnimation, child) {
      var tween =
          Tween<Offset>(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);
      return SlideTransition(position: offsetAnimation, child: child);
    };
  }

  /// Creates a **fade transition** with customizable opacity range.
  ///
  /// - **Parameters:**
  ///   - `beginOpacity`: Initial opacity (default: `0.0` - fully transparent).
  ///   - `endOpacity`: Final opacity (default: `1.0` - fully visible).
  ///
  /// ### Example:
  /// ```dart
  /// TransitionFactory.fadeTransition(
  ///   beginOpacity: 0.5,
  ///   endOpacity: 1.0,
  /// );
  /// ```
  static RouteTransitionsBuilder fadeTransition({
    double beginOpacity = 0.0,
    double endOpacity = 1.0,
  }) {
    return (context, animation, secondaryAnimation, child) {
      var opacityTween = Tween<double>(begin: beginOpacity, end: endOpacity);
      var opacityAnimation = animation.drive(opacityTween);
      return FadeTransition(opacity: opacityAnimation, child: child);
    };
  }

  /// Creates a **scale transition** with customizable scale range and curve.
  ///
  /// - **Parameters:**
  ///   - `beginScale`: Initial scale (default: `0.0` - fully shrunk).
  ///   - `endScale`: Final scale (default: `1.0` - normal size).
  ///   - `curve`: Animation curve (default: `Curves.easeInOut`).
  ///
  /// ### Example:
  /// ```dart
  /// TransitionFactory.scaleTransition(
  ///   beginScale: 0.5,
  ///   endScale: 1.0,
  ///   curve: Curves.easeIn,
  /// );
  /// ```
  static RouteTransitionsBuilder scaleTransition({
    double beginScale = 0.0,
    double endScale = 1.0,
    Curve curve = Curves.easeInOut,
  }) {
    return (context, animation, secondaryAnimation, child) {
      var scaleTween = Tween<double>(begin: beginScale, end: endScale)
          .chain(CurveTween(curve: curve));
      var scaleAnimation = animation.drive(scaleTween);
      return ScaleTransition(scale: scaleAnimation, child: child);
    };
  }

  /// Creates a **rotate transition** with customizable rotation angles.
  ///
  /// - **Parameters:**
  ///   - `beginAngle`: Starting angle in rotations (default: `0.0`).
  ///   - `endAngle`: Ending angle in rotations (default: `1.0` - one full rotation).
  ///   - `curve`: Animation curve (default: `Curves.easeInOut`).
  ///
  /// ### Example:
  /// ```dart
  /// TransitionFactory.rotateTransition(
  ///   beginAngle: 0.0,
  ///   endAngle: 0.25, // Quarter rotation
  /// );
  /// ```
  static RouteTransitionsBuilder rotateTransition({
    double beginAngle = 0.0,
    double endAngle = 1.0,
    Curve curve = Curves.easeInOut,
  }) {
    return (context, animation, secondaryAnimation, child) {
      var angleTween = Tween<double>(begin: beginAngle, end: endAngle)
          .chain(CurveTween(curve: curve));
      var angleAnimation = animation.drive(angleTween);
      return RotationTransition(turns: angleAnimation, child: child);
    };
  }

  /// Combines a fade and background color transition.
  ///
  /// - **Parameters:**
  ///   - `beginColor`: Initial background color (default: `Colors.white`).
  ///   - `endColor`: Final background color (default: `Colors.blue`).
  ///   - `beginOpacity`: Initial opacity (default: `0.0`).
  ///   - `endOpacity`: Final opacity (default: `1.0`).
  ///
  /// ### Example:
  /// ```dart
  /// TransitionFactory.colorFadeTransition(
  ///   beginColor: Colors.red,
  ///   endColor: Colors.green,
  /// );
  /// ```
  static RouteTransitionsBuilder colorFadeTransition({
    Color beginColor = Colors.white,
    Color endColor = Colors.blue,
    double beginOpacity = 0.0,
    double endOpacity = 1.0,
  }) {
    return (context, animation, secondaryAnimation, child) {
      var colorTween = ColorTween(begin: beginColor, end: endColor)
          .chain(CurveTween(curve: Curves.easeInOut));
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

  /// Creates a **slide and rotate transition**.
  ///
  /// - **Parameters:**
  ///   - `begin`: Initial offset of the slide (default: slide from the right).
  ///   - `beginAngle`: Starting rotation angle (default: `2` rotations).
  ///   - `curve`: Animation curve (default: `Curves.easeInOut`).
  ///
  /// ### Example:
  /// ```dart
  /// TransitionFactory.slideAndRotateTransition();
  /// ```
  static RouteTransitionsBuilder slideAndRotateTransition({
    Offset begin = const Offset(1.0, 0.0),
    double beginAngle = 2,
    Curve curve = Curves.easeInOut,
  }) {
    return (context, animation, secondaryAnimation, child) {
      var offsetTween = Tween<Offset>(begin: begin, end: Offset.zero)
          .chain(CurveTween(curve: curve));
      var angleTween = Tween<double>(begin: beginAngle, end: 0)
          .chain(CurveTween(curve: curve));

      var offsetAnimation = animation.drive(offsetTween);
      var angleAnimation = animation.drive(angleTween);

      return AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return Transform(
            transform: Matrix4.translationValues(
                offsetAnimation.value.dx, offsetAnimation.value.dy, 0)
              ..rotateZ(angleAnimation.value),
            child: child,
          );
        },
        child: child,
      );
    };
  }

  // Other transitions follow the same pattern.
}
