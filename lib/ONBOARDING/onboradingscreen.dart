import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../Pages/homepage.dart';
import 'introductionPage/introduction1.dart';
import 'introductionPage/introduction2.dart';
import 'introductionPage/introduction3.dart';

class Onboradingscreen extends StatefulWidget {
  const Onboradingscreen({super.key});

  @override
  State<Onboradingscreen> createState() => _OnboradingscreenState();
}

class _OnboradingscreenState extends State<Onboradingscreen> {
  final PageController _controller = PageController();
  bool onLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                onLastPage = (index == 2);
              });
            },
            children: const [
              Introduction1(),
              Introduction2(),
              Introduction3(),
            ],
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Align(
              alignment: const Alignment(0, 0.8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  /// SKIP
                  GestureDetector(
                    onTap: () {
                      _controller.jumpToPage(2);
                    },
                    child: const Text(
                      "Sauter",
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 15,
                        shadows: [
                          Shadow(
                            color: Colors.black,
                            offset: Offset(1, 0),
                          )
                        ],
                        letterSpacing: 3,
                      ),
                    ),
                  ),

                  /// INDICATOR
                  SmoothPageIndicator(
                    controller: _controller,
                    count: 3,
                  ),

                  /// NEXT / DONE
                  onLastPage
                      ? GestureDetector(
                    onTap: () async {
                      final prefs =
                      await SharedPreferences.getInstance();

                      /// 🔥 ONBOARDING TERMINE
                      await prefs.setBool(
                          'hasSeenOnboarding', true);

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LanguagePage(),
                        ),
                      );
                    },
                    child: const Text(
                      "Acceder",
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 15,
                        shadows: [
                          Shadow(
                            color: Colors.black,
                            offset: Offset(1, 0),
                          )
                        ],
                        letterSpacing: 3,
                      ),
                    ),
                  )
                      : GestureDetector(
                    onTap: () {
                      _controller.nextPage(
                        duration:
                        const Duration(milliseconds: 500),
                        curve: Curves.easeIn,
                      );
                    },
                    child: const Text(
                      "Suivant",
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 15,
                        shadows: [
                          Shadow(
                            color: Colors.black,
                            offset: Offset(1, 0),
                          )
                        ],
                        letterSpacing: 3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}