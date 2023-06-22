import 'package:budget_buddy/cloud_functions/web_services.dart';

Future<String?> doHealthCheck() async {
  final response = await executeGet(endpoint: 'healthCheck');
  return response.body;
}
