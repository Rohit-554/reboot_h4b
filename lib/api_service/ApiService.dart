import 'package:dio/dio.dart';
import 'package:tiktik_v/data/model/Chat_response_model.dart';
import 'package:tiktik_v/data/model/api_response_model.dart';

class ApiResponse<T> {
  T? data;
  String? error;

  ApiResponse({this.data, this.error});
}

class ApiService {
  static const String baseUrl = 'http://13.201.224.184';
  static const String connectUrl = '$baseUrl/connect_old';
  static const String chatUrl = '$baseUrl/generate_response';
  static const String closeConnectionUrl = '$baseUrl/close_connection';

  final Dio dio = Dio();

  Future<ApiResponse<String>> connectToDatabase({
    required String host,
    required String user,
    required String password,
    required String database,
  }) async {
    final Map<String, String> body = {
      "host": host,
      "user": user,
      "password": password,
      "database": database,
    };

    try {
      final response = await dio.post(connectUrl, data: body);
      if (response.statusCode == 200) {
        final data = response.data;
        print('Response data: $data');
        if (data is Map<String, dynamic> && data.containsKey('chat_id')) {
          final successResponse = SuccessResponse.fromJson(data);
          return ApiResponse(data: successResponse.chatId);
        } else if (data is Map<String, dynamic> && data.containsKey('error')) {
          final errorResponse = ErrorResponse.fromJson(data);
          return ApiResponse(error: errorResponse.error);
        } else {
          return ApiResponse(error: 'Unknown response format');
        }
      } else {
        return ApiResponse(
            error: 'Received invalid status code ${response.statusCode}');
      }
    } on DioException catch (e) {
      return ApiResponse(error: 'Dio error: ${e.message}');
    } catch (e) {
      return ApiResponse(error: 'Unexpected error: $e');
    }
  }

  Future<ApiResponse> getChat({required String chatId, required String query}) async {
    final Map<String, String> body = {
      "query": query,
      "chat_id": chatId,
    };

    try {
      final response = await dio.post(chatUrl, data: body);
      if (response.statusCode == 200) {
        final data = response.data;
        print('Response data: $data');
        final successResponse = ChatResponseModel.fromMap(data);
        print("successResponse${successResponse.message}");
        return ApiResponse(data: successResponse.message);
        /*if (data is Map<String, dynamic> && (data.containsKey('message') || data.containsKey('code')) ) {
          final successResponse = ChatResponseModel.fromMap(data);
          return ApiResponse(data: successResponse.message);
        } else if (data is Map<String, dynamic> && data.containsKey('error')) {
          final errorResponse = ErrorResponse.fromJson(data);
          return ApiResponse(error: errorResponse.error);
        } else {
          return ApiResponse(error: 'Unknown response format');
        }*/
      }else {
        return ApiResponse(error: 'Received invalid status code ${response.statusCode}');
      }
    } on DioException catch (e) {
      return ApiResponse(error: 'Dio error: ${e.message}');
    } catch (e) {
      return ApiResponse(error: 'Unexpected error: $e');
    }
  }
}
