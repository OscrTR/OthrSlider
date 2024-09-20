library othr_slider;

import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OthrSlider extends StatefulWidget {
  /// The minimum value of the slider. This value is inclusive.
  final double minValue;

  /// The maximum value of the slider. This value is inclusive.
  final double maxValue;

  /// The initial value of the slider. If null, the slider starts at the midpoint between [minValue] and [maxValue].
  final double? initialValue;

  /// If true, the displayed value above the thumb will be rounded to the nearest integer.
  final bool? isValueRound;

  /// A callback that is called when the slider value changes. It receives the new value as a parameter.
  final ValueChanged<double>? onChanged;

  /// The number of discrete divisions in the slider. If null, the slider is continuous.
  final int? divisions;

  /// The height of the track. This controls the thickness of the slider track.
  final double? trackHeight;

  /// The width of the track border. If null, a border with a value of 1 will be drawn.
  final double? trackBorder;

  // The color of the track border.
  final Color? trackBorderColor;

  /// The border radius of the track. Used to create rounded corners for the track.
  final double trackBorderRadius;

  /// A list of colors used for the active part of the track. The colors will be blended based on the slider's current value.
  final List<Color>? activeTrackColors;

  /// A list of colors used for the inactive part of the track. The colors will be blended based on the slider's current value.
  final List<Color>? inactiveTrackColors;

  /// The radius of the thumb (the draggable part of the slider).
  final double? thumbRadius;

  /// The width of the thumb when it's in rectangular shape (if applicable).
  final double? thumbRectWidth;

  /// The height of the thumb when it's in rectangular shape (if applicable).
  final double? thumbRectHeight;

  /// A list of colors for the thumb. The color will change based on the slider's current value.
  final List<Color>? thumbColors;

  /// The color of the thumb border.
  final Color? thumbBorderColor;

  /// The width of the thumb border. If null, no border will be drawn around the thumb.
  final double? thumbBorderWidth;

  /// The width of the shadow cast by the thumb.
  final double? thumbShadowWidth;

  /// The height of the shadow cast by the thumb.
  final double? thumbShadowHeight;

  /// The color of the shadow cast by the thumb.
  final Color? thumbShadowColor;

  /// If true, a custom label will be displayed above the thumb instead of the default one.
  final bool? useCustomLabel;

  /// If true, the default label will be shown on the slider.
  final bool? showDefaultLabel;

  /// The background color for the label displayed above the thumb.
  final Color? labelBackgroundColor;

  /// The text style for the label displayed above the thumb.
  final TextStyle? labelTextStyle;

  /// The vertical offset for the label displayed above the thumb.
  final double? labelVerticalOffset;

  /// The vertical offset for the text displayed in the label.
  final double? labelTextHorizontalOffset;

  /// The width of the label displayed above the thumb. If null, a default width will be used.
  final double? labelWidth;

  /// The height of the label displayed above the thumb. If null, a default height will be used.
  final double? labelHeight;

  /// The border radius for the label's background rectangle.
  final double? labelBorderRadius;

  /// Path to the image that would be displayed in the label. If null, no image will be rendered.
  final String? labelImagePath;

  /// Offset for the x axis of the label. If null, the image will be centered.
  final double? labelImageHorizontalOffset;

  /// The color of the overlay that appears when the slider is active.
  final Color overlayColor;

  /// The radius of the overlay. Used to define how round the overlay is.
  final double? overlayRadius;

  /// The width of the overlay.
  final double? overlayWidth;

  /// The height of the overlay.
  final double? overlayHeight;

  const OthrSlider({
    super.key,
    required this.minValue,
    required this.maxValue,
    this.divisions,
    this.onChanged,
    this.initialValue,
    this.trackHeight = 8.0,
    this.trackBorder = 1.0,
    this.thumbRadius = 10,
    this.activeTrackColors,
    this.inactiveTrackColors,
    this.thumbColors = const [Color.fromARGB(255, 204, 204, 204)],
    this.labelBackgroundColor,
    this.trackBorderColor = Colors.black,
    this.thumbBorderColor,
    this.labelTextStyle,
    this.thumbBorderWidth,
    this.thumbShadowWidth,
    this.thumbShadowHeight,
    this.thumbShadowColor,
    this.labelVerticalOffset,
    this.labelWidth,
    this.labelHeight,
    this.labelBorderRadius,
    this.isValueRound = true,
    this.trackBorderRadius = 30.0,
    this.overlayColor = Colors.black,
    this.thumbRectHeight,
    this.thumbRectWidth,
    this.useCustomLabel = true,
    this.showDefaultLabel = false,
    this.overlayRadius = 40,
    this.overlayWidth = 40,
    this.overlayHeight = 40,
    this.labelImagePath,
    this.labelImageHorizontalOffset = 0,
    this.labelTextHorizontalOffset = 0,
  });

  @override
  State<OthrSlider> createState() => _OthrSliderState();
}

