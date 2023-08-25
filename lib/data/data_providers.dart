import 'package:dio/dio.dart';
import 'package:hiddify/data/api/clash_api.dart';
import 'package:hiddify/data/local/dao/dao.dart';
import 'package:hiddify/data/local/database.dart';
import 'package:hiddify/data/repository/repository.dart';
import 'package:hiddify/data/repository/update_repository_impl.dart';
import 'package:hiddify/domain/app/app.dart';
import 'package:hiddify/domain/constants.dart';
import 'package:hiddify/domain/core_facade.dart';
import 'package:hiddify/domain/profiles/profiles.dart';
import 'package:hiddify/services/service_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'data_providers.g.dart';

@Riverpod(keepAlive: true)
AppDatabase appDatabase(AppDatabaseRef ref) => AppDatabase.connect();

@Riverpod(keepAlive: true)
SharedPreferences sharedPreferences(SharedPreferencesRef ref) =>
    throw UnimplementedError('sharedPreferences must be overridden');

// TODO: set options for dio
@Riverpod(keepAlive: true)
Dio dio(DioRef ref) => Dio(
      BaseOptions(
        headers: {
          "User-Agent": ref.watch(runtimeDetailsServiceProvider).userAgent,
        },
      ),
    );

@Riverpod(keepAlive: true)
ProfilesDao profilesDao(ProfilesDaoRef ref) => ProfilesDao(
      ref.watch(appDatabaseProvider),
    );

@Riverpod(keepAlive: true)
ProfilesRepository profilesRepository(ProfilesRepositoryRef ref) =>
    ProfilesRepositoryImpl(
      profilesDao: ref.watch(profilesDaoProvider),
      filesEditor: ref.watch(filesEditorServiceProvider),
      singbox: ref.watch(coreFacadeProvider),
      dio: ref.watch(dioProvider),
    );

@Riverpod(keepAlive: true)
UpdateRepository updateRepository(UpdateRepositoryRef ref) =>
    UpdateRepositoryImpl(ref.watch(dioProvider));

@Riverpod(keepAlive: true)
ClashApi clashApi(ClashApiRef ref) => ClashApi(Defaults.clashApiPort);

@Riverpod(keepAlive: true)
CoreFacade coreFacade(CoreFacadeRef ref) => CoreFacadeImpl(
      ref.watch(singboxServiceProvider),
      ref.watch(filesEditorServiceProvider),
      ref.watch(clashApiProvider),
      ref.watch(connectivityServiceProvider),
    );
