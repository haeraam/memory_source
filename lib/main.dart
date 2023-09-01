// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const AnimationPractice(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AnimationPractice extends StatefulWidget {
  const AnimationPractice({super.key});

  @override
  State<AnimationPractice> createState() => _AnimationPracticeState();
}

class _AnimationPracticeState extends State<AnimationPractice> {
  List<List<double>> circleData = [];
  final double _areaSize = 400;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Area(
                circleData: circleData,
                areaSize: _areaSize,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(64),
              child: Column(
                children: [
                  const Text(
                    'MEMORY',
                    style: TextStyle(
                      fontFamily: 'roboto',
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  GestureDetector(
                    onTap: () {
                      circleData = List.generate(
                        Random().nextInt(20),
                        (index) => [
                          Random().nextInt(100) + 50.0,
                          Random().nextInt(_areaSize.toInt()).toDouble(),
                          Random().nextInt(_areaSize.toInt()).toDouble(),
                          0.toDouble(),
                          0.toDouble(),
                        ],
                      );
                      setState(() {});
                    },
                    child: const HoverGradentButton(),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class HoverGradentButton extends StatefulWidget {
  const HoverGradentButton({super.key});

  @override
  State<HoverGradentButton> createState() => _HoverGradentButtonState();
}

class _HoverGradentButtonState extends State<HoverGradentButton> with TickerProviderStateMixin {
  final Tween<double> _tween = Tween(begin: 0, end: 0.4);
  late AnimationController _controller;
  late Animation _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _animation = _tween.animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (event) => _controller.forward(),
      onExit: (event) => _controller.reverse(),
      child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Container(
              alignment: Alignment.center,
              width: 110,
              height: 46,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: LinearGradient(
                  stops: [0.3 - _animation.value, 0.7 - _animation.value, 1.2 - _animation.value],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: const [
                    Color(0xFF4158D0),
                    Color(0xFFC850C0),
                    Color(0xFFFFCC70),
                  ],
                ),
              ),
              child: const Text(
                'find',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            );
          }),
    );
  }
}

class Area extends StatefulWidget {
  const Area({
    Key? key,
    required this.circleData,
    required this.areaSize,
  }) : super(key: key);
  final List<List<double>> circleData;
  final double areaSize;

  @override
  State<Area> createState() => _AreaState();
}

class _AreaState extends State<Area> {
  int _index = 1;

  double blurValue = 10;

  double positionX2 = 150;
  double positionY2 = 400;

  double distanceX2 = 2;
  double distanceY2 = 2;

  (double, double) getDistance({required posX, required posY, required mousePos, required size}) {
    print(mousePos);
    double xGap1 = ((posX + size / 2) - mousePos.dx).abs();
    double yGap1 = ((posY + size / 2) - mousePos.dy).abs();
    return ((xGap1 / widget.areaSize) * blurValue, (yGap1 / widget.areaSize) * blurValue);
  }

  Color getColor({int? seedColor}) {
    int r = Random().nextInt(255);
    int g = Random().nextInt(255);
    int b = Random().nextInt(255);
    return Color.fromRGBO(r, g, b, 1);
  }

  @override
  Widget build(BuildContext context) {
    _index = 0;

    return MouseRegion(
      onHover: (PointerHoverEvent e) {
        setState(() {
          for (var circle in widget.circleData) {
            var (x1, y1) = getDistance(posX: circle[1], posY: circle[2], mousePos: e.position, size: circle[0]);
            circle[3] = x1;
            circle[4] = y1;
          }
        });
      },
      child: Stack(
        children: [
          ...widget.circleData.map((circle) {
            return Circle(
              opacity: widget.circleData.length / (widget.circleData.length + (widget.circleData.length - _index++)),
              size: circle[0],
              posX: circle[1],
              posY: circle[2],
              distanceX: circle[3],
              distanceY: circle[4],
              colors: [
                getColor(),
                getColor(),
                getColor(),
                getColor(),
              ],
            );
          }),
          BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 0.5,
              sigmaY: 0.5,
              tileMode: TileMode.mirror,
            ),
            child: Container(
              width: widget.areaSize + 200,
              height: widget.areaSize + 200,
            ),
          )
        ],
      ),
    );
  }
}

class Circle extends StatefulWidget {
  const Circle({
    Key? key,
    required this.distanceX,
    required this.distanceY,
    required this.posX,
    required this.posY,
    required this.opacity,
    required this.colors,
    required this.size,
  }) : super(key: key);
  final double distanceX;
  final double distanceY;
  final double posX;
  final double posY;
  final double opacity;
  final List<Color> colors;
  final double size;

  @override
  State<Circle> createState() => _CircleState();
}

class _CircleState extends State<Circle> with TickerProviderStateMixin {
  late AnimationController _colorAnimationController1;
  late AnimationController _colorAnimationController2;
  late AnimationController _colorAnimationController3;
  late AnimationController _colorAnimationController4;

  late AnimationController _blurXAnimationController;
  late AnimationController _blurYAnimationController;

