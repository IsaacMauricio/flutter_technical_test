import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';

import 'root.dart';
import 'services/contracts/user_service_contract.dart';
import 'services/implementations/user_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  _registerServices();

  runApp(const Root());
}

void _registerServices() {
  GetIt getIt = GetIt.instance;

  getIt.registerSingleton<UserServiceContract>(UserService());
}
