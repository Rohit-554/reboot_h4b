import 'package:tiktik_v/api_service/ApiService.dart';
import 'package:tiktik_v/data/model/Chat_response_model.dart';
import 'package:tiktik_v/domain/repository/api_repository.dart';

class GetChatUseCase {
  final ApiRepository apiRepository;

  GetChatUseCase({required this.apiRepository});

  Future<ChatResponseModel?> execute({
    required String chatId,
    required String query
  }) async {
    return await apiRepository.getChat(
    chatId: chatId,
    query: query
    );
  }

}
