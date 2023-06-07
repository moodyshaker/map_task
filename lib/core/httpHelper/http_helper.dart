import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'header_config.dart';


final String base_url = 'http://engaztechnology.net/Himam/User';
class HttpHelper {
  static final HttpHelper instance = HttpHelper._instance();

  HttpHelper._instance();

  Future<Response> httpPost(String path, bool withAuth,
      {Map<String, dynamic>? body, bool withoutPath = false}) async {
    final Response r = await post(
        Uri.parse(withoutPath ? path : '$base_url$path'),
        body: json.encode(body),
        headers: withAuth
            ? await HeaderConfig.getHeaderWithToken()
            : await HeaderConfig.getHeader());
    return r;
  }

  Future<Response> httpDelete(String path, bool withAuth,
      {Map<String, dynamic>? body}) async {
    final Response r = await delete(Uri.parse('$base_url$path'),
        body: body == null ? null : json.encode(body),
        headers: withAuth
            ? await HeaderConfig.getHeaderWithToken()
            : await HeaderConfig.getHeader());
    return r;
  }

  Future<Response> httpGet(String path, bool withAuth) async {
    final Response r = await get(Uri.parse('$base_url$path'),
        headers: withAuth
            ? await HeaderConfig.getHeaderWithToken()
            : await HeaderConfig.getHeader());
    return r;
  }

  Future<Response> httpPut(String path, bool withAuth,
      {Map<String, dynamic>? body}) async {
    final Response r = await put(Uri.parse('$base_url$path'),
        body: json.encode(body),
        headers: withAuth
            ? await HeaderConfig.getHeaderWithToken()
            : await HeaderConfig.getHeader());
    return r;
  }

}
