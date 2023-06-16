import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../provider/provider.dart';

class SupportPage extends StatefulWidget {

  SupportPage({Key? key}) : super(key: key);

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  InterstitialAd? _interstitialAd;

  bool _isAdLoaded = false;

  void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-7872743903266632/7797590505',
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          setState(() {
            _interstitialAd?.dispose(); // Dispose previous ad if any
            _interstitialAd = ad;
            _isAdLoaded = true;

            _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
              onAdDismissedFullScreenContent: (ad) {
                _interstitialAd!.dispose();
                loadInterstitialAd(); // Load a new ad after it's dismissed
              },
              onAdFailedToShowFullScreenContent: (ad, error) {
                _interstitialAd!.dispose();
                loadInterstitialAd(); // Load a new ad if failed to show
              },
            );
          });
        },
        onAdFailedToLoad: (error) {
          print('Failed to load interstitial ad: $error');
        },
      ),
    );
  }

  void showInterstitialAd() {
    if (_isAdLoaded) {
      _interstitialAd?.show();
      _isAdLoaded = false;
    } else {
      print('Interstitial ad is not loaded yet.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MainProvider>(context);
    bool isDarkMode = provider.isDarkMode;
    loadInterstitialAd();

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Choose how to support us:',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 40,
                  child: ElevatedButton.icon(
                    icon: Icon(
                      Icons.coffee_rounded,
                      color: isDarkMode ? Colors.white : Colors.green,
                    ),
                    style: ElevatedButton.styleFrom(
                      elevation: 0.0,
                      foregroundColor: Colors.grey,
                      backgroundColor: isDarkMode ? Colors.green : Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: isDarkMode ? Colors.green : Colors.white),
                        borderRadius: BorderRadius.circular(8),
                      ), // Text color
                    ),
                    onPressed: () async {
                      _launchURL('https://www.buymeacoffee.com/vinjwacr7e');
                    },
                    label: Text(
                      'Buy me a coffee',
                      style: TextStyle(
                          fontSize: 16,
                          color: isDarkMode ? Colors.white : Colors.green),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              'Or',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 40,
                  child: ElevatedButton.icon(
                    icon: Icon(
                      Icons.play_circle_filled,
                      color: isDarkMode ? Colors.white : Colors.green,
                    ),
                    style: ElevatedButton.styleFrom(
                      elevation: 0.0,
                      foregroundColor: Colors.grey,
                      backgroundColor: _isAdLoaded ? (isDarkMode ? Colors.green : Colors.white) : Colors.grey,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: _isAdLoaded ? (isDarkMode ? Colors.green : Colors.white)  : Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ), // Text color
                    ),
                    onPressed: () {
                      if (_isAdLoaded) {
                        showInterstitialAd();
                      }
                    },
                    label: Text(
                      'Watch Ads',
                      style: TextStyle(
                          fontSize: 16,
                          color: isDarkMode ? Colors.white : Colors.green),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'For business/collaboration email us at:',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(height: 10),
            const SelectableText(
              'vinjwacr7@gmail.com',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    Uri site = Uri.parse(url);
    if (await canLaunchUrl(site)) {
      await launchUrl(site);
    } else {
      throw 'Could not launch $url';
    }
  }
}
