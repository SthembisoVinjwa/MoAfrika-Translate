import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class TranslationService {
  Future<String> translate(String text, String targetLanguage) async {
    try {
      const apiKey = 'AIzaSyC39CSBMm1irl7x_x5iTYbOmaeuH6Ti31o';
      const apiUrl =
          'https://translation.googleapis.com/language/translate/v2?key=$apiKey';

      final response = await http.post(Uri.parse(apiUrl), body: {
        'q': text,
        'target': targetLanguage,
      });

      if (response.statusCode == 200) {
        final translatedText = jsonDecode(response.body)['data']['translations'][0]['translatedText'];
        return translatedText;
      } else {
        throw Exception('Failed to translate text. HTTP status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('An error occurred during translation: $e');
    }
  }
}