import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'objectbox.g.dart';
import 'root.dart';
import 'services/contracts/user_service_contract.dart';
import 'services/implementations/user_service.dart';

late ObjectBox objectbox;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  _registerServices();
  _openDatabase();

  runApp(const Root());
}

void _registerServices() {
  GetIt getIt = GetIt.instance;

  getIt.registerSingleton<UserServiceContract>(UserService());
}

Future<void> _openDatabase() async {
  objectbox = await ObjectBox.create();
}

class ObjectBox {
  late final Store store;

  ObjectBox._create(this.store);

  static Future<ObjectBox> create() async {
    Directory? docsDir;

    docsDir = await getApplicationDocumentsDirectory();
    final store = await openStore(directory: join(docsDir.path, 'cache'));
    return ObjectBox._create(store);
  }
}
