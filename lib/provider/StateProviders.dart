import 'package:flutter_riverpod/flutter_riverpod.dart';

StateProvider<String> hostProvider = StateProvider((ref) => 'ms.itversity.com');
StateProvider<String> userProvider = StateProvider((ref) => 'retail_user');
StateProvider<String> passwordProvider = StateProvider((ref) => 'itversity');
StateProvider<String> databaseProvider = StateProvider((ref) => 'retail_db');
StateProvider<bool> isDatabaseConnected = StateProvider((ref) => false);
StateProvider<String> chatIdProvider = StateProvider((ref) => '');