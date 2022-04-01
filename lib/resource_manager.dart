import 'dart:async';
import 'dart:convert';
import 'database_manager.dart';

class ResourseManager {
  static final ResourseManager _instance = ResourseManager._internal();
  factory ResourseManager() => _instance;

  ResourseManager._internal() {
    init();
  }

  Map<String, Resource> resources = {};

  void init() async {
    var db = DatabaseManager.instance;
    var r = await db.getResources();
    // print(r);

    var resourcesFromDb = jsonDecode(r)['resources'] as Map<String, dynamic>;

    resourcesFromDb.forEach((key, value) {
      resources[key] = Resource.fromJson(value);
    });

    // save game states in every 10 seconds for now
    Timer.periodic(const Duration(milliseconds: 10 * 1000), (timer) async {
      if (resources.isNotEmpty) {
        await db.setResources(jsonEncode(this));
      }
    });
  }

  Resource? getResource(String name) {
    return resources[name];
  }

  Map<String, dynamic> toJson() => {
        'resources': resources,
      };
}

class Resource {
  String name;
  int quantity = 0;

  Resource(this.name, this.quantity);

  Resource.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        quantity = json['quantity'] ?? 0;

  Map<String, dynamic> toJson() => {
        'name': name,
        'quantity': quantity,
      };

  void add(int amount) {
    quantity += amount;
  }

  void use(int amount) {
    quantity -= amount;
  }
}
