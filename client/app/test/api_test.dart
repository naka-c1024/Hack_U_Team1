import 'package:http/http.dart' as http;
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Test: API is Running',() async {
      var url = Uri.parse('http://localhost:8080/ok');
      var response = await http.get(url);
      expect(response.statusCode, 200);
  });
}
