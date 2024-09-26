library othr_slider;

import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

import 'package:othr_slider/classes.dart';

class OthrSlider extends StatefulWidget {
  final TrackConfiguration trackConfig;
  final ThumbConfiguration thumbConfig;
  final OverlayConfiguration overlayConfig;
  final LabelConfiguration labelConfig;
  final SliderState sliderState;

  const OthrSlider({
    super.key,
    required this.trackConfig,
    required this.thumbConfig,
    required this.overlayConfig,
    required this.labelConfig,
    required this.sliderState,
  });

  @override
  State<OthrSlider> createState() => _OthrSliderState();
}

class _OthrSliderState extends State<OthrSlider> {
  late double _sliderValue;
  List<double> stops = [];
  ui.Image? _image;

  @override
  void initState() {
    super.initState();
    _sliderValue = widget.sliderState.initialValue ??
        (widget.sliderState.minValue + widget.sliderState.maxValue) / 2;

    if (widget.labelConfig.imagePath != null) {
      _loadImage(widget.labelConfig.imagePath!);
    }

    if (widget.trackConfig.activeGradient.stops != null) {
      stops = widget.trackConfig.activeGradient.stops!;
    } else {
      for (var i = 0;
          i < widget.trackConfig.activeGradient.colors.length;
          i++) {
        stops.add(i.toDouble());
      }
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
    double percentage = (value - widget.sliderState.minValue) /
        (widget.sliderState.maxValue - widget.sliderState.minValue);
    return colors[
        (percentage * (colors.length - 1)).clamp(0, colors.length - 1).toInt()];
  }

  Color _getGradientColor(Gradient gradient) {
    double sliderValueToUse =
        _sliderValue / widget.sliderState.maxValue * (stops.length - 1);
    if (widget.sliderState.divisions != null) {
      sliderValueToUse = sliderValueToUse.floorToDouble();
    }

    final int stopIndex =
        stops.lastIndexWhere((stop) => stop <= sliderValueToUse);

    if (stopIndex == stops.length - 1) {
      return gradient.colors.last;
    }

    final Color startColor = gradient.colors[stopIndex];
    final Color endColor = gradient.colors[stopIndex + 1];
    final double startStop = stops[stopIndex];
    final double endStop = stops[stopIndex + 1];

    final double localT =
        (sliderValueToUse - startStop) / (endStop - startStop);
    return Color.lerp(startColor, endColor, localT)!;
  }

  @override
  Widget build(BuildContext context) {
    final Color thumbColor = widget.thumbConfig.autoThumbColor
        ? _getGradientColor(widget.trackConfig.activeGradient)
        : _getColorByPercentage(widget.thumbConfig.colorsList, _sliderValue);

    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: widget.trackConfig.height,
        trackShape: CustomSliderTrackShape(
          trackConfig: widget.trackConfig,
          labelWidth: widget.labelConfig.width,
        ),
        thumbShape: CustomSliderThumbShape(
          thumbConfig: widget.thumbConfig,
          labelConfig: widget.labelConfig,
          color: thumbColor,
          isValueRound: widget.sliderState.isValueRounded,
          sliderValue: _sliderValue,
          image: _image,
        ),
        overlayShape: CustomOverlayShape(
            overlayConfig: widget.overlayConfig,
            thumbConfig: widget.thumbConfig),
        inactiveTickMarkColor: Colors.transparent,
        activeTickMarkColor: Colors.transparent,
        showValueIndicator: widget.labelConfig.showDefaultLabel
            ? ShowValueIndicator.always
            : ShowValueIndicator.never,
      ),
      child: Slider(
        value: _sliderValue,
        min: widget.sliderState.minValue,
        max: widget.sliderState.maxValue,
        divisions: widget.sliderState.divisions,
        label: _sliderValue.toStringAsFixed(1),
        onChanged: (double value) {
          setState(() {
            _sliderValue = value;
          });
          widget.sliderState.onChanged?.call(value);
        },
      ),
    );
  }
}

class CustomOverlayShape extends SliderComponentShape {
  final OverlayConfiguration overlayConfig;
  final ThumbConfiguration thumbConfig;

  const CustomOverlayShape(
      {required this.overlayConfig, required this.thumbConfig});

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size(thumbConfig.width, thumbConfig.height);
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
      ..color = overlayConfig.color
      ..style = PaintingStyle.fill;

    final RRect rrect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: center,
        width: overlayConfig.width,
        height: overlayConfig.height,
      ),
      Radius.circular(overlayConfig.radius),
    );

    canvas.drawRRect(rrect, paint);
  }
}

class CustomSliderThumbShape extends RoundSliderThumbShape {
  final ThumbConfiguration thumbConfig;
  final LabelConfiguration labelConfig;
  final Color color;
  final bool isValueRound;
  final double sliderValue;
  final ui.Image? image;

