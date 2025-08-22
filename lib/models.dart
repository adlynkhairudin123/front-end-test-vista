class ServiceModel {
  final int id;
  final String name;
  final String description;
  final double price;
  final int companyId;

  ServiceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.companyId,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> j) {
    final p = j['price'];
    final price = (p is num) ? p.toDouble() : double.parse(p.toString());

    final cid = j['companyId'];
    final companyId = (cid is int) ? cid : int.parse(cid.toString());

    return ServiceModel(
      id: (j['id'] is int) ? j['id'] : int.parse(j['id'].toString()),
      name: j['name'] as String,
      description: j['description'] as String,
      price: price,
      companyId: companyId,
    );
  }
}

class CompanyModel {
  final int id;
  final String name;
  final String registrationNumber;
  final List<ServiceModel> services;

  CompanyModel({
    required this.id,
    required this.name,
    required this.registrationNumber,
    required this.services,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> j) {
    final servicesJson = (j['services'] as List?) ?? const [];
    return CompanyModel(
      id: (j['id'] is int) ? j['id'] : int.parse(j['id'].toString()),
      name: j['name'] as String,
      registrationNumber: j['registrationNumber'] as String,
      services: servicesJson.map((e) => ServiceModel.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
}