class _OthrSliderState extends State<OthrSlider> {
  late double _sliderValue;
  late Gradient _activeTrackGradient;
  late Gradient _inactiveTrackGradient;

  ui.Image? _image;

  @override
  void initState() {
    super.initState();
    _sliderValue =
        widget.initialValue ?? (widget.minValue + widget.maxValue) / 2;
    _activeTrackGradient = LinearGradient(
        colors: widget.activeTrackColors ?? [Colors.blue, Colors.red]);
    _inactiveTrackGradient = LinearGradient(
        colors: widget.inactiveTrackColors ?? [Colors.grey, Colors.grey]);
    if (widget.labelImagePath != null) {
      _loadImage(widget.labelImagePath!);
    }
  }

  Future<void> _loadImage(String path) async {
    final ByteData data = await rootBundle.load(path);
    final Uint8List lst = data.buffer.asUint8List();
    final ui.Codec codec = await ui.instantiateImageCodec(lst);
    final ui.FrameInfo frameInfo = await codec.getNextFrame();
    setState(() {
      _image = frameInfo.image;
    });
  }

  Color _getColorByPercentage(List<Color> colors, double value) {
    double percentage =
        (value - widget.minValue) / (widget.maxValue - widget.minValue);
    return colors[
        (percentage * (colors.length - 1)).clamp(0, colors.length - 1).toInt()];
  }

  @override
  Widget build(BuildContext context) {
    final Color thumbColor =
        _getColorByPercentage(widget.thumbColors!, _sliderValue);

    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: widget.trackHeight,
        trackShape: CustomSliderTrackShape(
          activeTrackGradient: _activeTrackGradient,
          inactiveTrackGradient: _inactiveTrackGradient,
          trackBorder: widget.trackBorder!,
          trackBorderColor: widget.trackBorderColor!,
          trackBorderRadius: widget.trackBorderRadius,
        ),
        thumbShape: CustomSliderThumbShape(
          thumbRadius: widget.thumbRadius!,
          thumbBorderColor: widget.thumbBorderColor,
          labelBackgroundColor: widget.labelBackgroundColor,
          labelTextStyle: widget.labelTextStyle,
          thumbBorderWidth: widget.thumbBorderWidth,
          thumbShadowWidth: widget.thumbShadowWidth,
          thumbShadowHeight: widget.thumbShadowHeight,
          thumbShadowColor: widget.thumbShadowColor,
          labelVerticalOffset: widget.labelVerticalOffset,
          labelWidth: widget.labelWidth,
          labelHeight: widget.labelHeight,
          labelBorderRadius: widget.labelBorderRadius,
          isValueRound: widget.isValueRound!,
          thumbRectWidth: widget.thumbRectWidth,
          thumbRectHeight: widget.thumbRectHeight,
          useCustomLabel: widget.useCustomLabel!,
          sliderValue: _sliderValue,
          labelImagePath: widget.labelImagePath,
          image: _image,
          labelImageHorizontalOffset: widget.labelImageHorizontalOffset!,
          labelTextHorizontalOffset: widget.labelTextHorizontalOffset!,
        ),
        thumbColor: thumbColor,
        overlayShape: CustomOverlayShape(
          overlayRadius: widget.overlayRadius!,
          overlayHeight: widget.overlayHeight!,
          overlayWidth: widget.overlayWidth!,
          overlayColor: widget.overlayColor,
        ),
        inactiveTickMarkColor: Colors.transparent,
        activeTickMarkColor: Colors.transparent,
        showValueIndicator: widget.showDefaultLabel!
            ? ShowValueIndicator.always
            : ShowValueIndicator.never,
      ),
      child: Slider(
        value: _sliderValue,
        min: widget.minValue,
        max: widget.maxValue,
        divisions: widget.divisions,
        label: _sliderValue.toStringAsFixed(1),
        onChanged: (double value) {
          setState(() {
            _sliderValue = value;
          });
          widget.onChanged?.call(value);
        },
      ),
    );
  }
}