  const CustomSliderThumbShape({
    required this.sliderValue,
    required this.thumbConfig,
    required this.labelConfig,
    required this.color,
    this.isValueRound = true,
    this.image,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size(thumbConfig.width, thumbConfig.height);
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

    // Draw thumb outer shadows
    if (thumbConfig.displayOuterShadows) {
      final Rect outerTopBounds = Rect.fromCenter(
        center: center,
        width: 20,
        height: 20,
      )
          .shift(thumbConfig.outerTopShadow.offset)
          .inflate(thumbConfig.outerTopShadow.inflate);

      final Rect outerTBottomBounds = Rect.fromCenter(
        center: center,
        width: 20,
        height: 20,
      )
          .shift(thumbConfig.outerBottomShadow.offset)
          .inflate(thumbConfig.outerBottomShadow.inflate);

      final Paint outerTopShadow = Paint()
        ..color = thumbConfig.outerTopShadow.color ??
            const Color(0xFFFFFFFF).withOpacity(0.45)
        ..maskFilter = MaskFilter.blur(
            BlurStyle.normal, thumbConfig.outerTopShadow.spread);

      final Paint outerBottomShadow = Paint()
        ..color = thumbConfig.outerBottomShadow.color ??
            const Color(0xFF5E6879).withOpacity(0.3)
        ..maskFilter = MaskFilter.blur(
            BlurStyle.normal, thumbConfig.outerBottomShadow.spread);

      canvas.drawRRect(
        RRect.fromLTRBAndCorners(
          outerTBottomBounds.left,
          outerTBottomBounds.top,
          outerTBottomBounds.right,
          outerTBottomBounds.bottom,
          topLeft: Radius.circular(thumbConfig.outerBottomShadow.radius),
          bottomLeft: Radius.circular(thumbConfig.outerBottomShadow.radius),
          bottomRight: Radius.circular(thumbConfig.outerBottomShadow.radius),
          topRight: Radius.circular(thumbConfig.outerBottomShadow.radius),
        ),
        outerBottomShadow,
      );

      canvas.drawRRect(
        RRect.fromLTRBAndCorners(
          outerTopBounds.left,
          outerTopBounds.top,
          outerTopBounds.right,
          outerTopBounds.bottom,
          topLeft: Radius.circular(thumbConfig.outerTopShadow.radius),
          bottomLeft: Radius.circular(thumbConfig.outerTopShadow.radius),
          bottomRight: Radius.circular(thumbConfig.outerTopShadow.radius),
          topRight: Radius.circular(thumbConfig.outerTopShadow.radius),
        ),
        outerTopShadow,
      );
    }

    // Draw thumb
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final RRect thumbRRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: center,
        width: thumbConfig.width,
        height: thumbConfig.height,
      ),
      Radius.circular(thumbConfig.radius),
    );
    canvas.drawRRect(thumbRRect, paint);

