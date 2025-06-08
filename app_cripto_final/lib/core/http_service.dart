import 'package:http/http.dart' as http;

class HttpService {
  Future<http.Response> get(Uri url, {Map<String, String>? headers}) async {
    return http.get(url, headers: headers);
  }
}