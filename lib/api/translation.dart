import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class TranslationService {
  Future<String> translate(String text, String targetLanguage) async {
    try {
      final apiKey = dotenv.env['API_KEY'];
      final apiUrl =
          'https://translation.googleapis.com/language/translate/v2?key=$apiKey';

      final response = await http.post(Uri.parse(apiUrl), body: {
        'q': text,
        'target': targetLanguage,
      }).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final translatedText = jsonDecode(response.body)['data']['translations'][0]['translatedText'];
        return translatedText;
      } else {
        throw Exception('Failed to translate text. HTTP status code: ${response.statusCode}');
      }
    } catch (e) {
      return '';
    }
  }

  Future<List<Map<String, dynamic>>> getAvailableLanguages() async {
    try {
      final apiKey = dotenv.env['API_KEY'];
      final apiUrl =
          'https://translation.googleapis.com/language/translate/v2/languages?key=$apiKey';

      final response =
      await http.get(Uri.parse(apiUrl)).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['data'];
        final languages = data['languages'] as List<dynamic>;

        final checkListItems = languages.map((language) {
          final String languageCode = language['language'];
          final String languageName = getLanguageName(languageCode);

          if (languageName.isEmpty) {
            print('$languageCode');
          }

          return {
            'id': languages.indexOf(language),
            'value': false,
            'title': languageName.isNotEmpty ? languageName : languageCode,
            'code': languageCode,
          };
        }).toList();

        return checkListItems;
      } else {
        throw Exception(
            'Failed to retrieve available languages. HTTP status code: ${response.statusCode}');
      }
    } catch (e) {
      return [];
    }
  }

  String getLanguageName(String languageCode) {
    switch (languageCode) {
      case 'af':
        return 'Afrikaans';
      case 'ak':
        return 'Akan';
      case 'sq':
        return 'Albanian';
      case 'am':
        return 'Amharic';
      case 'ar':
        return 'Arabic';
      case 'hy':
        return 'Armenian';
      case 'az':
        return 'Azerbaijani';
      case 'eu':
        return 'Basque';
      case 'be':
        return 'Belarusian';
      case 'bem':
        return 'Bemba';
      case 'bn':
        return 'Bengali';
      case 'bh':
        return 'Bihari';
      case 'xx-bork':
        return 'Bork, bork, bork!';
      case 'bs':
        return 'Bosnian';
      case 'br':
        return 'Breton';
      case 'bg':
        return 'Bulgarian';
      case 'km':
        return 'Cambodian';
      case 'ca':
        return 'Catalan';
      case 'chr':
        return 'Cherokee';
      case 'ny':
        return 'Chichewa';
      case 'zh-CN':
        return 'Chinese (Simplified)';
      case 'zh-TW':
        return 'Chinese (Traditional)';
      case 'co':
        return 'Corsican';
      case 'hr':
        return 'Croatian';
      case 'cs':
        return 'Czech';
      case 'da':
        return 'Danish';
      case 'nl':
        return 'Dutch';
      case 'xx-elmer':
        return 'Elmer Fudd';
      case 'en':
        return 'English';
      case 'eo':
        return 'Esperanto';
      case 'et':
        return 'Estonian';
      case 'ee':
        return 'Ewe';
      case 'fo':
        return 'Faroese';
      case 'tl':
        return 'Filipino';
      case 'fi':
        return 'Finnish';
      case 'fr':
        return 'French';
      case 'fy':
        return 'Frisian';
      case 'gaa':
        return 'Ga';
      case 'gl':
        return 'Galician';
      case 'ka':
        return 'Georgian';
      case 'de':
        return 'German';
      case 'el':
        return 'Greek';
      case 'gn':
        return 'Guarani';
      case 'gu':
        return 'Gujarati';
      case 'xx-hacker':
        return 'Hacker';
      case 'ht':
        return 'Haitian Creole';
      case 'ha':
        return 'Hausa';
      case 'haw':
        return 'Hawaiian';
      case 'iw':
        return 'Hebrew';
      case 'hi':
        return 'Hindi';
      case 'hu':
        return 'Hungarian';
      case 'is':
        return 'Icelandic';
      case 'ig':
        return 'Igbo';
      case 'id':
        return 'Indonesian';
      case 'ia':
        return 'Interlingua';
      case 'ga':
        return 'Irish';
      case 'it':
        return 'Italian';
      case 'ja':
        return 'Japanese';
      case 'jw':
        return 'Javanese';
      case 'kn':
        return 'Kannada';
      case 'kk':
        return 'Kazakh';
      case 'rw':
        return 'Kinyarwanda';
      case 'rn':
        return 'Kirundi';
      case 'xx-klingon':
        return 'Klingon';
      case 'kg':
        return 'Kongo';
      case 'ko':
        return 'Korean';
      case 'kri':
        return 'Krio (Sierra Leone)';
      case 'ku':
        return 'Kurdish';
      case 'ckb':
        return 'Kurdish (Soranî)';
      case 'ky':
        return 'Kyrgyz';
      case 'lo':
        return 'Laothian';
      case 'la':
        return 'Latin';
      case 'lv':
        return 'Latvian';
      case 'ln':
        return 'Lingala';
      case 'lt':
        return 'Lithuanian';
      case 'loz':
        return 'Lozi';
      case 'lg':
        return 'Luganda';
      case 'ach':
        return 'Luo';
      case 'mk':
        return 'Macedonian';
      case 'mg':
        return 'Malagasy';
      case 'ms':
        return 'Malay';
      case 'ml':
        return 'Malayalam';
      case 'mt':
        return 'Maltese';
      case 'mi':
        return 'Maori';
      case 'mr':
        return 'Marathi';
      case 'mfe':
        return 'Mauritian Creole';
      case 'mo':
        return 'Moldavian';
      case 'mn':
        return 'Mongolian';
      case 'sr-ME':
        return 'Montenegrin';
      case 'ne':
        return 'Nepali';
      case 'pcm':
        return 'Nigerian Pidgin';
      case 'nso':
        return 'Sepedi';
      case 'ny':
        return 'Chichewa';
      case 'no':
        return 'Norwegian';
      case 'nn':
        return 'Norwegian (Nynorsk)';
      case 'oc':
        return 'Occitan';
      case 'or':
        return 'Oriya';
      case 'om':
        return 'Oromo';
      case 'ps':
        return 'Pashto';
      case 'fa':
        return 'Persian';
      case 'xx-pirate':
        return 'Pirate';
      case 'pl':
        return 'Polish';
      case 'pt-BR':
        return 'Portuguese (Brazil)';
      case 'pt-PT':
        return 'Portuguese (Portugal)';
      case 'pa':
        return 'Punjabi';
      case 'qu':
        return 'Quechua';
      case 'ro':
        return 'Romanian';
      case 'rm':
        return 'Romansh';
      case 'nyn':
        return 'Runyakitara';
      case 'ru':
        return 'Russian';
      case 'gd':
        return 'Scots Gaelic';
      case 'sr':
        return 'Serbian';
      case 'sh':
        return 'Serbo-Croatian';
      case 'st':
        return 'Sesotho';
      case 'tn':
        return 'Setswana';
      case 'crs':
        return 'Seychellois Creole';
      case 'sn':
        return 'Shona';
      case 'sd':
        return 'Sindhi';
      case 'si':
        return 'Sinhalese';
      case 'sk':
        return 'Slovak';
      case 'sl':
        return 'Slovenian';
      case 'so':
        return 'Somali';
      case 'es':
        return 'Spanish';
      case 'es-419':
        return 'Spanish (Latin American)';
      case 'su':
        return 'Sundanese';
      case 'sw':
        return 'Swahili';
      case 'sv':
        return 'Swedish';
      case 'tg':
        return 'Tajik';
      case 'ta':
        return 'Tamil';
      case 'tt':
        return 'Tatar';
      case 'te':
        return 'Telugu';
      case 'th':
        return 'Thai';
      case 'ti':
        return 'Tigrinya';
      case 'to':
        return 'Tonga';
      case 'lua':
        return 'Tshiluba';
      case 'tum':
        return 'Tumbuka';
      case 'tr':
        return 'Turkish';
      case 'tk':
        return 'Turkmen';
      case 'tw':
        return 'Twi';
      case 'ug':
        return 'Uighur';
      case 'uk':
        return 'Ukrainian';
      case 'ur':
        return 'Urdu';
      case 'uz':
        return 'Uzbek';
      case 'vi':
        return 'Vietnamese';
      case 'cy':
        return 'Welsh';
      case 'wo':
        return 'Wolof';
      case 'xh':
        return 'Xhosa';
      case 'yi':
        return 'Yiddish';
      case 'yo':
        return 'Yoruba';
      case 'zu':
        return 'Zulu';
      case 'af':
        return 'Afrikaans';
      case 'as':
        return 'Assamese';
      case 'ay':
        return 'Aymara';
      case 'bho':
        return 'Bhojpuri';
      case 'bm':
        return 'Bambara';
      case 'ceb':
        return 'Cebuano';
      case 'doi':
        return 'Dogri';
      case 'dv':
        return 'Dhivehi';
      case 'gom':
        return 'Goan Konkani';
      case 'he':
        return 'Hebrew';
      case 'hmn':
        return 'Hmong';
      case 'ilo':
        return 'Iloko';
      case 'jv':
        return 'Javanese';
      case 'lb':
        return 'Luxembourgish';
      case 'lus':
        return 'Mizo';
      case 'mai':
        return 'Maithili';
      case 'mni-Mtei':
        return 'Meitei (Meetei)';
      case 'my':
        return 'Burmese';
      case 'pt':
        return 'Portuguese';
      case 'sa':
        return 'Sanskrit';
      case 'sm':
        return 'Samoan';
      case 'ts':
        return 'Tsonga';
      case 'zh':
        return 'Chinese';
      default:
        return '';
    }
  }

}