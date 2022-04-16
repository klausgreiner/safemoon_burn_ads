import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../modules/home/presentation/home_page.dart';

class AppModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.singleton((i) => Dio()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => const Home()),
  ];
}
