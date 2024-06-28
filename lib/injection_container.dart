import 'package:get_it/get_it.dart';
import 'package:tiktik_v/api_service/ApiService.dart';
import 'package:tiktik_v/domain/repository/apiRepositoryImpl.dart';
import 'package:tiktik_v/domain/repository/api_repository.dart';
import 'package:tiktik_v/presentation/use_case/connect_to_database_use_case.dart';
import 'package:tiktik_v/presentation/use_case/get_chat_use_case.dart';


final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  sl.registerSingleton<ApiService>(ApiService());
  sl.registerLazySingleton<ApiRepository>(() => ApiRepositoryImpl(apiService: sl<ApiService>()));
  sl.registerLazySingleton<ConnectToDatabaseUseCase>(() => ConnectToDatabaseUseCase(apiRepository: sl<ApiRepository>()));
  sl.registerLazySingleton<GetChatUseCase>(() => GetChatUseCase(apiRepository: sl<ApiRepository>()));
}