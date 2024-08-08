import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import '../../core/helpers/cache_helper.dart';
import '../../core/networking/dio_helper.dart';
import '../../core/networking/urls_strings.dart';
import 'controller.dart';
import 'states.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());

  final formKey = GlobalKey<FormState>();
  final dioManager = DioManager();
  final logger = Logger();
  final controllers = LoginControllers();
  bool isObscure = true;

  Future<void> login() async {
    if (formKey.currentState!.validate()) {
      emit(LoginLoadingState());
      try {
        final response = await dioManager.post(
          UrlsStrings.loginUrl,
          data: json.encode({
            "username": controllers.usernameController.text,
            "password": controllers.passwordController.text,
          }),
        );

        if (response.statusCode == 201) {
          emit(LoginSuccessState());

          CacheHelper.put(
            key: 'access_token',
            value: "${response.data['access_token']}",
          );
          CacheHelper.put(
            key: 'id',
            value: "${response.data['_id']}",
          );
          logger.i(response.data["_id"]);
        } else {
          emit(LoginFailedState(msg: response.data["message"]));
        }
      } on DioException catch (e) {
        handleDioException(e);
      } catch (e) {
        emit(LoginFailedState(msg: 'An unknown error: $e'));
        logger.e(e);
      }
    }
  }

  void handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.cancel:
        emit(LoginFailedState(msg: "Request was cancelled"));
        break;
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        emit(NetworkErrorState());
        break;
      case DioExceptionType.badResponse:
        emit(LoginFailedState(msg: e.response?.data["message"]));
        break;
      default:
        emit(NetworkErrorState());
    }
    logger.e(e);
  }

  changeVisibility() {
    isObscure = !isObscure;
    emit(ChanceVisibilityState());
  }

  setBaseUrl(String baseUrl) {
    dioManager.setBaseUrl(baseUrl);
  }

  @override
  Future<void> close() {
    controllers.dispose();
    return super.close();
  }
}
