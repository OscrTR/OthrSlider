# OthrSlider - Customizable Flutter Slider Widget

OthrSlider is a highly customizable Flutter slider widget that allows you to control every aspect of the slider's appearance, including track, thumb, overlay, and label configuration. This package is ideal for developers who need to create unique and visually appealing sliders for their Flutter applications.

<p align="center">
  <img alt="image 1" src="https://github.com/OscrTR/OthrSlider/blob/main/images/othr_slider_image.png" width="30%">
</p>

## Features

- **Custom Track**: Control the slider's track size, shape, gradients, shadows, and border.
- **Custom Thumb**: Fully customize the thumb's size, color, shape, shadows, and border.
- **Custom Overlay**: Customize the overlay that appears when the thumb is pressed.
- **Custom Label**: Customize the label that appears above the thumb when pressed, including support for images and text.
- **Responsive to Changes**: Listen to value changes and react accordingly.

## Installation

Add othr_slider to your pubspec.yaml:

```bash
dependencies:
    othr_slider: ^0.0.2
```

Then, run the following command to install the package:

```bash
flutter pub get
```

## Usage

```dart
import 'package:flutter/material.dart';
import 'package:othr_slider/othr_slider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: OthrSlider(
            trackConfig: TrackConfiguration(),
            thumbConfig: ThumbConfiguration(),
            overlayConfig: OverlayConfiguration(),
            labelConfig: LabelConfiguration(),
            sliderState: SliderState(
              minValue: 0,
              maxValue: 100,
              initialValue: 20,
              onChanged: (value) {
                print('Slider value: $value');
              },
            ),
          ),
        ),
      ),
    );
  }
}

}
```

## Customization

### TrackConfiguration

Use TrackConfiguration to control the appearance of the slider's track.

```dart
TrackConfiguration(
  height: 10.0,
  border: 1.0, // Set the width of the border,
  borderColor: Colors.black,
  borderRadius: 20.0,
  activeGradient: LinearGradient(
    colors: [Colors.blue, Colors.green],
  ), // Gradient for the active part of the track
  inactiveGradient: LinearGradient(
    colors: [Colors.grey, Colors.black],
  ), // Gradient for the inactive part of the track
  displayOuterShadows: true, // Enable outer shadows
  displayInnerShadows: true, // Enable inner shadows
  constrainThumbInTrack: true, // Prevent the thumb to overflow the track at the edges
  innerTopShadow: const Shadow(spread: 9, offset: Offset(-5, -5), inflate: 0, radius: 30),
  innerBottomShadow =
    const Shadow(spread: 4, offset: Offset(5, 5), inflate: 0, radius: 30),
  outerTopShadow =
    const Shadow(spread: 1, offset: Offset(-2, -2), inflate: 0, radius: 30),
  outerBottomShadow =
    const Shadow(spread: 1, offset: Offset(2, 2), inflate: 0, radius: 30),
)

```

### ThumbConfiguration

Use ThumbConfiguration to control the appearance of the thumb.

```dart
ThumbConfiguration(
  radius: 15.0,
  width: 25.0,
  height: 25.0,
  colorsList: [Colors.purple, Colors.red], // Set thumb colors,
  borderColor: Colors.black,
  borderWidth: 1,
  displayInnerShadows: true, // Enable inner shadows
  displayOuterShadows: true, // Enable outer shadows
  autoThumbColor: true, // Thumb color is computed depending on its position on the track
  innerTopShadow =
    const Shadow(spread: 4, offset: Offset(-5, -5), inflate: 0, radius: 20),
  innerBottomShadow =
    const Shadow(spread: 9, offset: Offset(5, 5), inflate: 0, radius: 20),
  outerTopShadow =
    const Shadow(spread: 1, offset: Offset(1, 1), inflate: 0, radius: 20),
  outerBottomShadow =
    const Shadow(spread: 1, offset: Offset(-1, -1), inflate: 0, radius: 20),
)
```

### OverlayConfiguration

Use OverlayConfiguration to customize the overlay that appears when the thumb is pressed.

```dart
OverlayConfiguration(
  color: Colors.yellow.withOpacity(0.4),
  radius: 20.0,
  width: 50.0,
  height: 50.0,
)
```

### LabelConfiguration

Use LabelConfiguration to customize the label that appears above the thumb when pressed.

```dart
LabelConfiguration(
  useCustomLabel: true,
  showDefaultLabel: false,
  backgroundColor: Colors.black,
  textStyle: TextStyle(
    fontSize: 14.0,
    color: Colors.white,
  ), // Set text style for the label
  verticalOffset: 11, // Represent the offset between the center of the thumb and the center of the label
  horizontalTextOffset: -5, // Moves the label text to the right
  width: 40,
  height: 24,
  radius: 5,
  imagePath: 'assets/label_icon.png', // Set an image inside the label
  imageHorizontalOffset: 15, // Moves the image to the left
)
```

### SliderState

Use SliderState to define global slider parameters.

```dart
SliderState(
  minValue: 0,
  maxValue: 10,
  initialValue: 2,
  isValueRounded: true, // Display rounded values instead of floating values
  onChanged: (value) {
    print('Custom slider value: $value');
  },
  divisions: 10, // Fixes the possible values for the slider
)
```

## Contributing

We welcome contributions! If you have any suggestions, bug reports, or want to contribute code, feel free to open an issue or submit a pull request.

Contributions are welcome! Here's how you can help:

1. Fork the project
2. Create a branch for your feature (git checkout -b feature/new-feature)
3. Commit your changes (git commit -m 'Add a new feature')
4. Push to the branch (git push origin feature/new-feature)
5. Open a Pull Request

## License

This project is licensed under the BSD-3 License. See the [LICENSE](LICENSE) file for more details.
