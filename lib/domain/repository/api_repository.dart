
import 'package:tiktik_v/api_service/ApiService.dart';
import 'package:tiktik_v/data/model/Chat_response_model.dart';

abstract class ApiRepository {
  Future<ApiResponse<String>> connectToDatabase({
    required String host,
    required String user,
    required String password,
    required String database,
  });

  Future<List<String>?> getChat({
    required String chatId,
    required String query
  });
}