    // Draw thumb inner shadows
    if (thumbConfig.displayInnerShadows) {
      final RRect rrect = RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: center,
            width: thumbConfig.width,
            height: thumbConfig.height,
          ),
          Radius.circular(thumbConfig.radius));

      canvas.save();
      canvas.clipRRect(rrect);
      canvas.saveLayer(rrect.outerRect, Paint());

      final Paint innerTopShadow = Paint()
        ..color = thumbConfig.innerTopShadow.color ??
            const Color(0xFFFFFFFF).withOpacity(0.45)
        ..maskFilter = MaskFilter.blur(
            BlurStyle.normal, thumbConfig.innerTopShadow.spread);

      final Paint innerBottomShadow = Paint()
        ..color = thumbConfig.innerBottomShadow.color ??
            const Color(0xFF5E6879).withOpacity(0.3)
        ..maskFilter = MaskFilter.blur(
            BlurStyle.normal, thumbConfig.innerBottomShadow.spread);

      final Rect innerTopBounds = Rect.fromCenter(
        center: center,
        width: 20,
        height: 20,
      )
          .shift(thumbConfig.innerTopShadow.offset)
          .inflate(thumbConfig.innerTopShadow.inflate);

      final Rect innerBottomBounds = Rect.fromCenter(
        center: center,
        width: thumbConfig.width,
        height: thumbConfig.height,
      )
          .shift(thumbConfig.innerBottomShadow.offset)
          .inflate(thumbConfig.innerBottomShadow.inflate);

      void paintBox(
          Canvas canvas, Rect rect, Paint paint, TextDirection? textDirection) {
        canvas.drawRRect(
            BorderRadius.circular(thumbConfig.radius)
                .resolve(textDirection)
                .toRRect(rect),
            paint);
      }

      paintBox(canvas, innerTopBounds, innerTopShadow, textDirection);
      paintBox(canvas, innerBottomBounds, innerBottomShadow, textDirection);

      canvas.restore(); // Restore after the layer
      canvas.restore(); // Restore the clipping region
    }

    // Draw border
    final Paint borderPaint = Paint()
      ..color = thumbConfig.borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = thumbConfig.borderWidth;

    if (thumbConfig.borderWidth != 0) {
      canvas.drawRRect(thumbRRect, borderPaint);
    }

    Future<void> drawLabel(
        Canvas canvas, Offset center, TextDirection textDirection) async {
      // Draw slider value in label
      final TextPainter textPainter = TextPainter(
        text: TextSpan(
          text: isValueRound
              ? sliderValue.round().toString()
              : sliderValue.toStringAsFixed(2),
          style: labelConfig.textStyle,
        ),
        textAlign: TextAlign.center,
        textDirection: textDirection,
      )..layout();

      // Background rectangle position
      final Offset backgroundOffset = center -
          Offset(labelConfig.width / 2,
              labelConfig.verticalOffset ?? thumbConfig.height * 2);

      // Draw label background
      final Paint backgroundPaint = Paint()
        ..color = labelConfig.backgroundColor
        ..style = PaintingStyle.fill;
      final Rect backgroundRect = Rect.fromLTWH(
        backgroundOffset.dx,
        backgroundOffset.dy,
        labelConfig.width,
        labelConfig.height,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
            backgroundRect, Radius.circular(labelConfig.radius)),
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
              labelConfig.textStyle)
          .width;

      double textHeight = getTextSize(
              isValueRound
                  ? sliderValue.round().toString()
                  : sliderValue.toStringAsFixed(2),
              labelConfig.textStyle)
          .height;

      // Calculate the position to place the text within the background rectangle
      final Offset textOffset = center -
          Offset(
              textWidth / 2 + labelConfig.horizontalTextOffset,
              labelConfig.verticalOffset != null
                  ? textHeight / 2 +
                      labelConfig.verticalOffset! -
                      backgroundRect.height / 2
                  : textHeight / 2 +
                      thumbConfig.height * 2 -
                      backgroundRect.height / 2);

      final Offset imageOffset = center -
          Offset(
              labelConfig.imageHorizontalOffset,
              labelConfig.verticalOffset != null
                  ? textHeight / 2 +
                      labelConfig.verticalOffset! -
                      backgroundRect.height / 2
                  : textHeight / 2 +
                      thumbConfig.height * 2 -
                      backgroundRect.height / 2);

      // Paint the text on the canvas
      textPainter.paint(canvas, textOffset);

      if (labelConfig.imagePath != null) {
        if (image != null) {
          canvas.drawImage(image!, imageOffset, Paint());
        }
      }
    }

    // Draw label
    if (labelConfig.useCustomLabel) {
      drawLabel(canvas, center, textDirection);
    }
  }
}

