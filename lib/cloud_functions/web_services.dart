import 'dart:convert';

import 'package:budget_buddy/env.dart';
import 'package:http/http.dart';

Future<Response> executeGet({required String endpoint}) async {
  try {
    return await get(
      Uri(
        scheme: AppEnvironment.scheme,
        host: AppEnvironment.baseApiUrl,
        port: AppEnvironment.port,
        path: endpoint,
      ),
    );
  } catch (e) {
    return Response('Server cannot be reached', 503);
  }
}

Future<Response> executePost(
    {required String endpoint, dynamic payload}) async {
  try {
    return await post(
      Uri(
        scheme: AppEnvironment.scheme,
        host: AppEnvironment.baseApiUrl,
        port: AppEnvironment.port,
        path: endpoint,
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(payload),
    );
  } catch (e) {
    return Response('Server cannot be reached', 503);
  }
}
