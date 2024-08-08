import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:verify_serial/core/helpers/navigator.dart';
import '../../core/helpers/cache_helper.dart';
import '../../core/networking/dio_helper.dart';
import '../../core/networking/urls_strings.dart';
import 'states.dart';

class VerifyCubit extends Cubit<VerifyStates> {
  VerifyCubit() : super(VerifyInitialState());

  final formKey = GlobalKey<FormState>();
  final dioManager = DioManager();
  final logger = Logger();
  final fieldController = TextEditingController();

  Future<void> verify() async {
    if (formKey.currentState!.validate()) {
      emit(VerifyLoadingState());
      try {
        final response = await dioManager.post(
          UrlsStrings.verifyCodeUrl,
          data: json.encode({
            "serialNo": fieldController.text,
          }),
        );

        if (response.statusCode == 201) {
          MagicRouter.navigatePop();
          emit(VerifySuccessState());

          logger.i(response.data);
        } else {
          emit(VerifyFailedState(msg: response.data["message"]));
        }
      } on DioException catch (e) {
        handleDioException(e);
      } catch (e) {
        emit(VerifyFailedState(msg: 'An unknown error: $e'));
        logger.e(e);
      }
    }
  }

  void handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.cancel:
        emit(VerifyFailedState(msg: "Request was cancelled"));
        break;
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        emit(VerifyNetworkErrorState());
        break;
      case DioExceptionType.badResponse:
        emit(VerifyFailedState(msg: e.response?.data["message"]));
        break;
      default:
        emit(VerifyNetworkErrorState());
    }
    logger.e(e);
  }

  setBaseUrl(String baseUrl) {
    dioManager.setBaseUrl(baseUrl);
  }

  @override
  Future<void> close() {
    fieldController.dispose();
    return super.close();
  }
}
