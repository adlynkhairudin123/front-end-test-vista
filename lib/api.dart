import 'dart:convert';
import 'package:http/http.dart' as http;
import 'config.dart';
import 'models.dart';

class Api {
  static Uri _u(String p) => Uri.parse('$apiBaseUrl$p');

  static Future<List<CompanyModel>> getCompanies() async {
    final r = await http.get(_u('/companies'));
    if (r.statusCode != 200) {
      throw Exception('GET /companies ${r.statusCode}: ${r.body}');
    }
    final data = jsonDecode(r.body) as List;
    return data.map((e) => CompanyModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  static Future<CompanyModel> createCompany({
    required String name,
    required String registrationNumber,
  }) async {
    final r = await http.post(
      _u('/companies'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'registrationNumber': registrationNumber}),
    );
    if (r.statusCode != 201) {
      throw Exception('POST /companies ${r.statusCode}: ${r.body}');
    }
    return CompanyModel.fromJson(jsonDecode(r.body) as Map<String, dynamic>);
  }

  static Future<ServiceModel> createService({
    required String name,
    required String description,
    required double price,
    required int companyId,
  }) async {
    final r = await http.post(
      _u('/services'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'description': description, 'price': price, 'companyId': companyId}),
    );
    if (r.statusCode != 201) {
      throw Exception('POST /services ${r.statusCode}: ${r.body}');
    }
    return ServiceModel.fromJson(jsonDecode(r.body) as Map<String, dynamic>);
  }
}
