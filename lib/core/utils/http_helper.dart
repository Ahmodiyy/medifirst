import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';

final httpHelperProvider = Provider((ref) {
  return HttpHelper();
});

class HttpHelper {

  HttpHelper();

  //Make a GET request
  Future<Map<String, dynamic>> get({
    required String url,
    Map<String, dynamic>? query,
    Map<String, dynamic>? body,
  }) async {
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'x-access-token': '',
    };

    try {
      if (query != null) {
        url += '?';
        query.forEach((key, value) {
          url += '&$key=$value';
        });
      }
      http.Response response = await http
          .get(Uri.parse(url), headers: headers)
          .timeout(const Duration(seconds: 30));
      final Map<String, dynamic> result = json.decode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return result;
      } else {
        throw result['message'];
      }
    } on FormatException catch (e) {
      throw 'Something went wrong, please try again';
    } on SocketException catch (e) {
      throw 'Unable to connect to the server, please check your network and try again';
    } on TimeoutException catch (e) {
      throw 'Request timeout, please check your network and try  again';
    } catch (e) {
      throw e.toString();
    }
  }

  //Make a POST request
  Future<Map<String, dynamic>> post({
    required String url,
    required Map<String, dynamic> body,
    Map<String, String>? header,
  }) async {
    try {
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${ ''}',
        'x-access-token':  '',
      };

      http.Response response = await http
          .post(
        Uri.parse(url),
        headers: header ?? headers,
        body: json.encode(body),
      )
          .timeout(const Duration(seconds: 30));
      final Map<String, dynamic> result = json.decode(response.body);
      if(response.statusCode == 200 || response.statusCode == 201){
        return result;
      }else{
        throw checkForError(result);
      }
    } on FormatException catch (e) {
      throw 'Something went wrong, please try again';
    } on SocketException catch (e) {
      throw 'Unable to connect to the server, please check your network and try again';
    } on TimeoutException catch (e) {
      throw 'Request timeout, please check your network and try  again';
    } catch (e) {
      throw e.toString();
    }
  }

  //Make a PATCH request
  Future<Map<String, dynamic>> patch({
    required String url,
    required Map<String, dynamic> body,
    Map<String, String>? header,
  }) async {
    try {
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'x-access-token': '',
      };

      http.Response response = await http
          .patch(
        Uri.parse(url),
        headers: header ?? headers,
        body: json.encode(body),
      )
          .timeout(const Duration(seconds: 30));

      final Map<String, dynamic> result = json.decode(response.body);
      if(response.statusCode == 200 || response.statusCode == 201){
        return result;
      }else{
        throw checkForError(result);
      }
    } on FormatException catch (e) {
      throw 'Something went wrong, please try again';
    } on SocketException catch (e) {
      throw 'Unable to connect to the server, please check your network and try again';
    } on TimeoutException catch (e) {
      throw 'Request timeout, please check your network and try  again';
    } catch (e) {
      throw e.toString();
    }
  }

  //Make a DELETE request
  Future<Map<String, dynamic>> delete({
    required String url,
    Map<String, dynamic>? body,
    Map<String, String>? header,
  }) async {
    try {
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'x-access-token': '',
      };

      http.Response response = await http
          .delete(
        Uri.parse(url),
        headers: header ?? headers,
        body: json.encode(body),
      )
          .timeout(const Duration(seconds: 30));

      final Map<String, dynamic> result = json.decode(response.body);
      if(response.statusCode == 200 || response.statusCode == 201){
        return result;
      }else{
        throw checkForError(result);
      }
    } on FormatException catch (e) {
      throw 'Something went wrong, please try again';
    } on SocketException catch (e) {
      throw 'Unable to connect to the server, please check your network and try again';
    } on TimeoutException catch (e) {
      throw 'Request timeout, please check your network and try  again';
    } catch (e) {
      throw e.toString();
    }
  }

  static String checkForError(Map data){
    if(data['status'] == false){
      final String? message = data['message'];
      if(message != null){
        throw message;
      }
      final Map<String, dynamic> errorMap = Map.from(data['error']);

      return errorMap.values.join('\n');
    }

    return 'Something went wrong, please try again';
  }
}
