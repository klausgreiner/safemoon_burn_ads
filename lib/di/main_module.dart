import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:safemoon_burn_ads/modules/core/data/firestore/firestore_service.dart';
import 'package:safemoon_burn_ads/modules/core/data/shared_preferences/shared_preferences_core.dart';
import 'package:safemoon_burn_ads/modules/core/data/shared_preferences/shared_preferences_repository.dart';
import 'package:safemoon_burn_ads/modules/home/presentation/home_page.dart';
import 'package:safemoon_burn_ads/modules/home/presentation/home_store.dart';

class AppModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.singleton((i) => Dio()),
    Bind.singleton((i) => FirestoreService()),
    Bind<SharedPreferencesCore>((_) => SharedPreferencesCoreImpl()),
    Bind<SharedPreferencesRepository>(
      (_) => SharedPreferencesRepositoryImpl(Modular.get()),
    ),
    Bind.singleton((i) => HomeStore(Modular.get(), Modular.get())),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => Home()),
  ];
}
