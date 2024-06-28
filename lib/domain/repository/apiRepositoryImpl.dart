import 'package:tiktik_v/api_service/ApiService.dart';
import 'package:tiktik_v/data/model/Chat_response_model.dart';
import 'package:tiktik_v/data/model/api_response_model.dart';
import 'package:tiktik_v/domain/repository/api_repository.dart';

class ApiRepositoryImpl implements ApiRepository {
  final ApiService apiService;

  ApiRepositoryImpl({required this.apiService});

  @override
  Future<ApiResponse<String>> connectToDatabase({
    required String host,
    required String user,
    required String password,
    required String database,
  }) async {
    try {
      final response = await apiService.connectToDatabase(
        host: host,
        user: user,
        password: password,
        database: database,
      );
      return ApiResponse(data: response.data);
    } catch (e) {
      return ApiResponse(error: 'Error connecting to database: $e');
    }
  }

  @override
  Future<ApiResponse<String>> getChat({required String chatId,required String query}) async {
    try{
      final response = await apiService.getChat(chatId: chatId, query: query);
      return ApiResponse(data: response.data);
    }catch(e){
      return ApiResponse(error: 'Error connecting to database: $e');
    }
  }



}
