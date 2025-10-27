import 'package:chat_app/core/utils/style/screen_size.dart';
import 'package:chat_app/features/Auth/views/login_view.dart';
import 'package:flutter/material.dart';

class GetStartedView extends StatefulWidget {
  const GetStartedView({super.key});
  static String routeName = '/get_started';

  @override
  State<GetStartedView> createState() => _GetStartedViewState();
}

class _GetStartedViewState extends State<GetStartedView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  late final Animation<double> _titleFade;
  late final Animation<Offset> _titleSlide;

  late final Animation<double> _subtitleFade;
  late final Animation<Offset> _subtitleSlide;

  late final Animation<double> _imageFade;
  late final Animation<Offset> _imageSlide;

  late final Animation<double> _buttonFade;
  late final Animation<Offset> _buttonSlide;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _titleFade = CurvedAnimation(
      parent: _c,
      curve: const Interval(0.00, 0.35, curve: Curves.easeOutCubic),
    );
    _titleSlide = Tween(begin: const Offset(0, 0.08), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _c,
        curve: const Interval(0.00, 0.35, curve: Curves.easeOutCubic),
      ),
    );

    _subtitleFade = CurvedAnimation(
      parent: _c,
      curve: const Interval(0.15, 0.50, curve: Curves.easeOutCubic),
    );
    _subtitleSlide = Tween(begin: const Offset(0, 0.10), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _c,
            curve: const Interval(0.15, 0.50, curve: Curves.easeOutCubic),
          ),
        );

    _imageFade = CurvedAnimation(
      parent: _c,
      curve: const Interval(0.35, 0.80, curve: Curves.easeOutCubic),
    );
    _imageSlide = Tween(begin: const Offset(0, 0.12), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _c,
        curve: const Interval(0.35, 0.80, curve: Curves.easeOutCubic),
      ),
    );

    _buttonFade = CurvedAnimation(
      parent: _c,
      curve: const Interval(0.65, 1.00, curve: Curves.easeOutCubic),
    );
    _buttonSlide = Tween(begin: const Offset(0, 0.14), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _c,
            curve: const Interval(0.65, 1.00, curve: Curves.easeOutCubic),
          ),
        );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _c.forward();
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  Widget _fadeSlide({
    required Animation<double> fade,
    required Animation<Offset> slide,
    required Widget child,
  }) {
    return FadeTransition(
      opacity: fade,
      child: SlideTransition(position: slide, child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: EdgeInsets.only(
          top: ScreenSize.height / 10,
          left: ScreenSize.width / 10,
          right: ScreenSize.width / 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _fadeSlide(
              fade: _titleFade,
              slide: _titleSlide,
              child: Text(
                "Get Closer To Everyone",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
            SizedBox(height: ScreenSize.height / 50),
            _fadeSlide(
              fade: _subtitleFade,
              slide: _subtitleSlide,
              child: Text(
                "Helps you to contact everyone with just easy way",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            SizedBox(height: ScreenSize.height / 20),
            _fadeSlide(
              fade: _imageFade,
              slide: _imageSlide,
              child: Image.asset(
                "assets/images/get_started.png",
                width: ScreenSize.width,
                height: ScreenSize.height / 2.5,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: ScreenSize.height / 20),
            _fadeSlide(
              fade: _buttonFade,
              slide: _buttonSlide,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, LoginView.routeName);
                },
                style: Theme.of(context).elevatedButtonTheme.style,
                child: const Text("Get Started"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
