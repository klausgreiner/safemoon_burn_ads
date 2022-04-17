import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:safemoon_burn_ads/modules/core/data/shared_preferences_core.dart';
import 'package:safemoon_burn_ads/modules/core/data/shared_preferences_repository.dart';
import 'package:safemoon_burn_ads/modules/home/di/home_module.dart';
import 'package:safemoon_burn_ads/modules/home/presentation/home_store.dart';

import '../modules/home/presentation/home_page.dart';

class AppModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.singleton((i) => Dio()),
    Bind<SharedPreferencesCore>((_) => SharedPreferencesCoreImpl()),
    Bind<SharedPreferencesRepository>(
      (_) => SharedPreferencesRepositoryImpl(Modular.get()),
    ),

  Bind.singleton((i) => HomeStore(Modular.get())),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => Home()),
  ];
}
