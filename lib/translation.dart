import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

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
}