class ChatResponseModel {
  final String? code;
  final String? message;
  final double? table;

  ChatResponseModel({
    required this.code,
    required this.message,
    required this.table,
  });

  factory ChatResponseModel.fromMap(Map<String, dynamic> map) {
    return ChatResponseModel(
      code: map['code'],
      message: map['message'],
      table: map['table'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'message': message,
      'table': table,
    };
  }
}
