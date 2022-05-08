import 'package:shared_preferences/shared_preferences.dart';
import 'package:yallajeye/Services/ApiLink.dart';
import 'package:yallajeye/models/home_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class NotificationService {

  Future<Map<String,dynamic>> getNotification() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var headers = {
        'Authorization': 'Bearer ${prefs.getString("token")}'};
      var request = http.Request('GET', Uri.parse(ApiLink.Notification));
      request.headers.addAll(headers);
      http.StreamedResponse responses = await request.send();
      var response = await http.Response.fromStream(responses);
      if (response.statusCode == 200) {
        Map<String,dynamic> responseData = json.decode(response.body);
        return responseData;
      }else{
        return {};
      }
    } catch (e) {
      return {};
    }
  }
}
