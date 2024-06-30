import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktik_v/data/model/Chat_response_model.dart';
import 'package:tiktik_v/data/model/api_response_model.dart';

import '../provider/StateProviders.dart';

class ApiResponse<T> {
  T? data;
  String? error;

  ApiResponse({this.data, this.error});
}

class ApiService {
  static const String baseUrl = 'http://3.109.213.8';
  static const String connectUrl = '$baseUrl/connect_old';
  static const String chatUrl = '$baseUrl/generate_response';
  static const String closeConnectionUrl = '$baseUrl/close_connection';
  static const String analysisUrl = '$baseUrl/analyze';

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

  Future<String> getAnalysis() async{
    try{
      final response = await dio.get(analysisUrl);
      if(response.statusCode == 200){
        return response.data;
      }
    }catch(e){
      return "No Analysis Found";
    }
    return "Not found";
  }

  void disconnect(WidgetRef ref) async{
    try{
      final response = await dio.post(closeConnectionUrl);
      if(response.statusCode==200){
        ref.read(chatIdProvider.notifier).state = '';
        ref.read(isDatabaseConnected.notifier).state = false;
      }
    }catch(e){
      print(e);
    }
  }
  Future<List<String>?> getChat(
      {required String chatId, required String query}) async {
    final Map<String, String> body = {
      "query": query,
      "chat_id": chatId,
    };
    List<String> responseList = [];

    try {
      final response = await dio.post(chatUrl, data: body);
      print("this is the code" + response.data['message']);
      if (response.statusCode == 200) {
        final data = response.data;
        if (data.containsKey('message')) {
          responseList.add(data['message']);
        }
        if (data.containsKey('code')) {
          responseList.add(data['code']);
        }
        if (data.containsKey('table')) {
          responseList.add(data['table']);
        }
        if(data.containsKey('datapoints')){
          responseList.add(data['datapoints']);
        }
        print('Response datax: $responseList');
        return responseList;
      } else {
        return null;
      }
    } on DioException catch (e) {
      return null;
    } catch (e) {
      return null;
    }
  }
}
