import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yallajeye/Services/ApiLink.dart';

class ServiceAPi {
  static Map<String, String> headers = {};

  Future<Map<String, dynamic>> getAPi(
      String link, List<String> l, Map<String, String> headerget) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Map<String, String> head1 = {
        'Authorization': 'Bearer ${prefs.getString("token")}'
      };
      // prefs.getString("token")
      //  if(!headerget.isEmpty)
      headers.addAll(head1);
      if (headerget != {}) headers.addAll(headerget);
      // headers.addAll(headerget);

      for (int i = 0; i < l.length; i++) link = link + "/${l[i]}";
      var request = http.Request('GET', Uri.parse(link));
      request.headers.addAll(headers);
      http.StreamedResponse responses = await request.send();
      var response = await http.Response.fromStream(responses);

      Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData["statusCode"] == 200) {
        return responseData["data"];
      } else {
        return {"error": responseData["errorMessage"]};
        // return;
      }
    } catch (e) {
      return {"error": "error try again"};
    }
  }

   Future<Map<String, dynamic>> postAPi(
      String link,
      List<String> l,
      Map<String, String> body,
      List<File> files,
      Map<String, String> headerget,
      bool isupdateprofile) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Map<String, String> head1 = {
        'Authorization': 'Bearer ${prefs.getString("token")}'
      };
      //  if(!headerget.isEmpty)
      headers.addAll(head1);
      if (headerget != {}) headers.addAll(headerget);
      for (int i = 0; i < l.length; i++) link = link + "/${l[i]}";
      var request = http.MultipartRequest('POST', Uri.parse(link));

      request.headers.addAll(headers);

      request.fields.addAll(body);
      for(int i=0;i<files.length;i++) {
        request.files.add(await http.MultipartFile.fromPath('FormFile', files[i].path));
      }



      http.StreamedResponse responses = await request.send();
      var response = await http.Response.fromStream(responses);
      Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData["statusCode"] == 200) {
        // if (!true) {
        //   if (responseData["isverified"]) {
        //     return responseData["data"];

        //   } else {}
        //   return {};
        // } else
          return responseData["data"];
      }else {
        return {"error": responseData["errorMessage"]};
      }
    } catch (e) {
      return {"error": "error try again"};
    }
  }







  Future<Map<String, dynamic>> postAPiUser(
      String link,
      Map<String, String> body,
      List<File> files,
      Map<String, String> headerget,
      bool isupdateprofile) async {
    try {
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // Map<String, String> head1 = {
      //   'Authorization': 'Bearer ${prefs.getString("token")}'
      // };
      //  if(!headerget.isEmpty)
      // headers.addAll(head1);
print("body" '$body');
      if (headerget != {}) headers.addAll(headerget);

      var request = http.MultipartRequest('POST', Uri.parse(link));
      request.headers.addAll(headers);

      request.fields.addAll(body);
      for(int i=0;i<files.length;i++) {
        request.files.add(await http.MultipartFile.fromPath('FormFile', files[i].path));
      }

      http.StreamedResponse responses = await request.send();
      var response = await http.Response.fromStream(responses);
      Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData["statusCode"] == 200) {
        // if (!true) {
        //   if (responseData["isverified"]) {
        //     return responseData["data"];
        //   } else {}
        //   return {};
        // } else
        return responseData;
      }
      else {
        return {"error": responseData["errorMessage"]};
      }
    } catch (e) {
      return {"error": "error try again"};
    }
  }

  Future<Map<String, dynamic>> postAPiRawJson(
      String link,
      Map<String, dynamic> body,
      Map<String, String> headerget,
      bool isupdateprofile) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Map<String, String> head1 = {
        'Authorization': 'Bearer ${prefs.getString("token")}'
      };
      //  if(!headerget.isEmpty)
      headers.addAll(head1);
      if (headerget != {}) headers.addAll(headerget);

      var request = http.Request('POST', Uri.parse(link));
      request.body= jsonEncode(body);
      request.headers.addAll(headers);

      // request.fields.addAll(body);

      http.StreamedResponse responses = await request.send();
      var response = await http.Response.fromStream(responses);
      Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData["statusCode"] == 200) {
        // if (!true) {
        //   if (responseData["isverified"]) {
        //     return responseData["data"];
        //   } else {}
        //   return {};
        // } else
        return responseData["data"];
      }
      return {"error": responseData["errorMessage"]};
    } catch (e) {
      return {"error": "error try again"};
    }
  }
}
