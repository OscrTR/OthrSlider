import 'package:flutter/material.dart';

/// Allows to customize the track color, shadows, size, shape and border.
class TrackConfiguration {
  /// Default track height is 8.0.
  final double height;

  /// Default border width is 1.0.
  final double border;

  /// Default border color is black.
  final Color borderColor;

  /// Default border radius is 30.
  final double borderRadius;

  /// Active gradient is the left part of the slider. Default gradient is LinearGradient(colors: [Colors.blue, Colors.red]).
  final Gradient activeGradient;

  /// Inactive gradient is the right part of the slider. Default gradient is LinearGradient(colors: [Colors.grey, Colors.grey]).
  final Gradient inactiveGradient;

  /// Whether the outside of the track should have shadows. Default is false. If set to true, the shadows are customizable via [outerTopShadow] and [outerBottomShadow].
  final bool displayOuterShadows;

  /// Whether the inside of the track should have shadows. Default is false. If set to true, the shadows are customizable via [innerTopShadow] and [innerBottomShadow].
  final bool displayInnerShadows;

  /// Whether the thumb is allowed to move outside of the track so its center is at an edge of the track. Default is true so the thumb will not overflow the track width.
  final bool constrainThumbInTrack;

  /// Default shadow is Shadow(spread: 9, offset: Offset(-5, -5), inflate: 0, radius: 30).
  final Shadow innerTopShadow;

  /// Default shadow is Shadow(spread: 4, offset: Offset(5, 5), inflate: 0, radius: 30).
  final Shadow innerBottomShadow;

  /// Default shadow is Shadow(spread: 1, offset: Offset(-2, -2), inflate: 0, radius: 30).
  final Shadow outerTopShadow;

  /// Default shadow is Shadow(spread: 1, offset: Offset(2, 2), inflate: 0, radius: 30).
  final Shadow outerBottomShadow;

  const TrackConfiguration({
    this.height = 8.0,
    this.border = 1.0,
    this.borderColor = Colors.black,
    this.activeGradient =
        const LinearGradient(colors: [Colors.blue, Colors.red]),
    this.inactiveGradient =
        const LinearGradient(colors: [Colors.grey, Colors.grey]),
    this.borderRadius = 30.0,
    this.displayOuterShadows = false,
    this.displayInnerShadows = false,
    this.constrainThumbInTrack = true,
    this.innerTopShadow =
        const Shadow(spread: 9, offset: Offset(-5, -5), inflate: 0, radius: 30),
    this.innerBottomShadow =
        const Shadow(spread: 4, offset: Offset(5, 5), inflate: 0, radius: 30),
    this.outerTopShadow =
        const Shadow(spread: 1, offset: Offset(-2, -2), inflate: 0, radius: 30),
    this.outerBottomShadow =
        const Shadow(spread: 1, offset: Offset(2, 2), inflate: 0, radius: 30),
  });
}

/// Allows customization of the thumb color, shape, shadows, size.
class ThumbConfiguration {
  /// Default radius is 10.
  final double radius;

  /// Default width is 20.
  final double width;

  /// Default height is 20.
  final double height;

  /// Default color is [Color(0xffdde1e7)].
  final List<Color> colorsList;

  /// Default border color is Colors.black.
  final Color borderColor;

  /// Default border width is 0.
  final double borderWidth;

  /// Whether shadows around the thumb are displayed. Default is false.
  final bool displayOuterShadows;

  /// Whether shadows inside the thumb are displayed. Default is false.
  final bool displayInnerShadows;

  /// Whether thumb color is calculated depending on its position on the gradient. Default is false.
  final bool autoThumbColor;

  /// Default shadow is Shadow(spread: 4, offset: Offset(-5, -5), inflate: 0, radius: 20).
  final Shadow innerTopShadow;

  /// Default shadow is Shadow(spread: 9, offset: Offset(5, 5), inflate: 0, radius: 20).
  final Shadow innerBottomShadow;

  /// Default shadow is Shadow(spread: 1, offset: Offset(1, 1), inflate: 0, radius: 20).
  final Shadow outerTopShadow;

  /// Default shadow is Shadow(spread: 1, offset: Offset(-1, -1), inflate: 0, radius: 20).
  final Shadow outerBottomShadow;

