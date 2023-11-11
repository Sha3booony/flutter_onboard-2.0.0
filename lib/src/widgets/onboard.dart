import 'package:flutter/material.dart';
import 'package:flutter_onboard/flutter_onboard.dart';
import 'package:flutter_onboard/src/contants/constants.dart';
import 'package:flutter_onboard/src/models/onboard_state_model.dart';
import 'package:flutter_onboard/src/models/page_indicator_style_model.dart';
import 'package:flutter_onboard/src/providers/providers.dart';
import 'package:flutter_onboard/src/widgets/page_indicator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';

class OnBoard extends HookConsumerWidget {
  /// Data for OnBoard [List<OnBoardModel>]
  /// @Required
  final List<OnBoardModel> onBoardData;

  /// OnTapping skip button action
  final VoidCallback? onSkip;

  /// OnTapping done button action
  final VoidCallback? onDone;

  /// Controller for [PageView]
  /// @Required
  final PageController pageController;

  /// Title text style
  final TextStyle? titleStyles;

  /// Description text style
  final TextStyle? descriptionStyles;

  /// OnBoard Image width
  final double? imageWidth;

  /// OnBoard Image height
  final double? imageHeight;

  /// Skip Button Widget
  final Widget? skipButton;

  /// Next Button Widget
  final Widget? nextButton;

  /// Animation [Duration] for transition from one page to another
  /// @Default [Duration(milliseconds:250)]
  final Duration duration;

  /// [Curve] used for animation
  /// @Default [Curves.easeInOut]
  final Curve curve;

  /// [PageIndicatorStyle] dot styles
  final PageIndicatorStyle pageIndicatorStyle;

  const OnBoard({
    Key? key,
    required this.onBoardData,
    this.onSkip,
    this.onDone,
    required this.pageController,
    this.titleStyles,
    this.descriptionStyles,
    this.imageWidth,
    this.imageHeight,
    this.skipButton,
    this.nextButton,
    this.duration = const Duration(milliseconds: 250),
    this.curve = Curves.easeInOut,
    this.pageIndicatorStyle = const PageIndicatorStyle(
        width: 150,
        activeColor: Colors.blue,
        inactiveColor: Colors.blueAccent,
        activeSize: Size(12, 12),
        inactiveSize: Size(8, 8)),
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProviderScope(
      child: _OnBoard(
        onBoardData: onBoardData,
        pageController: pageController,
        onSkip: onSkip,
        onDone: onDone,
        titleStyles: titleStyles,
        descriptionStyles: descriptionStyles,
        imageWidth: imageWidth,
        imageHeight: imageHeight,
        skipButton: skipButton,
        nextButton: nextButton,
        duration: duration,
        curve: curve,
        pageIndicatorStyle: pageIndicatorStyle,
      ),
    );
  }
}

class _OnBoard extends HookConsumerWidget {
  /// Data for OnBoard [List<OnBoardModel>]
  /// @Required
  final List<OnBoardModel> onBoardData;

  /// OnTapping skip button action
  final VoidCallback? onSkip;

  /// OnTapping done button action
  final VoidCallback? onDone;

  /// Controller for [PageView]
  /// @Required
  final PageController pageController;

  /// Title text style
  final TextStyle? titleStyles;

  /// Description text style
  final TextStyle? descriptionStyles;

  /// OnBoard Image width
  final double? imageWidth;

  /// OnBoard Image height
  final double? imageHeight;

  /// Skip Button Widget
  final Widget? skipButton;

  /// Next Button Widget
  final Widget? nextButton;

  /// Animation [Duration] for transition from one page to another
  /// @Default [Duration(milliseconds:250)]
  final Duration duration;

  /// [Curve] used for animation
  /// @Default [Curves.easeInOut]
  final Curve curve;

  /// [PageIndicatorStyle] dot styles
  final PageIndicatorStyle pageIndicatorStyle;

  const _OnBoard({
    Key? key,
    required this.onBoardData,
    this.onSkip,
    this.onDone,
    required this.pageController,
    this.titleStyles,
    this.descriptionStyles,
    this.imageWidth,
    this.imageHeight,
    this.skipButton,
    this.nextButton,
    this.duration = const Duration(milliseconds: 250),
    this.curve = Curves.easeInOut,
    this.pageIndicatorStyle = const PageIndicatorStyle(
        width: 150,
        activeColor: Colors.blue,
        inactiveColor: Colors.blueAccent,
        activeSize: Size(12, 12),
        inactiveSize: Size(8, 8)),
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onBoardState = ref.watch(onBoardStateProvider);
    final onBoardStateNotifier = ref.watch(onBoardStateProvider.notifier);

    final screenSize = MediaQuery.of(context).size;
    final double pageViewHeight = screenSize.height -
        skipContainerHeight -
        footerContentHeight -
        pageIndicatorHeight -
        85.0;

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              // height: skipContainerHeight,
              alignment: Alignment.centerRight,
              child: skipButton ??
                  TextButton(
                    onPressed: () => _onSkipPressed(onSkip),
                    child: const Text(
                      "Skip",
                      style: TextStyle(color: Colors.blueAccent),
                    ),
                  ),
            ),
            SizedBox(
              child: PageView.builder(
                controller: pageController,
                onPageChanged: (page) => onBoardStateNotifier.onPageChanged(
                    page, onBoardData.length),
                itemCount: onBoardData.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: <Widget>[
                      SizedBox(
                          height: imageHeight * 0.7,
                          width: imageWidth  * 0.7,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.15),
                            child: Lottie.asset(onBoardData[index].imgUrl),
                          )),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          onBoardData[index].title,
                          textAlign: TextAlign.center,
                          style: titleStyles ??
                              const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                      Container(
                        padding:
                            const EdgeInsets.only(top: 12, right: 4, left: 4),
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          onBoardData[index].description,
                          textAlign: TextAlign.center,
                          style: descriptionStyles ??
                              const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            SizedBox(
              height: pageIndicatorHeight,
              child: PageIndicator(
                count: onBoardData.length,
                activePage: onBoardState.page,
                pageIndicatorStyle: pageIndicatorStyle,
              ),
            ),
            SizedBox(
              height: 8,
            )
            // Container(
            //   height: footerContentHeight,
            //   width: screenSize.width,
            //   alignment: Alignment.center,
            //   child: ButtonTheme(
            //     minWidth: 230,
            //     height: 50,
            //     child: nextButton != null
            //         ? nextButton!
            //         : ElevatedButton(
            //       style: ElevatedButton.styleFrom(
            //         shape: const StadiumBorder(),
            //         elevation: 0,
            //       ),
            //       onPressed: () => _onNextTap(onBoardState),
            //       child: Text(
            //         onBoardState.isLastPage ? "Done" : "Next",
            //         style: const TextStyle(color: Colors.white),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  void _onNextTap(OnBoardState state) {
    if (!state.isLastPage) {
      pageController.animateToPage(
        state.page + 1,
        duration: duration,
        curve: curve,
      );
    } else {
      if (onDone == null) {
        throw Exception(
            'Either provide "onDone" callback or add "nextButton" Widget to "OnBoard" Widget to handle done state');
      } else {
        onDone!();
      }
    }
  }

  void _onSkipPressed(VoidCallback? onSkip) {
    if (onSkip == null) {
      throw Exception(
          'Either provide "onSkip" callback or add "skipButton" Widget to "OnBoard" Widget to handle skip state');
    } else {
      onSkip();
    }
  }
}