class CustomOverlayShape extends SliderComponentShape {
  final double overlayRadius;
  final double overlayHeight;
  final double overlayWidth;
  final Color overlayColor;

  const CustomOverlayShape({
    this.overlayRadius = 40,
    this.overlayHeight = 40,
    this.overlayWidth = 40,
    this.overlayColor = Colors.black,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size(overlayWidth, overlayHeight);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;

    final Paint paint = Paint()
      ..color = overlayColor.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final RRect rrect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: center,
        width: overlayWidth,
        height: overlayHeight,
      ),
      Radius.circular(overlayRadius),
    );

    canvas.drawRRect(rrect, paint);
  }
}

class CustomSliderThumbShape extends RoundSliderThumbShape {
  final double thumbRadius;
  final Color? thumbBorderColor;
  final Color? labelBackgroundColor;
  final TextStyle? labelTextStyle;
  final double? thumbBorderWidth;
  final double? thumbShadowWidth;
  final double? thumbShadowHeight;
  final Color? thumbShadowColor;
  final double? labelVerticalOffset;
  final double? labelWidth;
  final double? labelHeight;
  final double? labelBorderRadius;
  final bool isValueRound;
  final bool isThumbRect;
  final double? thumbRectWidth;
  final double? thumbRectHeight;
  final bool useCustomLabel;
  final double sliderValue;
  final String? labelImagePath;
  final ui.Image? image;
  final double labelImageHorizontalOffset;
  final double labelTextHorizontalOffset;

  const CustomSliderThumbShape({
    this.thumbRadius = 12.0,
    this.thumbBorderColor,
    this.labelBackgroundColor,
    this.labelTextStyle,
    this.thumbBorderWidth,
    this.thumbShadowWidth,
    this.thumbShadowHeight,
    this.thumbShadowColor,
    this.labelVerticalOffset,
    this.labelWidth,
    this.labelHeight,
    this.labelBorderRadius = 5.0,
    this.isValueRound = true,
    this.isThumbRect = false,
    this.thumbRectWidth,
    this.thumbRectHeight,
    this.useCustomLabel = true,
    required this.sliderValue,
    this.labelImagePath,
    this.image,
    this.labelImageHorizontalOffset = 0,
    this.labelTextHorizontalOffset = 0,
  });

  double get _disabledThumbRadius => disabledThumbRadius ?? enabledThumbRadius;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(
        isEnabled ? thumbRadius : disabledThumbRadius ?? thumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;
    final Color color = ColorTween(
      begin: sliderTheme.disabledThumbColor,
      end: sliderTheme.thumbColor,
    ).evaluate(enableAnimation)!;

    // Draw shadow
    void drawShadow(Canvas canvas, Offset center) {
      final double width = thumbShadowWidth ?? 2 * thumbRadius;
      final double height = thumbShadowHeight ?? 2 * thumbRadius;

      final RRect rrect = RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: center,
          width: width,
          height: height,
        ),
        Radius.circular(thumbRadius),
      );

