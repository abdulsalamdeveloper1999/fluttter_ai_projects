import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

class BlocRepo {
  Future<String> generateImage(String prompt) async {
    String apiUrl = 'https://api.vyro.ai/v1/imagine/api/generations';
    String apiToken = 'vk-yecRGANAPFbjyqaYdt0qSdU39SWHx6AhCWESgHDzzkYP7';

    // Create headers
    Map<String, String> headers = {
      'Authorization': 'Bearer $apiToken',
    };

    // Create form data
    Map<String, String> data = {
      'prompt': prompt,
      'style_id': '122',
      'aspect_ratio': '1:1',
      'cfg': '7',
      'seed': '1',
      'high_res_results': '1',
    };

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: data,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body)['url'];
      } else {
        throw Exception('Failed to load image');
      }
    } catch (error) {
      log('Error: $error');
      rethrow;
    }
  }
}
