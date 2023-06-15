import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:moafrika_translate/provider/provider.dart';
import 'package:moafrika_translate/api/translation.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'api/speech.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late BannerAd _bannerAd;
  bool _isAdLoaded = false;
  String _targetLanguage = 'ts';
  String output = '';
  final text = TextEditingController();
  bool isListening = false;
  int navIndex = 0;

  List<DropdownMenuItem<String>> languages = [];

  final screens = <Widget>[
    Center(child: Text('Affiliate'),),
    Center(child: Text('Support'),),
    Center(child: Text('Preferences'),),
  ];

  List<DropdownMenuItem<String>> getLanguages() {
    List<DropdownMenuItem<String>> languages = [];

    languages.add(
      const DropdownMenuItem(
        value: 'af',
        child: Text('Afrikaans'),
      ),
    );

    languages.add(
      const DropdownMenuItem(
        value: 'en',
        child: Text('English'),
      ),
    );

    languages.add(
      const DropdownMenuItem(
        value: 'zu',
        child: Text('Zulu'),
      ),
    );

    languages.add(
      const DropdownMenuItem(
        value: 'xh',
        child: Text('Xhosa'),
      ),
    );

    languages.add(
      const DropdownMenuItem(
        value: 'st',
        child: Text('Sesotho'),
      ),
    );

    languages.add(
      const DropdownMenuItem(
        value: 'nso',
        child: Text('Sepedi'),
      ),
    );

    languages.add(
      const DropdownMenuItem(
        value: 'ts',
        child: Text('Xitsonga'),
      ),
    );

    languages.add(
      const DropdownMenuItem(
        value: 'sw',
        child: Text('Swahili'),
      ),
    );

    languages.add(
      const DropdownMenuItem(
        value: 'ig',
        child: Text('Igbo'),
      ),
    );

    languages.add(
      const DropdownMenuItem(
        value: 'ha',
        child: Text('Hausa'),
      ),
    );

    languages.add(
      const DropdownMenuItem(
        value: 'rw',
        child: Text('Kinyarwanda'),
      ),
    );

    languages.add(
      const DropdownMenuItem(
        value: 'ny',
        child: Text('Chichewa'),
      ),
    );

    languages.add(
      const DropdownMenuItem(
        value: 'so',
        child: Text('Somali'),
      ),
    );

    languages.add(
      const DropdownMenuItem(
        value: 'mg',
        child: Text('Malagasy'),
      ),
    );

    languages.add(
      const DropdownMenuItem(
        value: 'ar',
        child: Text('Arabic'),
      ),
    );

    languages.add(
      const DropdownMenuItem(
        value: 'am',
        child: Text('Amharic'),
      ),
    );

    languages.add(
      const DropdownMenuItem(
        value: 'yo',
        child: Text('Yoruba'),
      ),
    );

    return languages;
  }

  Future<String> translate(String language, String text) async {
    return await TranslationService().translate(text, language);
  }

  @override
  void initState() {
    super.initState();
    _initBannerAd();
    languages = getLanguages();
  }

  void _initBannerAd() {
    _bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: 'ca-app-pub-7872743903266632/2297626474',
        listener: BannerAdListener(onAdLoaded: (ad) {
          setState(() {
            _isAdLoaded = true;
          });
        }, onAdFailedToLoad: (ad, error) {
          print(error);
        }),
        request: const AdRequest());

    _bannerAd.load();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MainProvider>(context);
    bool isDarkMode = provider.isDarkMode;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(MediaQuery.of(context).size.width-20, 60),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: AppBar(
            backgroundColor: isDarkMode ? Theme.of(context).cardColor : Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20.0),
              ),
            ),
            title: Column(
              children: [
                Image.asset(
                  'assets/africa.png',
                  width: 24,
                  height: 24,
                  color: Colors.green,
                ),
                /*Text(
                  'MoAfrika-Translate',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),*/
              ],
            ),
            centerTitle: true,
            actions: [
              PopupMenuButton<String>(
                icon: Icon(
                  Icons.more_vert,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
                onSelected: (value) {
                  if (value == 'about') {
                    // Handle "About" menu item
                    showAboutDialog(
                      context: context,
                      applicationIcon: Image.asset(
                        'assets/africa.png',
                        width: 24,
                        height: 24,
                        color: Colors.green,
                      ),
                      applicationName: 'MoAfrika-Translate',
                      children: [
                        const Text('An application for translating African languages.\n\nCreated by Sthembiso Vinjwa.\n'),
                        const Text('App icon credit: Freepik'),
                      ],
                      applicationVersion: '1.0.0',
                      // Add more information as needed
                    );
                  } else if (value == 'close') {
                    // Handle "Close" menu item
                    SystemNavigator.pop();
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem<String>(
                    value: 'about',
                    child: ListTile(
                      leading: Icon(Icons.info),
                      title: Text('About'),
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'close',
                    child: ListTile(
                      leading: Icon(Icons.exit_to_app_rounded),
                      title: Text('Close'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 12.0, right: 12.0, bottom: 12.0),
        child: Container(
          decoration: BoxDecoration(
            color: isDarkMode ? Theme.of(context).cardColor : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDarkMode ? Theme.of(context).cardColor : Colors.white,
              width: 1.0,
            ),
          ),
          child: NavigationBarTheme(
            data: NavigationBarThemeData(
              backgroundColor: Colors.transparent,
              indicatorColor: isDarkMode ? Theme.of(context).cardColor : Colors.white,
              labelTextStyle: MaterialStateProperty.all(
                TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ),
            child: NavigationBar(
              labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
              animationDuration: const Duration(seconds: 2),
              height: 60,
              selectedIndex: navIndex,
              onDestinationSelected: (index) => setState(() => navIndex = index),
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home, color: Colors.green),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.local_offer, color: Colors.green),
                  label: 'Affiliate',
                ),
                NavigationDestination(
                  icon: Icon(Icons.volunteer_activism, color: Colors.green),
                  label: 'Support',
                ),
                NavigationDestination(
                  icon: Icon(Icons.dashboard, color: Colors.green),
                  label: 'Preferences',
                ),
              ],
            ),
          ),
        ),
      ),
      body: navIndex == 0 ? Container(
        padding: const EdgeInsets.all(0.0),
        alignment: Alignment.center,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          margin: const EdgeInsets.all(12),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Text(
                  'Enter the Text/Voice input to translate, choose the language, and click Translate',
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 120,
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                ),
                child: TextField(
                  style: const TextStyle(fontSize: 14.0),
                  controller: text,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter text',
                  ),
                  maxLines: 5, // Adjust the maximum number of lines as needed
                ),
              ),
              SizedBox(
                height: 40,
                child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  InkWell(
                    splashColor: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                    onTap: () {
                      setState(() {
                        text.text = '';
                      });
                    },
                    child: Row(
                      children: [
                        const Icon(
                          Icons.delete,
                          color: Colors.grey,
                          size: 25,
                        ),
                        Text('Clear',
                            style: TextStyle(
                                color:
                                    isDarkMode ? Colors.grey : Colors.black87)),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  InkWell(
                    splashColor: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                    onTap: toggleRecording,
                    child: Row(
                      children: [
                        AvatarGlow(
                            animate: isListening,
                            endRadius: 15,
                            child: Icon(
                              isListening ? Icons.mic : Icons.mic_none,
                              color: Colors.grey,
                              size: 25,
                            )),
                        const SizedBox(width: 2),
                        Text(
                          'Voice input',
                          style: TextStyle(
                              color: isDarkMode ? Colors.grey : Colors.black87),
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text('Target language:'),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 45,
                child: DropdownButtonFormField<String>(
                  style: const TextStyle(fontSize: 14),
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(5),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                  ),
                  items: languages,
                  value: _targetLanguage,
                  onChanged: (String? value) {
                    if (value is String) {
                      _targetLanguage = value;
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 40,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0.0,
                    foregroundColor: Colors.grey,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.green),
                      borderRadius: BorderRadius.circular(8),
                    ), // Text color
                  ),
                  onPressed: () async {
                    String _text = await translate(_targetLanguage, text.text);
                    setState(() {
                      output = _text;
                      if (output.isEmpty) {
                        showMessage(
                            'Make sure that you have internet connection.',
                            'Something went wrong');
                      }
                    });
                  },
                  child: const Text(
                    'Translate',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: 120,
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: AnimatedTextKit(
                      key: UniqueKey(),
                      animatedTexts: [
                        TyperAnimatedText(output),
                      ],
                      isRepeatingAnimation: false,
                      onTap: () {
                        print("Tap Event");
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 40,
                child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  const Text('Dark mode'),
                  Switch(
                    activeTrackColor: Colors.grey,
                    activeColor: Colors.black87,
                    value: Provider.of<MainProvider>(context, listen: false)
                        .isDarkMode,
                    onChanged: (bool value) {
                      setState(() {
                        Provider.of<MainProvider>(context, listen: false)
                            .updateMode(value);
                      });
                    },
                  ),
                  Spacer(),
                  InkWell(
                    splashColor: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                    onTap: () async {
                      await Clipboard.setData(ClipboardData(text: output));
                    },
                    child: Row(
                      children: [
                        const Icon(Icons.content_copy, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          'Copy',
                          style: TextStyle(
                              color: isDarkMode ? Colors.grey : Colors.black87),
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
              /*Row(
                children: [
                  SizedBox(
                    height: 40,
                    child: ElevatedButton.icon(
                      icon: const Icon(
                        Icons.coffee_rounded,
                        color: Colors.white,
                      ),
                      style: ElevatedButton.styleFrom(
                        elevation: 0.0,
                        foregroundColor: Colors.grey,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(color: Colors.green),
                          borderRadius: BorderRadius.circular(8),
                        ), // Text color
                      ),
                      onPressed: () async {
                        _launchURL('https://www.buymeacoffee.com/vinjwacr7e');
                      },
                      label: const Text(
                        'Buy me a coffee',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),*/
              const SizedBox(
                height: 5,
              ),
              if (_isAdLoaded)
                SizedBox(
                  height: _bannerAd.size.height.toDouble(),
                  width: _bannerAd.size.width.toDouble(),
                  child: AdWidget(
                    ad: _bannerAd,
                  ),
                ),
            ],
          ),
        ),
      ) :
      screens[navIndex-1],
    );
  }

  Future toggleRecording() => SpeechApi.toggleRecording(
        onResult: (text) => setState(() => this.text.text = text),
        onListening: (isListening) {
          setState(() => this.isListening = isListening);
        },
      );

  void showMessage(String message, String title) {
    AlertDialog inputFail = AlertDialog(
      title: Text(
        title,
        //style: TextStyle(color: global.aColor),
      ),
      content: Text(message, style: const TextStyle()),
      actions: [
        ElevatedButton(
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.green)),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              'Ok',
              style: TextStyle(),
            )),
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return inputFail;
      },
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