      canvas.drawRRect(
        rrect,
        Paint()
          ..color = thumbShadowColor ?? Colors.black
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, elevation),
      );
    }

    if (thumbShadowColor != null) {
      drawShadow(canvas, center);
    }

    // Draw thumb
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final RRect thumbRRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: center,
        width: thumbRectWidth ?? 20.0,
        height: thumbRectHeight ?? 20.0,
      ),
      Radius.circular(thumbRadius),
    );
    canvas.drawRRect(thumbRRect, paint);

    // Draw border
    final Paint borderPaint = Paint()
      ..color = thumbBorderColor ?? Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = thumbBorderWidth ?? 1.0;
    canvas.drawRRect(thumbRRect, borderPaint);

    final double radius = Tween<double>(
      begin: _disabledThumbRadius,
      end: thumbRadius,
    ).evaluate(enableAnimation);

    Future<void> drawLabel(
        Canvas canvas, Offset center, TextDirection textDirection) async {
      // Draw slider value in label
      final TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: isValueRound
              ? sliderValue.round().toString()
              : sliderValue.toStringAsFixed(2),
          style: labelTextStyle ??
              const TextStyle(fontSize: 12.0, color: Colors.white),
        ),
        textAlign: TextAlign.center,
        textDirection: textDirection,
      )..layout();

      // Background rectangle position
      final Offset backgroundOffset = center -
          Offset(labelWidth != null ? labelWidth! / 2 : 20,
              labelVerticalOffset ?? radius * 4);

      // Draw label background
      final Paint backgroundPaint = Paint()
        ..color = labelBackgroundColor ?? Colors.black
        ..style = PaintingStyle.fill;
      final Rect backgroundRect = Rect.fromLTWH(
        backgroundOffset.dx,
        backgroundOffset.dy,
        labelWidth != null ? labelWidth! : 40,
        labelHeight != null ? labelHeight! : 24,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
            backgroundRect, Radius.circular(labelBorderRadius ?? 5)),
        backgroundPaint,
      );

      Size getTextSize(String text, TextStyle style) {
        final TextPainter textPainter = TextPainter(
          text: TextSpan(text: text, style: style),
          textDirection: ui.TextDirection.ltr,
        )..layout(minWidth: 0, maxWidth: double.infinity);
        return textPainter.size;
      }

      double textWidth = getTextSize(
              isValueRound
                  ? sliderValue.round().toString()
                  : sliderValue.toStringAsFixed(2),
              labelTextStyle ?? const TextStyle(fontSize: 12))
          .width;

      double textHeight = getTextSize(
              isValueRound
                  ? sliderValue.round().toString()
                  : sliderValue.toStringAsFixed(2),
              labelTextStyle ?? const TextStyle(fontSize: 12))
          .height;

      // Calculate the position to place the text within the background rectangle
      final Offset textOffset = center -
          Offset(
              textWidth / 2 + labelTextHorizontalOffset,
              labelVerticalOffset != null
                  ? textHeight / 2 +
                      labelVerticalOffset! -
                      backgroundRect.height / 2
                  : textHeight / 2 + radius * 4 - backgroundRect.height / 2);

      final Offset imageOffset = center -
          Offset(
              labelImageHorizontalOffset,
              labelVerticalOffset != null
                  ? textHeight / 2 +
                      labelVerticalOffset! -
                      backgroundRect.height / 2
                  : textHeight / 2 + radius * 4 - backgroundRect.height / 2);

      // Paint the text on the canvas
      textPainter.paint(canvas, textOffset);

      if (labelImagePath != null) {
        if (image != null) {
          canvas.drawImage(image!, imageOffset, Paint());
        }
      }
    }

    // Draw label
    if (useCustomLabel) {
      drawLabel(canvas, center, textDirection);
    }
  }
}

