import 'package:tiktik_v/api_service/ApiService.dart';
import 'package:tiktik_v/domain/repository/api_repository.dart';

class ConnectToDatabaseUseCase {
  final ApiRepository apiRepository;

  ConnectToDatabaseUseCase({required this.apiRepository});

  Future<ApiResponse<String>> execute({
    required String host,
    required String user,
    required String password,
    required String database,
  }) async {
    return await apiRepository.connectToDatabase(
      host: host,
      user: user,
      password: password,
      database: database,
    );
  }
}
