import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';
import '../api/translation.dart';
import '../provider/provider.dart';

class Preferences extends StatefulWidget {
  const Preferences({Key? key}) : super(key: key);

  @override
  State<Preferences> createState() => _PreferencesState();
}

class _PreferencesState extends State<Preferences> {
  bool showLanguages = false;
  List checkListItems = [];
  List multipleSelected = [];
  late Future<List> languagesFuture;

  List mine = [
    {
      'id': 0,
      'value': true,
      'title': 'Afrikaans',
      'code': 'af',
    },
    {
      'id': 1,
      'value': true,
      'title': 'English',
      'code': 'en',
    },
    {
      'id': 2,
      'value': true,
      'title': 'Zulu',
      'code': 'zu',
    },
    {
      'id': 3,
      'value': true,
      'title': 'Xhosa',
      'code': 'xh',
    },
    {
      'id': 4,
      'value': true,
      'title': 'Sesotho',
      'code': 'st',
    },
    {
      'id': 5,
      'value': true,
      'title': 'Sepedi',
      'code': 'nso',
    },
    {
      'id': 6,
      'value': true,
      'title': 'Tsonga',
      'code': 'ts',
    },
  ];

  @override
  void initState() {
    super.initState();
    languagesFuture = initLanguages();
    readSelectedLanguages();
  }

  Future<List> initLanguages() async {
    final availableLanguages = await TranslationService().getAvailableLanguages();
    for (var item in availableLanguages) {
      for (var item2 in multipleSelected) {
        if (item['code'] == item2['code'] && item2['value'] == true) {
          item['value'] = true;
        }
      }
    }
    return availableLanguages;
  }

  void saveSelectedLanguages() async {
    try {
      List<DropdownMenuItem<String>> languages = [];
      for (var language in multipleSelected) {
        if (language['value'] == true) {
          languages.add(
            DropdownMenuItem<String>(
              value: language['code'],
              child: Text(language['title']),
            ),
          );
        }
      }
      Provider.of<MainProvider>(context, listen: false).updateLanguages(languages);
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/selected_languages.json');
      final jsonData = jsonEncode(multipleSelected);
      await file.writeAsString(jsonData);
    } catch (e) {
      print(e);
    }
  }

  void clearFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/selected_languages.json');
    file.writeAsStringSync('');
  }

  void readSelectedLanguages() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/selected_languages.json');
      if (file.existsSync()) {
        final jsonData = await file.readAsString();
        final selectedLanguages = jsonDecode(jsonData);
        multipleSelected = List<Map<String, dynamic>>.from(selectedLanguages);
      } else {
        multipleSelected = mine;
      }
    } catch (e) {
      multipleSelected = mine;
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MainProvider>(context);
    bool isDarkMode = provider.isDarkMode;

    if (showLanguages) {
      return FutureBuilder<List>(
        future: languagesFuture,
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Display a loading indicator while waiting for data
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Handle error case
            return Text('Error: ${snapshot.error}');
          } else {
            // Data has been loaded successfully, display the ListView.builder
            checkListItems = snapshot.data!;

            return Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios_new_sharp,
                        color: isDarkMode ? Colors.grey : Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          showLanguages = false;
                        });
                      },
                    ),
                    Text(
                      'Preferences',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 16,
                        color: isDarkMode ? Colors.grey : Colors.white,
                      ),
                    ),
                  ],
                ),
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.only(left: 36.0),
                    // Adjust the padding value as needed
                    child: ListView.builder(
                      itemCount: checkListItems.length,
                      itemBuilder: (context, index) => CheckboxListTile(
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        title: Text(
                          checkListItems[index]['title'],
                          style: TextStyle(
                            fontSize: 14.0,
                            color: isDarkMode ? Colors.grey : Colors.white,
                          ),
                        ),
                        value: checkListItems[index]['value'],
                        onChanged: (value) {
                          setState(() {
                            checkListItems[index]['value'] = value;
                            final languageCode = checkListItems[index]['code'];
                            multipleSelected.removeWhere((item) => item['code'] == languageCode);
                            multipleSelected.add(checkListItems[index]);
                            saveSelectedLanguages();
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      );
    } else {
      return SettingsList(
        darkTheme: SettingsThemeData(
          settingsListBackground: Theme.of(context).canvasColor,
        ),
        lightTheme: SettingsThemeData(
          settingsListBackground: Theme.of(context).canvasColor,
        ),
        sections: [
          SettingsSection(
            title: const Text(
              'Preferences',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            tiles: <SettingsTile>[
              SettingsTile.switchTile(
                activeSwitchColor: Theme.of(context).cardColor,
                onToggle: (value) {
                  setState(() {
                    provider.updateMode(value);
                  });
                },
                initialValue: provider.isDarkMode,
                leading: const Icon(Icons.nightlight_round_sharp, color: Colors.white),
                title: const Text(
                  'Dark mode',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              SettingsTile(
                onPressed: (context) {
                  setState(() {
                    showLanguages = true;
                  });
                },
                title: const Text(
                  'Target Languages',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                description: Text(
                  'Add or remove languages to target languages',
                  style: TextStyle(fontSize: 12, color: isDarkMode ? Colors.grey : Colors.white),
                ),
                leading: const Icon(Icons.language_sharp, color: Colors.white),
                trailing: Icon(
                  Icons.arrow_forward_ios_sharp,
                  color: isDarkMode ? Colors.grey : Colors.white,
                ),
              ),
            ],
          ),
        ],
      );
    }
  }
}