class CustomSliderTrackShape extends SliderTrackShape
    with BaseSliderTrackShape {
  final Gradient activeTrackGradient;
  final Gradient? inactiveTrackGradient;
  final double trackBorder;
  final Color trackBorderColor;
  final double trackBorderRadius;

  CustomSliderTrackShape({
    required this.activeTrackGradient,
    this.inactiveTrackGradient,
    this.trackBorder = 1.0,
    this.trackBorderColor = Colors.black,
    this.trackBorderRadius = 30.0,
  });

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isEnabled = false,
    bool isDiscrete = false,
    double additionalActiveTrackHeight = 2,
  }) {
    if (sliderTheme.trackHeight == null || sliderTheme.trackHeight! <= 0) {
      return;
    }

    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    final Paint activePaint = _createPaint(
        activeTrackGradient, trackRect, sliderTheme, enableAnimation, true);
    final Paint inactivePaint = _createPaint(
        inactiveTrackGradient, trackRect, sliderTheme, enableAnimation, false);

    final canvas = context.canvas;

    final Radius trackRadius = Radius.circular(trackBorderRadius);
    final Radius activeTrackRadius = Radius.circular(trackBorderRadius);

    _drawTrack(
      canvas: canvas,
      trackRect: trackRect,
      thumbCenter: thumbCenter,
      leftTrackPaint: activePaint,
      rightTrackPaint: inactivePaint,
      textDirection: textDirection,
      activeTrackRadius: activeTrackRadius,
      trackRadius: trackRadius,
    );

    if (trackBorder > 0) {
      _drawTrackBorder(canvas, trackRect, trackRadius);
    }
  }

  Paint _createPaint(
      Gradient? gradient,
      Rect trackRect,
      SliderThemeData sliderTheme,
      Animation<double> enableAnimation,
      bool isActive) {
    final ColorTween colorTween = ColorTween(
      begin: isActive
          ? sliderTheme.disabledActiveTrackColor
          : sliderTheme.disabledInactiveTrackColor,
      end: isActive ? Colors.white : sliderTheme.inactiveTrackColor,
    );

    final Paint paint = Paint()..color = colorTween.evaluate(enableAnimation)!;

    if (gradient != null) {
      paint.shader = gradient.createShader(trackRect);
    }

    return paint;
  }

  void _drawTrack({
    required Canvas canvas,
    required Rect trackRect,
    required Offset thumbCenter,
    required Paint leftTrackPaint,
    required Paint rightTrackPaint,
    required TextDirection textDirection,
    required Radius activeTrackRadius,
    required Radius trackRadius,
  }) {
    switch (textDirection) {
      case TextDirection.ltr:
        canvas.drawRRect(
          RRect.fromLTRBAndCorners(
            trackRect.left,
            trackRect.top - (activeTrackRadius.y - trackRadius.y),
            thumbCenter.dx,
            trackRect.bottom + (activeTrackRadius.y - trackRadius.y),
            topLeft: activeTrackRadius,
            bottomLeft: activeTrackRadius,
          ),
          leftTrackPaint,
        );

        canvas.drawRRect(
          RRect.fromLTRBAndCorners(
            thumbCenter.dx,
            trackRect.top,
            trackRect.right,
            trackRect.bottom,
            topRight: trackRadius,
            bottomRight: trackRadius,
          ),
          rightTrackPaint,
        );
        break;

      case TextDirection.rtl:
        canvas.drawRRect(
          RRect.fromLTRBAndCorners(
            trackRect.left,
            trackRect.top,
            thumbCenter.dx,
            trackRect.bottom,
            topLeft: trackRadius,
            bottomLeft: trackRadius,
          ),
          rightTrackPaint,
        );

        canvas.drawRRect(
          RRect.fromLTRBAndCorners(
            thumbCenter.dx,
            trackRect.top - (activeTrackRadius.y - trackRadius.y),
            trackRect.right,
            trackRect.bottom + (activeTrackRadius.y - trackRadius.y),
            topRight: activeTrackRadius,
            bottomRight: activeTrackRadius,
          ),
          leftTrackPaint,
        );
        break;
    }
  }

  void _drawTrackBorder(Canvas canvas, Rect trackRect, Radius trackRadius) {
    final Paint strokePaint = Paint()
      ..color = trackBorderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = trackBorder < trackRect.height / 2
          ? trackBorder
          : trackRect.height / 2
      ..strokeCap = StrokeCap.round;

    canvas.drawRRect(
      RRect.fromLTRBAndCorners(
        trackRect.left,
        trackRect.top,
        trackRect.right,
        trackRect.bottom,
        topLeft: trackRadius,
        bottomLeft: trackRadius,
        bottomRight: trackRadius,
        topRight: trackRadius,
      ),
      strokePaint,
    );
  }
}