class CustomSliderTrackShape extends SliderTrackShape
    with BaseSliderTrackShape {
  final double labelWidth;
  final TrackConfiguration trackConfig;

  CustomSliderTrackShape({
    required this.trackConfig,
    required this.labelWidth,
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

    final canvas = context.canvas;

    @override
    Rect getPreferredRect({
      required RenderBox parentBox,
      Offset offset = Offset.zero,
      required SliderThemeData sliderTheme,
      bool isEnabled = false,
      bool isDiscrete = false,
    }) {
      if (trackConfig.constrainThumbInTrack) {
        final double trackHeight = sliderTheme.trackHeight!;
        assert(trackHeight >= 0);

        final double trackLeft = offset.dx + 1;
        final double trackTop =
            offset.dy + (parentBox.size.height - trackHeight) / 2;
        final double trackRight = trackLeft + parentBox.size.width - 2;
        final double trackBottom = trackTop + trackHeight;
        // If the parentBox's size less than slider's size the trackRight will be less than trackLeft, so switch them.
        return Rect.fromLTRB(math.min(trackLeft, trackRight), trackTop,
            math.max(trackLeft, trackRight), trackBottom);
      } else {
        final double thumbWidth = sliderTheme.thumbShape!
            .getPreferredSize(isEnabled, isDiscrete)
            .width;
        final double overlayWidth = sliderTheme.overlayShape!
            .getPreferredSize(isEnabled, isDiscrete)
            .width;
        final double trackHeight = sliderTheme.trackHeight!;
        assert(overlayWidth >= 0);
        assert(trackHeight >= 0);

        final double trackLeft =
            offset.dx + math.max(overlayWidth / 2, thumbWidth / 2);
        final double trackTop =
            offset.dy + (parentBox.size.height - trackHeight) / 2;
        final double trackRight = trackLeft +
            parentBox.size.width -
            math.max(thumbWidth, overlayWidth);
        final double trackBottom = trackTop + trackHeight;
        // If the parentBox's size less than slider's size the trackRight will be less than trackLeft, so switch them.
        return Rect.fromLTRB(math.min(trackLeft, trackRight), trackTop,
            math.max(trackLeft, trackRight), trackBottom);
      }
    }

    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    final Paint activePaint = _createPaint(trackConfig.activeGradient,
        trackRect, sliderTheme, enableAnimation, true);
    final Paint inactivePaint = _createPaint(trackConfig.inactiveGradient,
        trackRect, sliderTheme, enableAnimation, false);

    final Radius trackRadius = Radius.circular(trackConfig.borderRadius);

    // Draw track outer shadows
    if (trackConfig.displayOuterShadows) {
      final Paint outerTopShadow = Paint()
        ..color =
            trackConfig.outerTopShadow.color ?? Colors.white.withOpacity(0.45)
        ..maskFilter = MaskFilter.blur(
            BlurStyle.normal, trackConfig.outerTopShadow.spread);

      final Paint outerBottomShadow = Paint()
        ..color = trackConfig.outerBottomShadow.color ??
            const Color(0xFF5E6879).withOpacity(0.3)
        ..maskFilter = MaskFilter.blur(
            BlurStyle.normal, trackConfig.outerBottomShadow.spread);

      final Rect outerTopBounds = trackRect
          .shift(trackConfig.outerTopShadow.offset)
          .inflate(trackConfig.outerTopShadow.inflate);
      final Rect outerBottomBounds = trackRect
          .shift(trackConfig.outerBottomShadow.offset)
          .inflate(trackConfig.outerBottomShadow.inflate);

      void paintBox(Canvas canvas, Rect rect, Paint paint,
          TextDirection? textDirection, double radius) {
        canvas.drawRRect(
            BorderRadius.circular(radius).resolve(textDirection).toRRect(rect),
            paint);
      }

      paintBox(canvas, outerTopBounds, outerTopShadow, textDirection,
          trackConfig.outerTopShadow.radius);
      paintBox(canvas, outerBottomBounds, outerBottomShadow, textDirection,
          trackConfig.outerBottomShadow.radius);
    }

    _drawTrack(
      canvas: canvas,
      trackRect: trackRect,
      thumbCenter: thumbCenter,
      leftTrackPaint: activePaint,
      rightTrackPaint: inactivePaint,
      textDirection: textDirection,
      activeTrackRadius: trackRadius,
      trackRadius: trackRadius,
    );

    // Draw inner track shadows
    if (trackConfig.displayInnerShadows) {
      final RRect rrect = RRect.fromRectAndRadius(
          trackRect, Radius.circular(trackConfig.borderRadius));

      canvas.save();
      canvas.clipRRect(rrect);
      canvas.saveLayer(rrect.outerRect, Paint());
      final Paint innerTopShadow = Paint()
        ..color = trackConfig.innerTopShadow.color ??
            const Color(0xFF5E6879).withOpacity(0.3)
        ..maskFilter = MaskFilter.blur(
            BlurStyle.normal, trackConfig.innerTopShadow.spread);

      final Paint innerBottomShadow = Paint()
        ..color = trackConfig.innerBottomShadow.color ??
            const Color(0xFFFFFFFF).withOpacity(0.45)
        ..maskFilter = MaskFilter.blur(
            BlurStyle.normal, trackConfig.innerBottomShadow.spread);

      final Rect innerTopBounds = trackRect
          .shift(trackConfig.innerTopShadow.offset)
          .inflate(trackConfig.innerTopShadow.inflate);
      final Rect innerBottomBounds = trackRect
          .shift(trackConfig.innerBottomShadow.offset)
          .inflate(trackConfig.innerBottomShadow.inflate);

      void paintBox(Canvas canvas, Rect rect, Paint paint,
          TextDirection? textDirection, double radius) {
        canvas.drawRRect(
            BorderRadius.circular(radius).resolve(textDirection).toRRect(rect),
            paint);
      }

      paintBox(canvas, innerTopBounds, innerTopShadow, textDirection,
          trackConfig.innerTopShadow.radius);
      paintBox(canvas, innerBottomBounds, innerBottomShadow, textDirection,
          trackConfig.innerBottomShadow.radius);
      canvas.restore(); // Restore after the layer
      canvas.restore(); // Restore the clipping region
    }

    if (trackConfig.border > 0) {
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
      ..color = trackConfig.borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = trackConfig.border < trackRect.height / 2
          ? trackConfig.border
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