  const ThumbConfiguration({
    this.radius = 10,
    this.width = 20,
    this.height = 20,
    this.colorsList = const [Color(0xffdde1e7)],
    this.borderColor = Colors.black,
    this.borderWidth = 0,
    this.displayOuterShadows = false,
    this.displayInnerShadows = false,
    this.autoThumbColor = false,
    this.innerTopShadow =
        const Shadow(spread: 4, offset: Offset(-5, -5), inflate: 0, radius: 20),
    this.innerBottomShadow =
        const Shadow(spread: 9, offset: Offset(5, 5), inflate: 0, radius: 20),
    this.outerTopShadow =
        const Shadow(spread: 1, offset: Offset(1, 1), inflate: 0, radius: 20),
    this.outerBottomShadow =
        const Shadow(spread: 1, offset: Offset(-1, -1), inflate: 0, radius: 20),
  });
}

/// Allows customization of the overlay (appearing when the thumb is pressed) color and shape.
class OverlayConfiguration {
  /// Default color is Color.fromRGBO(0, 0, 0, 0.1).
  final Color color;

  /// Default radius is 40.
  final double radius;

  /// Default width is 40.
  final double width;

  /// Default height is 40.
  final double height;

  const OverlayConfiguration({
    this.color = const Color.fromRGBO(0, 0, 0, 0.1),
    this.radius = 40,
    this.width = 40,
    this.height = 40,
  });
}

/// Allows customization of the label appearing above the thumb.
class LabelConfiguration {
  /// Whether to use the custom label shape or not. Default is true, using the custom label.
  final bool useCustomLabel;

  /// Whether to show the original label that appears above the thumb when pressed.
  final bool showDefaultLabel;

  /// Default background color is Colors.black.
  final Color backgroundColor;

  /// Default text style is TextStyle(fontSize: 12.0, color: Colors.white).
  final TextStyle textStyle;

  /// Vertical offset represent the offset between the center of the thumb and the center of the label. Default is thumbConfig.height * 2.
  final double? verticalOffset;

  /// Horizontal text offset allows to move the text horizontally. Default is 0.
  final double horizontalTextOffset;

  /// Default width is 40.
  final double width;

  /// Default height is 24.
  final double height;

  /// Default radius is 5.
  final double radius;

  /// Path to an image to display in the label. Default is null.
  final String? imagePath;

  /// Offset to move the image horizontally in the label. Default is 0.
  final double imageHorizontalOffset;

  const LabelConfiguration({
    this.useCustomLabel = true,
    this.showDefaultLabel = false,
    this.backgroundColor = Colors.black,
    this.textStyle = const TextStyle(fontSize: 12.0, color: Colors.white),
    this.verticalOffset,
    this.horizontalTextOffset = 0,
    this.width = 40,
    this.height = 24,
    this.radius = 5,
    this.imagePath,
    this.imageHorizontalOffset = 0,
  });
}

/// Default parameters for the slider.
class SliderState {
  /// Default minValue is 0.
  final double minValue;

  /// Default maxValue is 10.
  final double maxValue;

  /// Default initialValue is (widget.sliderState.minValue + widget.sliderState.maxValue) / 2.
  final double? initialValue;

  /// Whether the slider value should be rounded or not. Default is true.
  final bool isValueRounded;

  /// Callback to execute code when the slider value changes.
  final ValueChanged<double>? onChanged;

  /// Number of slider divisions. Default is null.
  final int? divisions;

  SliderState({
    required this.minValue,
    required this.maxValue,
    this.initialValue,
    this.isValueRounded = true,
    this.onChanged,
    this.divisions,
  });
}

/// Generic class allowing the customization of a shadow color, shape and position.
class Shadow {
  /// Default color is null.
  final Color? color;

  /// Default spread is 1.
  final double spread;

  /// Default offset is 0,0.
  final Offset offset;

  /// Default inflate is 0.
  final double inflate;

  /// Default radius is 0.
  final double radius;

  const Shadow({
    this.color,
    this.spread = 1,
    this.offset = const Offset(0, 0),
    this.inflate = 0,
    this.radius = 0,
  });
}
