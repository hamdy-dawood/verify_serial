import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../../core/helpers/cache_helper.dart';
import '../../core/networking/dio_helper.dart';
import '../../core/networking/urls_strings.dart';
import 'states.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(HomeInitialState());

  final dioManager = DioManager();
  final logger = Logger();


  Future<void> profile() async {
    emit(ProfileLoadingState());
    try {
      final response = await dioManager.get(
        UrlsStrings.profileUrl,
      );

      if (response.statusCode == 200) {
        emit(ProfileSuccessState());

        CacheHelper.put(
          key: 'user_name',
          value: "${response.data['displayName']}",
        );
        logger.i(response.data);
      } else {
        emit(ProfileFailedState(msg: response.data["message"]));
      }
    } on DioException catch (e) {
      handleDioException(e);
    } catch (e) {
      emit(ProfileFailedState(msg: 'An unknown error: $e'));
      logger.e(e);
    }
  }

  void handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.cancel:
        emit(ProfileFailedState(msg: "Request was cancelled"));
        break;
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        emit(NetworkErrorState());
        break;
      case DioExceptionType.badResponse:
        emit(ProfileFailedState(msg: e.response?.data["message"]));
        break;
      default:
        emit(NetworkErrorState());
    }
    logger.e(e);
  }
}
