import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:othr_slider/othr_slider.dart';

void main() {
  testWidgets('OthrSlider initializes with correct values',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: OthrSlider(
          minValue: 0,
          maxValue: 100,
          initialValue: 50,
          onChanged: (value) {},
        ),
      ),
    ));

    final slider = tester.widget<Slider>(find.byType(Slider));

    expect(slider.value, 50);
  });

  testWidgets('OthrSlider calls onChanged when value is changed',
      (WidgetTester tester) async {
    double newValue = 0;

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: OthrSlider(
          minValue: 0,
          maxValue: 100,
          initialValue: 50,
          onChanged: (value) {
            newValue = value;
          },
        ),
      ),
    ));

    // Move the slider
    await tester.drag(
        find.byType(Slider), const Offset(50, 0)); // Drag to the right
    await tester.pump(); // Rebuild the widget after the change

    expect(newValue, greaterThan(50));
  });

  testWidgets('OthrSlider displays custom colors', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: OthrSlider(
          minValue: 0,
          maxValue: 100,
          initialValue: 50,
          activeTrackColors: const [Colors.blue, Colors.green],
          thumbColors: const [Colors.red],
          onChanged: (value) {},
        ),
      ),
    ));

    final slider = tester.widget<OthrSlider>(find.byType(OthrSlider));
    expect(slider.activeTrackColors, [Colors.blue, Colors.green]);
    expect(slider.thumbColors, [Colors.red]);
  });

  testWidgets('OthrSlider renders with the correct track height',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: OthrSlider(
          minValue: 0,
          maxValue: 100,
          initialValue: 50,
          trackHeight: 10,
          onChanged: (value) {},
        ),
      ),
    ));

    final sliderThemeData = SliderTheme.of(tester.element(find.byType(Slider)));

    expect(sliderThemeData.trackHeight, 10);
  });
}
