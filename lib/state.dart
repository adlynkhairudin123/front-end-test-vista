import 'package:flutter/foundation.dart';
import 'api.dart';
import 'models.dart';

class AppState extends ChangeNotifier {
  List<CompanyModel> companies = <CompanyModel>[];
  bool loading = false;
  String? error;

  Future<void> refresh() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      companies = await Api.getCompanies();
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<bool> createCompany(String name, String regNo) async {
    try {
      await Api.createCompany(name: name, registrationNumber: regNo);
      await refresh();
      return true;
    } catch (e) {
      error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> createService(String name, String desc, double price, int companyId) async {
    try {
      await Api.createService(name: name, description: desc, price: price, companyId: companyId);
      await refresh();
      return true;
    } catch (e) {
      error = e.toString();
      notifyListeners();
      return false;
    }
  }
}
