import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:womentech/ONBOARDING/introductionPage/introduction1.dart';
import 'package:womentech/ONBOARDING/introductionPage/introduction2.dart';
import 'package:womentech/ONBOARDING/introductionPage/introduction3.dart';
import 'package:womentech/splashscreen.dart';

class Onboradingscreen extends StatefulWidget {
  const Onboradingscreen({super.key});

  @override
  State<Onboradingscreen> createState() => _OnboradingscreenState();
}

class _OnboradingscreenState extends State<Onboradingscreen> {
  PageController _controller = PageController();
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
            child: Container(
              alignment: const Alignment(0, 0.9),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      _controller.jumpToPage(2);
                    },
                    child: const Text(
                      "Skip",
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
                  SmoothPageIndicator(
                    controller: _controller,
                    count: 3,
                  ),
                  onLastPage
                      ? GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                          const SplashScreen(),
                        ),
                      );
                    },
                    child: const Text("Done",
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
              ),),
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
                      "Next",
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