  late AnimationController _bottomAlignAnimationController;
  late AnimationController _topAlignAnimationController;

  late Animation _colorAnimation1;
  late Animation _colorAnimation2;
  late Animation _colorAnimation3;
  late Animation _colorAnimation4;

  late Animation _blurXAnimation;
  late Animation _blurYAnimation;

  late Animation _bottomAlignmentAnimation;
  late Animation _topAlignmentAnimation;

  final Tween<double> _blurTween = Tween(begin: 4, end: 15);
  final Tween<Alignment> _bottomAlignTween = Tween(begin: Alignment.bottomRight, end: Alignment.bottomLeft);
  final Tween<Alignment> _topAlignTween = Tween(begin: Alignment.topRight, end: Alignment.topLeft);

  final List<TickerFuture> _tickers = [];

  @override
  void dispose() {
    _colorAnimationController1.dispose();
    _colorAnimationController2.dispose();
    _colorAnimationController3.dispose();
    _colorAnimationController4.dispose();
    _blurXAnimationController.dispose();
    _blurYAnimationController.dispose();
    _bottomAlignAnimationController.dispose();
    _topAlignAnimationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    final ColorTween tweenColor1 = ColorTween(begin: widget.colors[0], end: widget.colors[1]);
    final ColorTween tweenColor2 = ColorTween(begin: widget.colors[1], end: widget.colors[2]);
    final ColorTween tweenColor3 = ColorTween(begin: widget.colors[2], end: widget.colors[3]);
    final ColorTween tweenColor4 = ColorTween(begin: widget.colors[3], end: widget.colors[0]);

    _colorAnimationController1 = AnimationController(duration: const Duration(milliseconds: 1300), vsync: this);
    _colorAnimationController2 = AnimationController(duration: const Duration(milliseconds: 1100), vsync: this);
    _colorAnimationController3 = AnimationController(duration: const Duration(milliseconds: 900), vsync: this);
    _colorAnimationController4 = AnimationController(duration: const Duration(milliseconds: 700), vsync: this);

    _blurXAnimationController = AnimationController(duration: const Duration(milliseconds: 1100), vsync: this);
    _blurYAnimationController = AnimationController(duration: const Duration(milliseconds: 1600), vsync: this);
    _bottomAlignAnimationController = AnimationController(duration: const Duration(milliseconds: 140), vsync: this);
    _topAlignAnimationController = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);

    _colorAnimation1 = tweenColor1.animate(_colorAnimationController1);
    _colorAnimation2 = tweenColor2.animate(_colorAnimationController2);
    _colorAnimation3 = tweenColor3.animate(_colorAnimationController3);
    _colorAnimation4 = tweenColor4.animate(_colorAnimationController4);

    _blurXAnimation = _blurTween.animate(_blurXAnimationController);
    _blurYAnimation = _blurTween.animate(_blurYAnimationController);

    _bottomAlignmentAnimation = _bottomAlignTween.animate(_bottomAlignAnimationController);
    _topAlignmentAnimation = _topAlignTween.animate(_bottomAlignAnimationController);

    _tickers.add(_colorAnimationController1.repeat(reverse: true));
    _tickers.add(_colorAnimationController2.repeat(reverse: true));
    _tickers.add(_colorAnimationController3.repeat(reverse: true));
    _tickers.add(_colorAnimationController4.repeat(reverse: true));
    _tickers.add(_blurXAnimationController.repeat(reverse: true));
    _tickers.add(_blurYAnimationController.repeat(reverse: true));
    _tickers.add(_bottomAlignAnimationController.repeat(reverse: true));
    _tickers.add(_topAlignAnimationController.repeat(reverse: true));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: widget.posX,
        top: widget.posY,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _colorAnimationController1,
            builder: (context, child) {
              return Container(
                width: widget.size * 0.7,
                height: widget.size * 0.7,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(widget.size),
                  gradient: LinearGradient(
                    begin: _topAlignmentAnimation.value,
                    end: _bottomAlignmentAnimation.value,
                    colors: [
                      _colorAnimation1.value.withOpacity(1 * (widget.opacity)),
                      _colorAnimation2.value.withOpacity(1 * (widget.opacity)),
                      _colorAnimation3.value.withOpacity(1 * (widget.opacity)),
                      _colorAnimation4.value.withOpacity(1 * (widget.opacity)),
                    ],
                  ),
                ),
              );
            },
          ),
          ClipOval(
            clipBehavior: Clip.antiAlias,
            child: AnimatedBuilder(
                animation: _blurXAnimationController,
                builder: (context, child) {
                  return BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: min(widget.distanceX * _blurXAnimation.value, 15),
                      sigmaY: min(widget.distanceY * _blurYAnimation.value, 15),
                    ),
                    child: Container(
                      width: widget.size,
                      height: widget.size,
                      // width: widget.size * (50 /( widget.distanceX + 50)),
                      // height: widget.size * (50 / (widget.distanceY + 50)),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}
