import 'package:anitrak/src/app.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({Key? key, this.onDone}) : super(key: key);

  final void Function()? onDone;

  @override
  Widget build(BuildContext context) {
    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: TextStyle(fontSize: 19.0),
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      imagePadding: EdgeInsets.all(20),
      imageAlignment: Alignment.bottomCenter,
    );

    return IntroductionScreen(
      isTopSafeArea: true,
      pages: [
        PageViewModel(
            image: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset('images/progress.png'),
            ),
            title: 'Track your shows',
            body: 'Keep track all your Anime by adding them to your library.',
            decoration: pageDecoration),
         PageViewModel(
            image: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset('images/sync.png'),
            ),
            title: 'Sync',
            body: 'Sync your library with your favourite tracking service.',
            footer: const Text(
              'Only supports Anilist for now. Kitsu and MyAnimeList support is planned to be added in the future.',
              textAlign: TextAlign.center,
            ),
            decoration: pageDecoration),
        PageViewModel(
            image: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset('images/stats.png'),
            ),
            title: 'Stats',
            body:
                'Get insightful metrics on status, time and more for your library.',
            decoration: pageDecoration),
        PageViewModel(
            image: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset('images/warning.png'),
            ),
            title: 'This app is stll under construction.',
            body:
                'Please be mindful that there may be a few bugs while using the app..',
            decoration: pageDecoration),
      ],
      onDone: () {
        if(onDone != null){
          onDone!();
        }
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return const App();
            },
          ),
        );
      },
      // showSkipButton: true,
      showBackButton: true,
      skip: const Icon(Icons.skip_next),
      next: const Icon(Icons.arrow_forward),
      back: const Icon(Icons.arrow_back),
      done: const Text("Done",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
      dotsDecorator: DotsDecorator(
        size: const Size.square(10.0),
        activeSize: const Size(20.0, 10.0),
        activeColor: Colors.red,
        color: Colors.grey,
        spacing: const EdgeInsets.symmetric(horizontal: 3.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
      ),
    );
  }
}
