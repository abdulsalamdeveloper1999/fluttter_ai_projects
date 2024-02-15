import 'dart:developer';
import 'dart:typed_data';
import 'package:dio/dio.dart';

String apiKey = 'apitokenhere';

class PromptRepo {
  static Future<Uint8List?> generateImage(String prompt) async {
    try {
      String url = 'https://api.vyro.ai/v1/imagine/api/generations';
      Map<String, dynamic> headers = {'Authorization': 'Bearer $apiKey'};

      Map<String, dynamic> payload = {
        "prompt": prompt,
        'style_id': '122',
        'aspect_ratio': '16:9',
        'cfg': '7',
        'seed': '1',
        'high_res_results': '1'
      };

      Dio dio = Dio();
      dio.options =
          BaseOptions(headers: headers, responseType: ResponseType.bytes);

      FormData formData = FormData.fromMap(payload);

      final response = await dio.post(url, data: formData);

      if (response.statusCode == 200) {
        Uint8List uint8list = Uint8List.fromList(response.data);
        return uint8list;
      } else {
        return null;
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
