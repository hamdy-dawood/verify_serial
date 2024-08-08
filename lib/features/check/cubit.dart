import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import '../../core/networking/dio_helper.dart';
import '../../core/networking/urls_strings.dart';
import 'states.dart';

class CheckCubit extends Cubit<CheckStates> {
  CheckCubit() : super(CheckInitialState());

  static CheckCubit get(context) => BlocProvider.of(context);

  final dioManager = DioManager();
  final logger = Logger();

  var barcodeController = TextEditingController();

  final scannerScaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> check() async {
    emit(CheckLoadingState());
    try {
      final response = await dioManager.get(
        UrlsStrings.checkCodeUrl,
        json: {
          "serialNo": barcodeController.text,
        },
      );

      if (response.statusCode == 200) {
        if (response.data["authorized"]) {
          emit(CheckApprovedState());
        } else {
          emit(CheckFailedApprovedState());
        }
        barcodeController.clear();
        logger.i(response.data);
      } else {
        emit(CheckFailedState(msg: response.data["message"]));
        barcodeController.clear();
      }
    } on DioException catch (e) {
      handleDioException(e);
    } catch (e) {
      emit(CheckFailedState(msg: 'An unknown error: $e'));
      logger.e(e);
    }
  }

  void handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.cancel:
        emit(CheckFailedState(msg: "Request was cancelled"));
        break;
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        emit(NetworkErrorState());
        break;
      case DioExceptionType.badResponse:
        emit(CheckFailedState(msg: e.response?.data["message"]));
        break;
      default:
        emit(NetworkErrorState());
    }
    logger.e(e);
  }
}
