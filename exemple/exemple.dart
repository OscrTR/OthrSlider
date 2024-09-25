import 'package:flutter/material.dart';
import 'package:othr_slider/classes.dart';
import 'package:othr_slider/othr_slider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'othr_slider demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Color> myColorList = const [
    Color(0xfffedac2),
    Color(0xffffe4ca),
    Color(0xffffe7c8),
    Color(0xfffee9c4),
    Color(0xfffeecc2),
    Color(0xfffeefbf),
    Color(0xfff6efc2),
    Color(0xffebefc4),
    Color(0xffe4f0c6),
    Color(0xffdcf0c9),
    Color(0xffc9eec0),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(widget.title),
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const Text(
                        'Slider with divisions, custom label and multiple thumb colors.'),
                    const SizedBox(height: 30),
                    OthrSlider(
                      sliderState:
                          SliderState(minValue: 0, maxValue: 10, divisions: 10),
                      trackConfig: TrackConfiguration(
                          activeGradient: LinearGradient(colors: myColorList)),
                      thumbConfig: ThumbConfiguration(
                          borderWidth: 1, colorsList: myColorList),
                      overlayConfig: const OverlayConfiguration(
                          height: 40, width: 40, radius: 40),
                      labelConfig: const LabelConfiguration(),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const Text('Slider with auto thumb colors.'),
                    const SizedBox(height: 30),
                    OthrSlider(
                      sliderState: SliderState(minValue: 0, maxValue: 100),
                      trackConfig: const TrackConfiguration(),
                      thumbConfig: const ThumbConfiguration(
                          borderWidth: 1, autoThumbColor: true),
                      overlayConfig:
                          const OverlayConfiguration(color: Colors.transparent),
                      labelConfig: const LabelConfiguration(),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const Text('Slider with label image.'),
                    const SizedBox(height: 30),
                    OthrSlider(
                      sliderState: SliderState(
                          minValue: 0, maxValue: 100, initialValue: 20),
                      trackConfig: const TrackConfiguration(
                        border: 0,
                        height: 7,
                        activeGradient: LinearGradient(
                            colors: [Color(0xff024aff), Color(0xff024aff)]),
                        inactiveGradient: LinearGradient(
                            colors: [Color(0xffededed), Color(0xffededed)]),
                      ),
                      thumbConfig: const ThumbConfiguration(
                          borderColor: Color(0xff002eff),
                          height: 15,
                          width: 45,
                          colorsList: [Color(0xff002eff)]),
                      overlayConfig: const OverlayConfiguration(),
                      labelConfig: const LabelConfiguration(
                          imagePath: 'assets/eth_logo.png',
                          imageHorizontalOffset: 15,
                          textStyle: TextStyle(fontSize: 10),
                          horizontalTextOffset: -5,
                          verticalOffset: 11,
                          backgroundColor: Colors.transparent),
                    ),
                  ],
                ),
              ),
              Container(
                color: const Color(0xff181818),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const Text(
                        'Simple slider on dark background.',
                        style: TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 30),
                      OthrSlider(
                        sliderState: SliderState(minValue: 0, maxValue: 100),
                        trackConfig: const TrackConfiguration(
                            activeGradient: LinearGradient(
                                colors: [Color(0xff0078f8), Color(0xff0078f8)]),
                            inactiveGradient: LinearGradient(
                                colors: [Color(0xff3d3d3d), Color(0xff3d3d3d)]),
                            borderColor: Color(0xff565656),
                            constrainThumbInTrack: false),
                        thumbConfig: const ThumbConfiguration(
                          colorsList: [Color(0xfff2f2f2)],
                          borderColor: Color(0xff20201f),
                        ),
                        overlayConfig: const OverlayConfiguration(),
                        labelConfig:
                            const LabelConfiguration(useCustomLabel: false),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                color: const Color(0xffdde1e7),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const Text(
                        'Neuemorphic slider exemple.',
                      ),
                      const SizedBox(height: 30),
                      OthrSlider(
                        sliderState: SliderState(minValue: 0, maxValue: 10),
                        trackConfig: const TrackConfiguration(
                          height: 20,
                          border: 0,
                          displayOuterShadows: true,
                          activeGradient: LinearGradient(
                              colors: [Color(0xffdde1e7), Color(0xffdde1e7)]),
                          inactiveGradient: LinearGradient(
                              colors: [Color(0xffdde1e7), Color(0xffdde1e7)]),
                        ),
                        thumbConfig: ThumbConfiguration(
                          displayInnerShadows: true,
                          displayOuterShadows: true,
                          innerTopShadow: Shadow(
                              color: const Color(0xFF5E6879).withOpacity(0.2),
                              offset: const Offset(-4, -4),
                              spread: 4,
                              radius: 20),
                          innerBottomShadow: Shadow(
                              color: Colors.white.withOpacity(0.45),
                              spread: 4,
                              offset: const Offset(5, 5),
                              radius: 20),
                          outerTopShadow: Shadow(
                              color: Colors.white.withOpacity(0.45),
                              spread: 1,
                              offset: const Offset(-2, -2),
                              radius: 20),
                          outerBottomShadow: Shadow(
                              color: const Color(0xFF5E6879).withOpacity(0.2),
                              spread: 1,
                              offset: const Offset(2, 2),
                              radius: 20),
                        ),
                        overlayConfig: const OverlayConfiguration(
                            color: Colors.transparent),
                        labelConfig:
                            const LabelConfiguration(useCustomLabel: false),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                color: const Color(0xff2d3139),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const Text(
                        'Other neuemorphic slider exemple.',
                        style: TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 30),
                      OthrSlider(
                        sliderState: SliderState(minValue: 0, maxValue: 10),
                        trackConfig: const TrackConfiguration(
                          height: 20,
                          border: 0,
                          displayInnerShadows: true,
                          innerTopShadow: Shadow(
                              color: Color.fromRGBO(27, 28, 38, 0.4),
                              spread: 4,
                              radius: 30,
                              offset: Offset(-5, -10)),
                          innerBottomShadow: Shadow(
                              color: Color.fromRGBO(71, 75, 82, 0.45),
                              spread: 4,
                              radius: 30,
                              offset: Offset(5, 10)),
                          activeGradient: LinearGradient(
                              colors: [Color(0xff2d3139), Color(0xff2d3139)]),
                          inactiveGradient: LinearGradient(
                              colors: [Color(0xff2d3139), Color(0xff2d3139)]),
                        ),
                        thumbConfig: const ThumbConfiguration(
                            innerTopShadow: Shadow(
                                color: Color(0xff474b52),
                                offset: Offset(-4, -4),
                                spread: 5,
                                radius: 20),
                            innerBottomShadow: Shadow(
                                color: Color(0xff1b1c26),
                                radius: 20,
                                spread: 9,
                                offset: Offset(5, 5)),
                            colorsList: [Color(0xff2d3139)],
                            displayInnerShadows: true),
                        overlayConfig: const OverlayConfiguration(
                            color: Colors.transparent),
                        labelConfig:
                            const LabelConfiguration(useCustomLabel: false),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
