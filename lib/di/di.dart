import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:talker_flutter/talker_flutter.dart';

// Импортируем созданный экземпляр и функцию настройки
import '../app/features/auth/bloc/auth_cubit.dart';
import '../app/features/details/bloc/details_bloc.dart';
import '../app/features/home/bloc/home_bloc.dart';
import '../data/dio/dio.dart';
import '../data/dio/set_up.dart';
import '../data/firestore/user_store.dart';
import '../domain/repositories/content/content_repository.dart';
import '../domain/repositories/content/content_repository_interface.dart';

final getIt = GetIt.instance;
final talker = TalkerFlutter.init();

Future<void> setupLocator() async {
  // 1. Регистрируем talker (как было у вас)
  getIt.registerSingleton(talker);

  // 2. Вызываем функцию настройки Dio (она лежит в data/dio/set_up.dart)
  setUpDio();

  // 3. Регистрируем сам экземпляр Dio, чтобы его можно было передавать в репозитории
  getIt.registerSingleton<Dio>(dio);

  getIt.registerSingleton<ContentRepositoryInterface>(
    ContentRepository(dio: dio),
  );
  getIt.registerSingleton(HomeBloc(getIt.get<ContentRepositoryInterface>()));
  getIt.registerSingleton(DetailsBloc(getIt.get<ContentRepositoryInterface>()));

  // Firebase: аутентификация и Firestore
  getIt.registerSingleton<FirebaseAuth>(FirebaseAuth.instance);
  getIt.registerSingleton<FirebaseFirestore>(FirebaseFirestore.instance);
  getIt.registerSingleton(UserStore(getIt.get<FirebaseFirestore>()));
  getIt.registerSingleton(
    AuthCubit(getIt.get<FirebaseAuth>(), getIt.get<UserStore>()),
  );
}
