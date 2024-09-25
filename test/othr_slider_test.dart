import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:othr_slider/classes.dart';
import 'package:othr_slider/othr_slider.dart';

void main() {
  group('TrackConfiguration tests', () {
    test('Default values', () {
      const trackConfig = TrackConfiguration();
      expect(trackConfig.height, 8.0);
      expect(trackConfig.border, 1.0);
      expect(trackConfig.borderColor, Colors.black);
      expect(trackConfig.borderRadius, 30.0);
      expect(trackConfig.activeGradient.colors, [Colors.blue, Colors.red]);
      expect(trackConfig.displayOuterShadows, false);
      expect(trackConfig.constrainThumbInTrack, true);
    });

    test('Custom values', () {
      const trackConfig = TrackConfiguration(
        height: 10.0,
        border: 2.0,
        borderColor: Colors.green,
        borderRadius: 20.0,
        displayOuterShadows: true,
      );
      expect(trackConfig.height, 10.0);
      expect(trackConfig.border, 2.0);
      expect(trackConfig.borderColor, Colors.green);
      expect(trackConfig.borderRadius, 20.0);
      expect(trackConfig.displayOuterShadows, true);
    });
  });

  group('ThumbConfiguration tests', () {
    test('Default values', () {
      const thumbConfig = ThumbConfiguration();
      expect(thumbConfig.radius, 10.0);
      expect(thumbConfig.width, 20.0);
      expect(thumbConfig.height, 20.0);
      expect(thumbConfig.colorsList, [const Color(0xffdde1e7)]);
      expect(thumbConfig.borderColor, Colors.black);
      expect(thumbConfig.borderWidth, 0);
      expect(thumbConfig.displayOuterShadows, false);
    });

    test('Custom values', () {
      const thumbConfig = ThumbConfiguration(
        radius: 15.0,
        width: 30.0,
        height: 30.0,
        colorsList: [Colors.purple],
        borderColor: Colors.red,
        borderWidth: 2.0,
      );
      expect(thumbConfig.radius, 15.0);
      expect(thumbConfig.width, 30.0);
      expect(thumbConfig.height, 30.0);
      expect(thumbConfig.colorsList, [Colors.purple]);
      expect(thumbConfig.borderColor, Colors.red);
      expect(thumbConfig.borderWidth, 2.0);
    });
  });

  group('OverlayConfiguration tests', () {
    test('Default values', () {
      const overlayConfig = OverlayConfiguration();
      expect(overlayConfig.color, const Color.fromRGBO(0, 0, 0, 0.1));
      expect(overlayConfig.radius, 40.0);
      expect(overlayConfig.width, 40.0);
      expect(overlayConfig.height, 40.0);
    });

    test('Custom values', () {
      const overlayConfig = OverlayConfiguration(
        color: Colors.yellow,
        radius: 20.0,
        width: 50.0,
        height: 50.0,
      );
      expect(overlayConfig.color, Colors.yellow);
      expect(overlayConfig.radius, 20.0);
      expect(overlayConfig.width, 50.0);
      expect(overlayConfig.height, 50.0);
    });
  });

  group('LabelConfiguration tests', () {
    test('Default values', () {
      const labelConfig = LabelConfiguration();
      expect(labelConfig.useCustomLabel, true);
      expect(labelConfig.backgroundColor, Colors.black);
      expect(labelConfig.textStyle,
          const TextStyle(fontSize: 12.0, color: Colors.white));
      expect(labelConfig.width, 40.0);
      expect(labelConfig.height, 24.0);
    });

    test('Custom values', () {
      const labelConfig = LabelConfiguration(
        useCustomLabel: false,
        backgroundColor: Colors.red,
        textStyle: TextStyle(fontSize: 16.0, color: Colors.blue),
        width: 50.0,
        height: 30.0,
      );
      expect(labelConfig.useCustomLabel, false);
      expect(labelConfig.backgroundColor, Colors.red);
      expect(labelConfig.textStyle,
          const TextStyle(fontSize: 16.0, color: Colors.blue));
      expect(labelConfig.width, 50.0);
      expect(labelConfig.height, 30.0);
    });
  });

  group('OthrSlider widget tests', () {
    testWidgets('Renders correctly with default configurations',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OthrSlider(
              trackConfig: const TrackConfiguration(),
              thumbConfig: const ThumbConfiguration(),
              overlayConfig: const OverlayConfiguration(),
              labelConfig: const LabelConfiguration(),
              sliderState: SliderState(minValue: 0, maxValue: 100),
            ),
          ),
        ),
      );

      expect(find.byType(Slider), findsOneWidget);
    });

    testWidgets('Slider value changes', (WidgetTester tester) async {
      double sliderValue = 50;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OthrSlider(
              trackConfig: const TrackConfiguration(),
              thumbConfig: const ThumbConfiguration(),
              overlayConfig: const OverlayConfiguration(),
              labelConfig: const LabelConfiguration(),
              sliderState: SliderState(
                minValue: 0,
                maxValue: 100,
                initialValue: sliderValue,
                onChanged: (value) {
                  sliderValue = value;
                },
              ),
            ),
          ),
        ),
      );

      await tester.drag(find.byType(Slider), const Offset(100.0, 0.0));
      await tester.pumpAndSettle();
      expect(sliderValue, greaterThan(50));
    });
  });
}
