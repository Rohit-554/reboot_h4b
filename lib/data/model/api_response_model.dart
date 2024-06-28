class SuccessResponse {
  final String chatId;
  final String message;

  SuccessResponse({required this.chatId, required this.message});

  factory SuccessResponse.fromJson(Map<String, dynamic> json) {
    return SuccessResponse(
      chatId: json['chat_id'],
      message: json['message'],
    );
  }
}

class ErrorResponse {
  final String error;

  ErrorResponse({required this.error});

  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return ErrorResponse(
      error: json['error'],
    );
  }
}