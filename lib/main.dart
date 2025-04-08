import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';

import 'services/contracts/user_service_contract.dart';
import 'services/implementations/user_service.dart';
import 'technical_test.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  _registerServices();

  GetIt.instance.get<UserServiceContract>().fetchUsers();

  runApp(const TechnicalTest());
}

void _registerServices() {
  GetIt getIt = GetIt.instance;

  getIt.registerSingleton<UserServiceContract>(UserService());
}
