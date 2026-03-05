import 'package:dio/dio.dart';
import 'package:flutter_chatbot/features/chat/data/datasources/faq_datasource.dart';
import 'package:flutter_chatbot/features/chat/data/repositories/faq_chat_repository.dart';
import 'package:get_it/get_it.dart';

import '../../core/network/openai_client.dart';

import '../../features/chat/domain/repositories/chat_repository.dart';
import '../../features/chat/data/datasources/openai_chat_remote_datasource.dart';
import '../../features/chat/data/repositories/chat_repository_impl.dart';
import '../../features/chat/presentation/bloc/chat_cubit.dart';

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  sl.registerLazySingleton<Dio>(() {
    return Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 40),
        sendTimeout: const Duration(seconds: 20),
      ),
    );
  });

  sl.registerLazySingleton(() => OpenAiClient(sl<Dio>()));
  sl.registerLazySingleton(
    () => OpenAiChatRemoteDataSource(sl<OpenAiClient>()),
  );

  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(sl<OpenAiChatRemoteDataSource>()),
  );
  sl.registerLazySingleton(() => FaqDataSource());
  sl.registerLazySingleton(() => FaqChatRepository(sl<FaqDataSource>()));

  sl.registerFactory(
    () => ChatCubit(
      faqRepo: sl<FaqChatRepository>(),
      chatRepo: sl<ChatRepository>(),
    ),
  );
}
